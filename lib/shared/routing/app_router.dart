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

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final user = authState.value;
      final location = state.uri.path;

      // 1. If auth is loading, hold redirection
      if (authState.isLoading) return null;

      // 2. Unauthenticated state: Force redirection to login
      if (user == null) {
        if (location != '/login') {
          AppLogger.warning('🔒 [ROUTER] Unauthenticated access to $location deflected to /login');
          return '/login';
        }
        return null;
      }

      // 3. Authenticated state trying to access login: Route automatically to role dashboard
      if (location == '/login') {
        AppLogger.info('🔄 [ROUTER] Authenticated user (${user.role}) bypassed /login');
        if (user.role == 'admin') return '/admin';
        if (user.role == 'manager') return '/manager';
        return '/employee';
      }

      // 4. Role Guards (Server-side RBAC validation block)
      if (location.startsWith('/employee') && user.role != 'employee') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted to access /employee');
        return '/unauthorized';
      }

      if (location.startsWith('/manager') && user.role != 'manager') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted to access /manager');
        return '/unauthorized';
      }

      if (location.startsWith('/admin') && user.role != 'admin') {
        AppLogger.warning('🛑 [ROUTER] RBAC Block: ${user.role} attempted to access /admin');
        return '/unauthorized';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(), // Swapper console
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
