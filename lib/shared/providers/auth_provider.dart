import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/membership.dart';
import '../logging/app_logger.dart';

class AuthNotifier extends StateNotifier<AsyncValue<Membership?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _authSubscription;
  StreamSubscription? _membershipSubscription;

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
      email = 'employee_eng1@burnoutmeter.com';
    } else if (mockId == 'mgr456') {
      email = 'manager_eng@burnoutmeter.com';
    } else if (mockId == 'adm789') {
      email = 'admin@burnoutmeter.com';
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
