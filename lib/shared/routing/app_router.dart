import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/admin/admin_shell.dart';
import '../../presentation/employee/employee_shell.dart';
import '../../presentation/manager/manager_shell.dart';
import '../../presentation/shared/app_shell.dart';
import '../../presentation/shared/login_screen.dart';
import '../providers/auth_provider.dart';
import '../logging/app_logger.dart';
import '../config/seed_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final location = state.uri.path;

      // 1. Hold redirect while auth state is resolving or seeding is in progress
      if (authState.isLoading || authState.hasError || SeedService.isSeeding) {
        AppLogger.info('🛣️ [ROUTER] Holding redirect. isLoading=${authState.isLoading}, isSeeding=${SeedService.isSeeding}');
        return null;
      }

      final user = authState.valueOrNull;

      // 2. Unauthenticated: force to /login
      if (user == null) {
        if (location != '/login') {
          AppLogger.warning('🔒 [ROUTER] Unauthenticated access to $location → /login');
          return '/login';
        }
        return null;
      }

      // 3. Authenticated user at /login or /: redirect to role dashboard
      if (location == '/login' || location == '/') {
        AppLogger.info('🔄 [ROUTER] Authenticated ${user.role} bypassed /login');
        if (user.role == 'admin') return '/admin';
        if (user.role == 'manager') return '/manager';
        return '/employee';
      }

      // 4. RBAC Guards: block cross-role navigation
      if (location.startsWith('/employee') && user.role != 'employee') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted /employee');
        return '/unauthorized';
      }

      if (location.startsWith('/manager') && user.role != 'manager') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted /manager');
        return '/unauthorized';
      }

      if (location.startsWith('/admin') && user.role != 'admin') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted /admin');
        return '/unauthorized';
      }

      // 5. All checks passed — allow navigation
      AppLogger.info('✅ [ROUTER] ${user.role} at $location — allowed');
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(),
      ),
      GoRoute(
        path: '/employee',
        builder: (context, state) => const EmployeeShell(),
      ),
      GoRoute(
        path: '/manager',
        builder: (context, state) => const ManagerShell(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminShell(),
      ),
      GoRoute(
        path: '/unauthorized',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text(
              'No autorizado: No tienes los permisos necesarios para ver esta sección.',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ),
      ),
    ],
  );
});
