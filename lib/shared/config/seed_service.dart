import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SeedService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static bool isSeeding = false;

  /// Idempotently seed Auth and Firestore databases inside the local emulator.
  static Future<void> seedDatabase() async {
    isSeeding = true;
    debugPrint('🌱 Starting BurnoutMeter Seeding process...');

    // 1. Core seed users parameters
    final List<Map<String, dynamic>> seedUsers = [
      // ADMIN
      {
        'uid': 'adm789',
        'email': 'admin@burnoutmeter.demo',
        'password': 'password123',
        'role': 'admin',
        'orgId': 'org789',
        'teamId': null,
        'managedTeamIds': null,
      },
      // MANAGERS
      {
        'uid': 'mgrEng',
        'email': 'manager_eng@burnoutmeter.demo',
        'password': 'password123',
        'role': 'manager',
        'orgId': 'org789',
        'teamId': null,
        'managedTeamIds': ['teamEng'],
      },
      {
        'uid': 'mgrCS',
        'email': 'manager_cs@burnoutmeter.demo',
        'password': 'password123',
        'role': 'manager',
        'orgId': 'org789',
        'teamId': null,
        'managedTeamIds': ['teamCS'],
      },
      // EMPLOYEES
      {
        'uid': 'emp123', // Alan
        'email': 'employee_eng1@burnoutmeter.demo',
        'password': 'password123',
        'role': 'employee',
        'orgId': 'org789',
        'teamId': 'teamEng',
        'managedTeamIds': null,
        'consent': {'sharingEnabled': true, 'actionsEnabled': true},
        'score': 32.0, // Healthy score
      },
      {
        'uid': 'empEng2', // Sofía (sharing turned off!)
        'email': 'employee_eng2@burnoutmeter.demo',
        'password': 'password123',
        'role': 'employee',
        'orgId': 'org789',
        'teamId': 'teamEng',
        'managedTeamIds': null,
        'consent': {'sharingEnabled': false, 'actionsEnabled': true},
        'score': 68.0, // High stress score
      },
      {
        'uid': 'empCS1', // Tomás (actions blocked!)
        'email': 'employee_cs1@burnoutmeter.com',
        'password': 'password123',
        'role': 'employee',
        'orgId': 'org789',
        'teamId': 'teamCS',
        'managedTeamIds': null,
        'consent': {'sharingEnabled': true, 'actionsEnabled': false},
        'score': 45.0, // Moderate stress
      },
    ];

    for (final user in seedUsers) {
      final String email = user['email'] as String;
      final String password = user['password'] as String;
      String realUid;

      // A. Register in Auth or Sign In to retrieve the dynamic real UID (idempotent wrap)
      try {
        final creds = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        realUid = creds.user!.uid;
        debugPrint('✅ Seed user created: $email (UID: $realUid)');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // If the user already exists in the emulator, log in temporarily to get their real UID
          final creds = await _auth.signInWithEmailAndPassword(email: email, password: password);
          realUid = creds.user!.uid;
          debugPrint('ℹ️ Auth User already exists: $email. Retrieved UID: $realUid');
        } else {
          debugPrint('❌ Error seeding Auth user $email: $e');
          continue;
        }
      }

      // B. Seed Membership in Firestore using the real UID
      await _db.collection('memberships').doc(realUid).set({
        'userId': realUid,
        'email': email,
        'orgId': user['orgId'],
        'teamId': user['teamId'],
        'role': user['role'],
        'managedTeamIds': user['managedTeamIds'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Membership doc seeded for: $email with UID: $realUid');

      // C. Seed Privacy Consents & Scores (Only for Employees)
      if (user['role'] == 'employee') {
        final consent = user['consent'] as Map<String, bool>;
        await _db.collection('consents').doc(realUid).set({
          'userId': realUid,
          'sharingEnabled': consent['sharingEnabled'],
          'actionsEnabled': consent['actionsEnabled'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('✅ Consent seeded for: $email');

        final double initialScore = user['score'] as double;
        final String scoreId = 'score_${realUid}_initial';
        await _db.collection('scores').doc(scoreId).set({
          'id': scoreId,
          'userId': realUid,
          'orgId': user['orgId'],
          'teamId': user['teamId'],
          'burnoutIndex': initialScore,
          'subscores': {
            'sleep': 85.0,
            'recovery': 70.0,
            'stress': initialScore,
            'load': 50.0,
          },
          'calculatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('✅ Initial score doc seeded for: $email');
      }
    }

    // D. Mark database as seeded in public metadata
    await _db.collection('seed_status').doc('seeded').set({
      'isSeeded': true,
      'seededAt': FieldValue.serverTimestamp(),
    });
    debugPrint('✅ Public seed status updated in seed_status/seeded');

    // 2. Always sign out at the end of the seed to let the user select any demo profile cleanly
    await _auth.signOut();

    isSeeding = false;
    debugPrint('🌱 Seeding process complete!');
  }

  /// Check if the database has already been seeded.
  static Future<bool> isDatabaseSeeded() async {
    try {
      final doc = await _db.collection('seed_status').doc('seeded').get();
      return doc.exists && doc.data()?['isSeeded'] == true;
    } catch (e) {
      debugPrint('Error checking if database is seeded: $e');
      return false;
    }
  }
}
