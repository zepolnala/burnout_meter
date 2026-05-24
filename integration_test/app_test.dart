import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burnout_meter_app/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:burnout_meter_app/presentation/shared/onboarding_dialog.dart';
import 'package:burnout_meter_app/presentation/shared/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BurnoutMeter E2E Flow Validation', () {
    testWidgets('Full verification of all roles and routing', (WidgetTester tester) async {
      // 1. Boot up the app (Initializes Firebase)
      await app.main();
      await tester.pumpAndSettle();

      // 2. Ensure deterministic state by logging out any residual cached sessions
      await FirebaseAuth.instance.signOut();
      await tester.pumpAndSettle();

      // 2. Trigger Seeding
      final seedButton = find.text('Sembrar Base de Datos');
      expect(seedButton, findsOneWidget);
      await tester.tap(seedButton);
      
      // Wait dynamically for seeding to complete and write memberships to Firestore (handles async latency in CI)
      int seedRetries = 20;
      while (find.text('REALIZADO').evaluate().isEmpty && seedRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        seedRetries--;
      }
      expect(find.text('REALIZADO'), findsOneWidget);

      // 3. Employee Flow (Alan)
      final alanButton = find.textContaining('Alan (Empleado', skipOffstage: false);
      expect(alanButton, findsOneWidget);
      await tester.tap(alanButton);
      await tester.pump(); // Kick off the async login

      // Wait for GoRouter to redirect away from /login.
      // Use a retry loop (same pattern as seeding) because Firebase Auth +
      // Firestore membership stream resolution is async and pumpAndSettle
      // may settle before the stream emits the membership.
      int loginRetries = 30;
      while (
        find.byType(LoginScreen).evaluate().isNotEmpty &&
        loginRetries > 0
      ) {
        await tester.pump(const Duration(milliseconds: 500));
        loginRetries--;
      }

      // Verify we navigated away from LoginScreen after authentication.
      if (find.byType(LoginScreen).evaluate().isNotEmpty) {
        fail(
          'Employee login did not redirect away from /login after 15 seconds. '
          'Check GoRouter redirect() logic and auth state propagation.',
        );
      }

      // Verify routing landed in Employee Dashboard FIRST
      // Close the OnboardingDialog reactively the moment it appears
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(OnboardingDialog).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.close).first);
          await tester.pumpAndSettle();
          break;
        }
      }

      // Verify routing landed in Employee Dashboard FIRST
      int empRetries = 30;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty && empRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        empRetries--;
      }
      
      if (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty) {
        print('EMPLOYEE DASHBOARD NOT FOUND!');
        print('Dumping Widget Tree:');
        debugDumpApp();
        await Future<void>.delayed(const Duration(seconds: 1)); // allow time to flush
      }
      
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO'), findsWidgets);

      // Close the Wearable Onboarding modal next
      int wearableRetries = 30;
      while (find.text('Decidir más tarde / Cancelar').evaluate().isEmpty && wearableRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        wearableRetries--;
      }
      final closeWearableButton = find.text('Decidir más tarde / Cancelar');
      expect(closeWearableButton, findsOneWidget);
      await tester.tap(closeWearableButton);
      await tester.pumpAndSettle();
      
      // Perform Logout
      final logoutButton = find.byIcon(Icons.exit_to_app);
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pump();
      // Wait to return to login screen
      int empLogoutRetries = 20;
      while (find.byType(LoginScreen).evaluate().isEmpty && empLogoutRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        empLogoutRetries--;
      }

      // 4. Manager Flow (Victor)
      final victorButton = find.text('Victor (Manager • Acme Corp: lidera teamEng)');
      expect(victorButton, findsOneWidget);
      await tester.tap(victorButton);
      await tester.pump();

      // Wait for manager redirect
      int mgrLoginRetries = 30;
      while (
        find.byType(LoginScreen).evaluate().isNotEmpty &&
        mgrLoginRetries > 0
      ) {
        await tester.pump(const Duration(milliseconds: 500));
        mgrLoginRetries--;
      }

      // Close the OnboardingDialog reactively the moment it appears
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(OnboardingDialog).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.close).first);
          await tester.pumpAndSettle();
          break;
        }
      }

      // Verify routing landed in Manager Dashboard FIRST
      int mgrRetries = 30;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty && mgrRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        mgrRetries--;
      }
      
      if (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty) {
        print('MANAGER DASHBOARD NOT FOUND!');
        print('Dumping Widget Tree:');
        debugDumpApp();
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO'), findsWidgets);
      
      // Explicitly check that there is NO permission denied error for scores
      expect(find.textContaining('Error al cargar scores:'), findsNothing);
      expect(find.textContaining('permission-denied'), findsNothing);
      expect(find.textContaining('Null value error'), findsNothing);

      // Verify that at least one member name is visible
      expect(find.text('Alan (Empleado Demo)'), findsWidgets);
      
      // Logout and wait to return to login screen
      await tester.tap(logoutButton);
      await tester.pump();
      int mgrLogoutRetries = 20;
      while (find.byType(LoginScreen).evaluate().isEmpty && mgrLogoutRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        mgrLogoutRetries--;
      }

      // 5. Admin Flow (Admin)
      final adminButton = find.text('Admin (Global • Acme Corp: multi-tenant)');
      expect(adminButton, findsOneWidget);
      await tester.tap(adminButton);
      await tester.pump();

      // Wait for admin redirect
      int admLoginRetries = 30;
      while (
        find.byType(LoginScreen).evaluate().isNotEmpty &&
        admLoginRetries > 0
      ) {
        await tester.pump(const Duration(milliseconds: 500));
        admLoginRetries--;
      }

      // Close the OnboardingDialog reactively the moment it appears
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(OnboardingDialog).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.close).first);
          await tester.pumpAndSettle();
          break;
        }
      }

      // Verify routing landed in Admin Dashboard (handles async Firestore lag in CI)
      int admRetries = 30;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty && admRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        admRetries--;
      }
      
      if (find.textContaining('GUÍA DE EVALUACIÓN CTO').evaluate().isEmpty) {
        print('ADMIN DASHBOARD NOT FOUND!');
        print('Dumping Widget Tree:');
        debugDumpApp();
        await Future<void>.delayed(const Duration(seconds: 1));
      }

      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO'), findsWidgets);
      
      // Logout
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
    });
  });
}
