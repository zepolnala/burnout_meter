import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/theme/app_theme.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.darkSlate, Color(0xFF1E293B)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.cardSlate.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Branding
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTeal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.shield_outlined, color: AppTheme.accentTeal, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BurnoutMeter',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Technical Assessment & B2B Wellness Prototype',
                              style: TextStyle(color: AppTheme.softText, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFF334155)),
                  const SizedBox(height: 24),

                  // Introduction info
                  const Text(
                    'CONSOLA DE CONTROL PARA EVALUADORES',
                    style: TextStyle(
                      color: AppTheme.accentTeal,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Esta aplicación compila una única base de código para Mobile y Web. Utiliza Riverpod, Drift local SQLite y un motor de Scoring fisiológico. Selecciona un rol para simular su sesión y ver la protección de privacidad en acción:',
                    style: TextStyle(color: Color(0xFFCBD5E1), height: 1.6, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Role selector buttons
                  authState.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(color: AppTheme.accentTeal),
                      ),
                    ),
                    error: (err, stack) => Text('Error loading session mock: $err'),
                    data: (activeMembership) {
                      return Column(
                        children: [
                          _buildRoleButton(
                            context: context,
                            title: 'Rol: Empleado (App Móvil)',
                            description: 'Ingesta wearables, administra su consentimiento y visualiza su burnout index.',
                            icon: Icons.phone_android,
                            color: AppTheme.activeGreen,
                            isActive: activeMembership?.role == 'employee',
                            onPressed: () async {
                              await ref.read(authStateProvider.notifier).switchToUser('emp123');
                              if (context.mounted) context.go('/employee');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildRoleButton(
                            context: context,
                            title: 'Rol: Manager (Panel Web)',
                            description: 'Supervisa equipos asignados, consulta scores agregados (respetando consentimiento) y gatilla acciones wellness.',
                            icon: Icons.dashboard_outlined,
                            color: AppTheme.activeOrange,
                            isActive: activeMembership?.role == 'manager',
                            onPressed: () async {
                              await ref.read(authStateProvider.notifier).switchToUser('mgr456');
                              if (context.mounted) context.go('/manager');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildRoleButton(
                            context: context,
                            title: 'Rol: Admin (Panel Web)',
                            description: 'Administración global multi-tenant, membresías, auditorías y logs de accesos.',
                            icon: Icons.admin_panel_settings_outlined,
                            color: AppTheme.activeRed,
                            isActive: activeMembership?.role == 'admin',
                            onPressed: () async {
                              await ref.read(authStateProvider.notifier).switchToUser('adm789');
                              if (context.mounted) context.go('/admin');
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Meta Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.softText, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Decisión de Arquitectura: La redirección utiliza go_router con guardas de seguridad que leen Claims y membresías dinámicas de Firestore.',
                            style: TextStyle(color: AppTheme.softText, fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : const Color(0xFF334155),
          width: isActive ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppTheme.softText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios,
                color: isActive ? color : const Color(0xFF475569),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
