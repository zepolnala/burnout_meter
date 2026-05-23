import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/membership.dart';
import '../logging/app_logger.dart';

class AuthNotifier extends StateNotifier<AsyncValue<Membership?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _membershipSubscription;

  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    AppLogger.startup('Initializing AuthNotifier and subscribing to authStateChanges.');
    
    // 1. Listen to Firebase Auth state changes
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        AppLogger.auth('No active Firebase Auth session detected.');
        _membershipSubscription?.cancel();
        state = const AsyncValue.data(null);
      } else {
        AppLogger.auth('Firebase Auth session detected for user: ${user.email} (UID: ${user.uid})');
        
        // 2. Active Session: Subscribe dynamically to Firestore membership
        _membershipSubscription?.cancel();
        _membershipSubscription = _db
            .collection('memberships')
            .doc(user.uid)
            .snapshots()
            .listen((DocumentSnapshot snap) {
          if (snap.exists && snap.data() != null) {
            final data = snap.data() as Map<String, dynamic>;
            final membership = Membership(
              userId: user.uid,
              email: user.email ?? '',
              orgId: data['orgId'] as String? ?? 'org789',
              teamId: data['teamId'] as String?,
              role: data['role'] as String? ?? 'employee',
              updatedAt: data['updatedAt'] != null
                  ? (data['updatedAt'] is String
                      ? DateTime.parse(data['updatedAt'] as String)
                      : (data['updatedAt'] as Timestamp).toDate())
                  : DateTime.now(),
            );
            AppLogger.firestore('Dynamic membership loaded for UID: ${user.uid} (Role: ${membership.role}, OrgId: ${membership.orgId})');
            state = AsyncValue.data(membership);
          } else {
            AppLogger.firestore('No Firestore membership document found for UID: ${user.uid}. Falling back to default employee.');
            state = AsyncValue.data(Membership(
              userId: user.uid,
              email: user.email ?? '',
              orgId: 'org789',
              teamId: null,
              role: 'employee',
              updatedAt: DateTime.now(),
            ));
          }
        }, onError: (Object err, StackTrace stack) {
          AppLogger.firestore('Error reading membership document for UID: ${user.uid}: $err');
          state = AsyncValue.error(err, stack);
        });
      }
    }, onError: (Object err, StackTrace stack) {
      AppLogger.auth('Error listening to authStateChanges: $err');
      state = AsyncValue.error(err, stack);
    });
  }

  /// Sign in using standard credentials
  Future<void> login(String email, String password) async {
    AppLogger.auth('Attempting sign-in for email: $email...');
    state = const AsyncValue.loading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      AppLogger.auth('Successfully signed in user: $email');
    } catch (e, stack) {
      AppLogger.auth('Failed sign-in for email: $email. Error: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Register a new user and transacted membership/consent templates
  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String orgId,
    String? teamId,
    List<String>? managedTeamIds,
  }) async {
    AppLogger.auth('Registering new user email: $email (Role: $role)...');
    state = const AsyncValue.loading();
    try {
      // 1. Create account
      final creds = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = creds.user!.uid;

      // 2. Seed Membership in Firestore
      await _db.collection('memberships').doc(uid).set({
        'userId': uid,
        'email': email,
        'orgId': orgId,
        'teamId': teamId,
        'role': role,
        'managedTeamIds': managedTeamIds,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Set standard consent and initial scores for employees
      if (role == 'employee') {
        await _db.collection('consents').doc(uid).set({
          'userId': uid,
          'sharingEnabled': true,
          'actionsEnabled': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final scoreId = 'score_${uid}_initial';
        await _db.collection('scores').doc(scoreId).set({
          'id': scoreId,
          'userId': uid,
          'orgId': orgId,
          'teamId': teamId ?? 'teamEng',
          'burnoutIndex': 35.0,
          'subscores': {
            'sleep': 80.0,
            'recovery': 70.0,
            'stress': 35.0,
            'load': 40.0,
          },
          'calculatedAt': FieldValue.serverTimestamp(),
        });
      }

      AppLogger.auth('Successfully registered new user: $email (UID: $uid)');
    } catch (e, stack) {
      AppLogger.auth('Failed registration for email: $email. Error: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Tear down active session
  Future<void> logout() async {
    AppLogger.auth('Attempting sign-out active session...');
    state = const AsyncValue.loading();
    try {
      await _auth.signOut();
      AppLogger.auth('Successfully signed out active session.');
    } catch (e, stack) {
      AppLogger.auth('Failed active session sign-out: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Quick demo switcher bypassing prompt for evaluators
  Future<void> switchToUser(String mockId) async {
    AppLogger.auth('Demo Quick Switcher triggered for mockId: $mockId');
    String email;
    if (mockId == 'emp123') {
      email = 'employee_eng1@burnoutmeter.demo';
    } else if (mockId == 'mgr456') {
      email = 'manager_eng@burnoutmeter.demo';
    } else if (mockId == 'adm789') {
      email = 'admin@burnoutmeter.demo';
    } else {
      AppLogger.auth('Unknown mockId: $mockId');
      return;
    }
    await login(email, 'password123');
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _membershipSubscription?.cancel();
    super.dispose();
  }
}

/// Global provider managing active user session
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Membership?>>((ref) {
  return AuthNotifier();
});
