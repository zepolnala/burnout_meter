const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

/**
 * Triggered whenever a new wellness intervention action is created.
 * Dispatches an FCM push notification or registers an in-app alert
 * for the target employee.
 */
exports.sendActionNotification = functions.firestore
    .document("actions/{actionId}")
    .onCreate(async (snap, context) => {
      const action = snap.data();
      const targetUserId = action.targetUserId;

      try {
        // 1. Fetch target user token
        const userDoc = await db.collection("memberships").doc(targetUserId).get();
        if (!userDoc.exists) {
          functions.logger.warn(`User ${targetUserId} has no membership document.`);
          return null;
        }

        const member = userDoc.data();
        const fcmToken = member.fcmToken;

        if (!fcmToken) {
          functions.logger.info(`User ${targetUserId} does not have an FCM token registered.`);
          return null;
        }

        // 2. Map intervention types to descriptive messages
        const messages = {
          suggest_break: "Tu Manager te sugiere tomar una pausa breve de descanso hoy.",
          offer_1on1: "Tu Manager te propone conversar en privado en una sesión 1:1.",
          share_resource: "Se ha compartido un nuevo recurso de bienestar contigo.",
          recommend_time_off: "Se te sugiere tomar un tiempo libre para mitigar la sobrecarga.",
          wellness_check: "¿Cómo estás hoy? Responde a nuestro breve control de bienestar.",
        };

        const body = messages[action.type] || "Tu Manager ha compartido una sugerencia de bienestar.";

        // 3. Send via Firebase Cloud Messaging (FCM)
        const payload = {
          notification: {
            title: "Recomendación de Bienestar - BurnoutMeter",
            body: body,
          },
          data: {
            actionId: snap.id,
            type: action.type,
          },
        };

        await admin.messaging().sendToDevice(fcmToken, payload);
        functions.logger.info(`FCM notification sent successfully to ${targetUserId}`);
        return null;
      } catch (error) {
        functions.logger.error("Failed to relay action notification:", error);
        throw new functions.https.HttpsError("internal", "Notification failure.");
      }
    });

/**
 * Computes aggregated scores at the team level whenever an employee score updates.
 * STRICT PRIVACY REQUIREMENT: To prevent identification of individual burnout risk,
 * aggregates are only calculated and saved if there are AT LEAST 5 (N >= 5) active
 * members sharing their score within the team.
 */
exports.aggregateTeamScores = functions.firestore
    .document("scores/{scoreId}")
    .onWrite(async (change, context) => {
      const scoreData = change.after.exists ? change.after.data() : change.before.data();
      const teamId = scoreData.teamId;
      const orgId = scoreData.orgId;

      if (!teamId) return null;

      try {
        // 1. Get all memberships in this team
        const membershipsSnap = await db.collection("memberships")
            .where("teamId", "==", teamId)
            .get();

        const memberIds = membershipsSnap.docs.map((doc) => doc.id);
        if (memberIds.length === 0) return null;

        // 2. Fetch consents for these members
        const consentsSnap = await db.collection("consents")
            .where(admin.firestore.FieldPath.documentId(), "in", memberIds)
            .get();

        const consentedUserIds = [];
        consentsSnap.forEach((doc) => {
          if (doc.data().sharingEnabled === true) {
            consentedUserIds.push(doc.id);
          }
        });

        // 3. SECURE THRESHOLD GUARD: Anonymization barrier
        const MIN_ANONYMIZATION_N = 5;
        const aggregateRef = db.collection("team_aggregates").doc(teamId);

        if (consentedUserIds.length < MIN_ANONYMIZATION_N) {
          functions.logger.info(`Anonymization barrier active for team ${teamId}. Active sharing members N=${consentedUserIds.length} < ${MIN_ANONYMIZATION_N}. Masking aggregate.`);
          // Save a masked placeholder so that the dashboard knows it is hidden for privacy
          await aggregateRef.set({
            orgId: orgId,
            teamId: teamId,
            averageBurnoutIndex: null,
            status: "masked_under_threshold",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          return null;
        }

        // 4. Fetch the latest score for each consented user
        const latestScoresPromises = consentedUserIds.map((uid) => {
          return db.collection("scores")
              .where("userId", "==", uid)
              .orderBy("calculatedAt", "desc")
              .limit(1)
              .get();
        });

        const scoresSnaps = await Promise.all(latestScoresPromises);
        let sum = 0;
        let count = 0;

        scoresSnaps.forEach((snap) => {
          if (!snap.empty) {
            const scoreDoc = snap.docs[0].data();
            sum += scoreDoc.burnoutIndex;
            count++;
          }
        });

        if (count === 0) return null;

        const average = sum / count;

        // 5. Update team aggregate score document securely
        await aggregateRef.set({
          orgId: orgId,
          teamId: teamId,
          averageBurnoutIndex: average,
          status: "active",
          activeMembersCount: count,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        functions.logger.info(`Computed team aggregate for ${teamId}: avg=${average} (N=${count})`);
        return null;
      } catch (error) {
        functions.logger.error("Failed to calculate team aggregates:", error);
        return null;
      }
    });
