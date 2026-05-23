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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Ensure deterministic state by logging out any residual cached sessions
      await FirebaseAuth.instance.signOut();
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 2. Trigger Seeding
      final seedButton = find.text('Inicializar DB Local (Seed)');
      expect(seedButton, findsOneWidget);
      await tester.tap(seedButton);
      
      // Wait for seeding to complete and snackbar to appear
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 3. Employee Flow (Alan)
      final alanButton = find.text('Alan (Empleado • teamEng)');
      expect(alanButton, findsOneWidget);
      await tester.tap(alanButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Employee Dashboard
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: EMPLEADO'), findsWidgets);
      
      // Perform Logout
      final logoutButton = find.byIcon(Icons.exit_to_app);
      expect(logoutButton, findsOneWidget);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 4. Manager Flow (Victor)
      final victorButton = find.text('Victor (Manager • teamEng)');
      expect(victorButton, findsOneWidget);
      await tester.tap(victorButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Manager Dashboard
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: MÁNAGER'), findsWidgets);
      
      // Logout
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 5. Admin Flow (Admin)
      final adminButton = find.text('Admin (Global multi-tenant)');
      expect(adminButton, findsOneWidget);
      await tester.tap(adminButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify routing landed in Admin Dashboard
      expect(find.textContaining('GUÍA DE EVALUACIÓN CTO • ROL: ADMINISTRADOR'), findsWidgets);
      
      // Logout
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
