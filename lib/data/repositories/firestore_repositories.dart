import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/action.dart';
import '../../domain/models/audit_log.dart';
import '../../domain/models/consent.dart';
import '../../domain/models/health_sample.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/score.dart';
import '../../domain/repositories/action_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/repositories/membership_repository.dart';

// --- Helper to safely parse Datetime from Firestore Timestamps ---
DateTime _parseDateTime(dynamic field) {
  if (field is Timestamp) return field.toDate();
  if (field is String) return DateTime.tryParse(field) ?? DateTime.now();
  return DateTime.now();
}

class FirestoreMembershipRepository implements MembershipRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<Membership?> getMembership(String userId) async {
    final snap = await _db.collection('memberships').doc(userId).get();
    if (!snap.exists || snap.data() == null) return null;
    
    final data = snap.data()!;
    return Membership(
      userId: userId,
      email: data['email'] as String? ?? '',
      orgId: data['orgId'] as String? ?? '',
      role: data['role'] as String? ?? 'employee',
      teamId: data['teamId'] as String?,
      managedTeamIds: (data['managedTeamIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  @override
  Future<List<Membership>> getTeamMemberships(String teamId) async {
    final query = await _db.collection('memberships').where('teamId', isEqualTo: teamId).get();
    return query.docs.map((doc) {
      final data = doc.data();
      return Membership(
        userId: doc.id,
        email: data['email'] as String? ?? '',
        orgId: data['orgId'] as String? ?? '',
        role: data['role'] as String? ?? 'employee',
        teamId: data['teamId'] as String?,
        managedTeamIds: (data['managedTeamIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    }).toList();
  }

  @override
  Future<List<Membership>> getOrgMemberships(String orgId) async {
    final query = await _db.collection('memberships').where('orgId', isEqualTo: orgId).get();
    return query.docs.map((doc) {
      final data = doc.data();
      return Membership(
        userId: doc.id,
        email: data['email'] as String? ?? '',
        orgId: data['orgId'] as String? ?? '',
        role: data['role'] as String? ?? 'employee',
        teamId: data['teamId'] as String?,
        managedTeamIds: (data['managedTeamIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    }).toList();
  }

  @override
  Future<void> updateMembership(Membership membership) async {
    await _db.collection('memberships').doc(membership.userId).set({
      'userId': membership.userId,
      'email': membership.email,
      'orgId': membership.orgId,
      'role': membership.role,
      'teamId': membership.teamId,
      'managedTeamIds': membership.managedTeamIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

class FirestoreHealthRepository implements HealthRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> saveSamples(List<HealthSample> samples) async {
    final batch = _db.batch();
    for (final sample in samples) {
      final ref = _db.collection('healthSamples').doc(sample.id);
      batch.set(ref, {
        'id': sample.id,
        'userId': sample.userId,
        'type': sample.type,
        'value': sample.value,
        'timestamp': sample.timestamp,
        'deviceSource': sample.deviceSource,
      });
    }
    await batch.commit();
  }

  @override
  Future<List<HealthSample>> getSamples(String userId, DateTime start, DateTime end) async {
    final query = await _db.collection('healthSamples')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThanOrEqualTo: end)
        .get();
        
    return query.docs.map((doc) {
      final data = doc.data();
      return HealthSample(
        id: data['id'] as String? ?? doc.id,
        userId: data['userId'] as String? ?? '',
        type: data['type'] as String? ?? '',
        value: (data['value'] as num).toDouble(),
        timestamp: _parseDateTime(data['timestamp']),
        deviceSource: data['deviceSource'] as String? ?? 'wearable',
      );
    }).toList();
  }

  @override
  Future<void> saveScore(Score score) async {
    await _db.collection('scores').doc(score.id).set({
      'id': score.id,
      'userId': score.userId,
      'orgId': score.orgId,
      'teamId': score.teamId,
      'burnoutIndex': score.burnoutIndex,
      'subscores': {
        'sleep': score.subscores.sleep,
        'recovery': score.subscores.recovery,
        'stress': score.subscores.stress,
        'load': score.subscores.load,
      },
      'calculatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Score?> getLastScore(String userId) async {
    final query = await _db.collection('scores')
        .where('userId', isEqualTo: userId)
        .orderBy('calculatedAt', descending: true)
        .limit(1)
        .get();
        
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    final data = doc.data();
    final sub = data['subscores'] as Map<String, dynamic>;
    
    return Score(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      orgId: data['orgId'] as String? ?? '',
      teamId: data['teamId'] as String? ?? '',
      burnoutIndex: (data['burnoutIndex'] as num).toDouble(),
      subscores: Subscores(
        sleep: (sub['sleep'] as num).toDouble(),
        recovery: (sub['recovery'] as num).toDouble(),
        stress: (sub['stress'] as num).toDouble(),
        load: (sub['load'] as num).toDouble(),
      ),
      calculatedAt: _parseDateTime(data['calculatedAt']),
    );
  }

  @override
  Future<List<Score>> getTeamLatestScores(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    
    // Fetch latest score for each user individually to avoid complex IN queries
    final List<Score> scores = [];
    for (final uid in userIds) {
      final s = await getLastScore(uid);
      if (s != null) {
        scores.add(s);
      }
    }
    return scores;
  }
}

class FirestoreConsentRepository implements ConsentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<Consent?> getConsent(String userId) async {
    final snap = await _db.collection('consents').doc(userId).get();
    if (!snap.exists || snap.data() == null) return null;
    
    final data = snap.data()!;
    return Consent(
      userId: userId,
      sharingEnabled: data['sharingEnabled'] as bool? ?? false,
      actionsEnabled: data['actionsEnabled'] as bool? ?? false,
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  @override
  Future<void> saveConsent(Consent consent) async {
    await _db.collection('consents').doc(consent.userId).set({
      'userId': consent.userId,
      'sharingEnabled': consent.sharingEnabled,
      'actionsEnabled': consent.actionsEnabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Consent?> watchConsent(String userId) {
    return _db.collection('consents').doc(userId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        return Consent(
          userId: userId,
          sharingEnabled: false,
          actionsEnabled: false,
          updatedAt: DateTime.now(),
        );
      }
      final data = snap.data()!;
      return Consent(
        userId: userId,
        sharingEnabled: data['sharingEnabled'] as bool? ?? false,
        actionsEnabled: data['actionsEnabled'] as bool? ?? false,
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    });
  }
}

class FirestoreActionRepository implements ActionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> sendAction(ActionInstance action) async {
    await _db.collection('actions').doc(action.id).set({
      'id': action.id,
      'orgId': action.orgId,
      'teamId': action.teamId,
      'type': action.type,
      'targetUserId': action.targetUserId,
      'senderUserId': action.senderUserId,
      'status': action.status,
      'payload': action.payload,
      'createdAt': action.createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateActionStatus(String actionId, String status) async {
    await _db.collection('actions').doc(actionId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<ActionInstance>> getActionsForUser(String userId) async {
    final query = await _db.collection('actions')
        .where('targetUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
        
    return query.docs.map((doc) {
      final data = doc.data();
      return ActionInstance(
        id: doc.id,
        orgId: data['orgId'] as String? ?? '',
        teamId: data['teamId'] as String? ?? '',
        type: data['type'] as String? ?? '',
        targetUserId: data['targetUserId'] as String? ?? '',
        senderUserId: data['senderUserId'] as String? ?? '',
        status: data['status'] as String? ?? 'sent',
        payload: data['payload'] as Map<String, dynamic>?,
        createdAt: _parseDateTime(data['createdAt']),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    }).toList();
  }

  @override
  Future<List<ActionInstance>> getActionsSentByUser(String senderUserId) async {
    final query = await _db.collection('actions')
        .where('senderUserId', isEqualTo: senderUserId)
        .orderBy('createdAt', descending: true)
        .get();
        
    return query.docs.map((doc) {
      final data = doc.data();
      return ActionInstance(
        id: doc.id,
        orgId: data['orgId'] as String? ?? '',
        teamId: data['teamId'] as String? ?? '',
        type: data['type'] as String? ?? '',
        targetUserId: data['targetUserId'] as String? ?? '',
        senderUserId: data['senderUserId'] as String? ?? '',
        status: data['status'] as String? ?? 'sent',
        payload: data['payload'] as Map<String, dynamic>?,
        createdAt: _parseDateTime(data['createdAt']),
        updatedAt: _parseDateTime(data['updatedAt']),
      );
    }).toList();
  }

  @override
  Stream<List<ActionInstance>> watchActionsForUser(String userId) {
    return _db.collection('actions')
        .where('targetUserId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) {
            final data = doc.data();
            return ActionInstance(
              id: doc.id,
              orgId: data['orgId'] as String? ?? '',
              teamId: data['teamId'] as String? ?? '',
              type: data['type'] as String? ?? '',
              targetUserId: data['targetUserId'] as String? ?? '',
              senderUserId: data['senderUserId'] as String? ?? '',
              status: data['status'] as String? ?? 'sent',
              payload: data['payload'] as Map<String, dynamic>?,
              createdAt: _parseDateTime(data['createdAt']),
              updatedAt: _parseDateTime(data['updatedAt']),
            );
          }).toList();
          
          // Sort locally in case composite query orders are not fully indexed on empty starts
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }
}

class FirestoreAuditRepository implements AuditRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> logAccess(AuditLog log) async {
    await _db.collection('audit_logs').doc(log.id).set({
      'id': log.id,
      'actorUserId': log.actorUserId,
      'actorRole': log.actorRole,
      'actionType': log.actionType,
      'orgId': log.orgId,
      'targetUserId': log.targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'details': log.details,
    });
  }

  @override
  Future<List<AuditLog>> getLogsForOrg(String orgId) async {
    final query = await _db.collection('audit_logs')
        .where('orgId', isEqualTo: orgId)
        .get();
        
    final list = query.docs.map((doc) {
      final data = doc.data();
      return AuditLog(
        id: doc.id,
        actorUserId: data['actorUserId'] as String? ?? '',
        actorRole: data['actorRole'] as String? ?? '',
        actionType: data['actionType'] as String? ?? '',
        orgId: data['orgId'] as String? ?? '',
        targetUserId: data['targetUserId'] as String?,
        timestamp: _parseDateTime(data['timestamp']),
        details: data['details'] as String?,
      );
    }).toList();
    
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }
}
