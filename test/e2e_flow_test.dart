import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burnout_meter_app/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burnout_meter_app/shared/config/seed_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Firebase for the test VM
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "demo-burnoutmeter-api-key",
          authDomain: "demo-burnoutmeter.firebaseapp.com",
          projectId: "demo-burnoutmeter",
          storageBucket: "demo-burnoutmeter.appspot.com",
          messagingSenderId: "1234567890",
          appId: "1:1234567890:web:1234567890",
        ),
      );
      const host = '127.0.0.1';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    } catch (e) {
      debugPrint('Firebase already initialized or emulator setup failed: $e');
    }
  });

  group('BurnoutMeter Headless E2E Flow Validation', () {
    testWidgets('Full verification of all roles and routing against Real Emulators', (WidgetTester tester) async {
      // 0. Ensure deterministic state by logging out any residual cached sessions
      await FirebaseAuth.instance.signOut();
      
      // 1. Boot up the app
      await tester.pumpWidget(const ProviderScope(child: app.BurnoutMeterApp()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Trigger Seeding
      final seedButton = find.text('Inicializar DB Local (Seed)');
      expect(seedButton, findsOneWidget);
      await tester.tap(seedButton);
      
      // Wait for seeding to complete and snackbar to appear
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 3. Employee Flow (Alan)
      final alanButton = find.text('Alan (Empleado • teamEng)');
      expect(alanButton, findsOneWidget);
      await tester.tap(alanButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Employee Dashboard
      expect(find.textContaining('Tu estado actual'), findsWidgets);
      
      // Perform Logout
      final logoutButton = find.byIcon(Icons.logout);
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 4. Manager Flow (Victor)
      final victorButton = find.text('Victor (Manager • teamEng)');
      expect(victorButton, findsOneWidget);
      await tester.tap(victorButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Manager Dashboard
      expect(find.textContaining('BurnoutMeter Manager Console'), findsWidgets);
      
      // Logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 5. Admin Flow (Admin)
      final adminButton = find.text('Admin (Global multi-tenant)');
      expect(adminButton, findsOneWidget);
      await tester.tap(adminButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Admin Dashboard
      expect(find.textContaining('Admin Overview'), findsWidgets);
      
      // Logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
