import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Connect to Emulators
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  print('🔥 Connected to Firebase Emulators');

  try {
    // 1. Log in as Manager
    print('👤 Logging in as manager_eng@burnoutmeter.demo...');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'manager_eng@burnoutmeter.demo',
      password: 'password123',
    );
    final user = FirebaseAuth.instance.currentUser;
    print('✅ Logged in as: ${user?.uid}');

    // 2. Fetch team members (memberships)
    print('📋 Fetching team members for teamEng...');
    final membersQuery = await FirebaseFirestore.instance
        .collection('memberships')
        .where('teamId', isEqualTo: 'teamEng')
        .get();
    
    print('✅ Found ${membersQuery.docs.length} members.');

    // 3. Fetch scores
    print('📊 Fetching burnout scores for teamEng...');
    final scoresQuery = await FirebaseFirestore.instance
        .collection('scores')
        .where('teamId', isEqualTo: 'teamEng')
        .get();

    print('✅ Found ${scoresQuery.docs.length} scores without permission errors!');
    print('🎉 SUCCESS: The Manager flow data can be loaded successfully!');
    
  } catch (e, stack) {
    print('❌ ERROR: $e');
    print(stack);
  } finally {
    await FirebaseAuth.instance.signOut();
    print('👋 Logged out.');
  }
}
