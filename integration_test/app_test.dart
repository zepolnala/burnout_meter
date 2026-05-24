import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:burnout_meter_app/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';

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
      final alanButton = find.text('Alan (Empleado • Acme Corp: teamEng)');
      expect(alanButton, findsOneWidget);
      await tester.tap(alanButton);
      await tester.pumpAndSettle();

      // Close the OnboardingDialog first (handles transitions cleanly)
      final closeIntroButton = find.byTooltip('Cerrar introducción');
      expect(closeIntroButton, findsOneWidget);
      await tester.tap(closeIntroButton);
      await tester.pumpAndSettle();

      // Close the Wearable Onboarding modal next
      int wearableRetries = 10;
      while (find.text('Decidir más tarde / Cancelar').evaluate().isEmpty && wearableRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        wearableRetries--;
      }
      final closeWearableButton = find.text('Decidir más tarde / Cancelar');
      expect(closeWearableButton, findsOneWidget);
      await tester.tap(closeWearableButton);
      await tester.pumpAndSettle();

      // Verify routing landed in Employee Dashboard
      int empRetries = 10;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: EMPLEADO').evaluate().isEmpty && empRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        empRetries--;
      }
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: EMPLEADO'), findsWidgets);
      
      // Perform Logout
      final logoutButton = find.byIcon(Icons.exit_to_app);
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // 4. Manager Flow (Victor)
      final victorButton = find.text('Victor (Manager • Acme Corp: lidera teamEng)');
      expect(victorButton, findsOneWidget);
      await tester.tap(victorButton);
      await tester.pumpAndSettle();

      // Close the OnboardingDialog for manager
      expect(closeIntroButton, findsOneWidget);
      await tester.tap(closeIntroButton);
      await tester.pumpAndSettle();

      // Verify routing landed in Manager Dashboard
      int mgrRetries = 10;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: MÁNAGER').evaluate().isEmpty && mgrRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        mgrRetries--;
      }
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: MÁNAGER'), findsWidgets);
      
      // Explicitly check that there is NO permission denied error for scores
      expect(find.textContaining('Error al cargar scores:'), findsNothing);
      expect(find.textContaining('permission-denied'), findsNothing);
      expect(find.textContaining('Null value error'), findsNothing);

      // Verify that at least one member name is visible
      expect(find.text('Alan (Empleado Demo)'), findsWidgets);
      
      // Logout
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // 5. Admin Flow (Admin)
      final adminButton = find.text('Admin (Global • Acme Corp: multi-tenant)');
      expect(adminButton, findsOneWidget);
      await tester.tap(adminButton);
      await tester.pumpAndSettle();

      // Verify routing landed in Admin Dashboard (handles async Firestore lag in CI)
      int admRetries = 10;
      while (find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: ADMINISTRADOR').evaluate().isEmpty && admRetries > 0) {
        await tester.pump(const Duration(milliseconds: 500));
        admRetries--;
      }
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: ADMINISTRADOR'), findsWidgets);
      
      // Logout
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
    });
  });
}
