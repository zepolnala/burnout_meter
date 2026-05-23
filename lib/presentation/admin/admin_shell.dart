import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uuid/uuid.dart';
import '../../domain/models/audit_log.dart';
import '../../domain/models/membership.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/repository_providers.dart';
import '../../shared/theme/app_theme.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  List<AuditLog> _logs = [];
  List<Membership> _members = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    setState(() => _loading = true);
    final auditRepo = ref.read(auditRepositoryProvider);
    final memberRepo = ref.read(membershipRepositoryProvider);

    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    final listMembers = await memberRepo.getOrgMemberships('org789');
    
    // Simulate some standard seed logs for presentation
    await auditRepo.logAccess(AuditLog(
      id: const Uuid().v4(),
      actorUserId: currentUser.userId,
      actorRole: 'admin',
      actionType: 'read_security_audit_logs',
      orgId: 'org789',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      details: 'Consulted global compliance ledger.',
    ));

    final listLogs = await auditRepo.getLogsForOrg('org789');

    setState(() {
      _members = listMembers;
      _logs = listLogs.reversed.toList(); // Newest first
      _loading = false;
    });
  }

  Widget _buildDemoNarrativeCard({
    required BuildContext context,
    required String role,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: AppTheme.accentTeal, size: 20),
              const SizedBox(width: 8),
              Text(
                '💡 GUÍA DE EVALUACIÓN CTO • ROL: $role',
                style: const TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final admin = authState.value;

    if (admin == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.darkSlate,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.activeRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.activeRed, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'BurnoutMeter Admin Console',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppTheme.activeRed,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: const Text(
                        'EMULADOR LOCAL',
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    )
                  ],
                ),
                Text(
                  'Multi-Tenant Tenant: ${admin.orgId}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.softText),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            icon: const Icon(Icons.exit_to_app, size: 18),
            label: const Text('Cerrar Sesión'),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentTeal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Demo Narrative guide at the top of Admin view
                  _buildDemoNarrativeCard(
                    context: context,
                    role: 'ADMINISTRADOR',
                    text: 'Libro de Auditoría GDPR: Todo acceso o modificación a información de salud de los empleados es registrado de forma permanente e inmutable en Firestore. Las reglas de base de datos prohíben a cualquier usuario editar o borrar estos registros históricos, asegurando el cumplimiento estricto con regulaciones internacionales.',
                  ),
                  const SizedBox(height: 24),

                  // Overview Metrics row
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Colaboradores Activos', '${_members.length}', Icons.people, AppTheme.accentTeal)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricCard('Tasa Consentimiento', '75%', Icons.verified_user, AppTheme.activeGreen)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricCard('Auditorías de Acceso', '${_logs.length}', Icons.history_toggle_off, AppTheme.activeRed)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PANEL 1: Memberships Management
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFF334155)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Membresías RBAC',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.refresh, color: AppTheme.accentTeal, size: 20),
                                      onPressed: _loadAdminData,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Gestión de usuarios y equipos asignados.',
                                  style: TextStyle(color: AppTheme.softText, fontSize: 12),
                                ),
                                const SizedBox(height: 20),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _members.length,
                                  separatorBuilder: (context, idx) => const Divider(color: Color(0xFF334155)),
                                  itemBuilder: (context, idx) {
                                    final m = _members[idx];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        m.email,
                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'ID: ${m.userId} | Equipo: ${m.teamId ?? "N/A"}',
                                        style: const TextStyle(color: AppTheme.softText, fontSize: 11),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: (m.role == 'admin'
                                                  ? AppTheme.activeRed
                                                  : m.role == 'manager'
                                                      ? AppTheme.activeOrange
                                                      : AppTheme.activeGreen)
                                              .withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          m.role.toUpperCase(),
                                          style: TextStyle(
                                            color: m.role == 'admin'
                                                ? AppTheme.activeRed
                                                : m.role == 'manager'
                                                    ? AppTheme.activeOrange
                                                    : AppTheme.activeGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // PANEL 2: Immutable Security Audit Log Ledger
                      Expanded(
                        flex: 2,
                        child: Card(
                          color: const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFF334155)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Libro de Auditoría de Seguridad (Audit Logs)',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Registro inmutable de accesos y consultas a datos de salud en cumplimiento estricto con GDPR.',
                                  style: TextStyle(color: AppTheme.softText, fontSize: 12),
                                ),
                                const SizedBox(height: 20),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _logs.length,
                                  separatorBuilder: (context, idx) => const Divider(color: Color(0xFF334155)),
                                  itemBuilder: (context, idx) {
                                    final log = _logs[idx];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.06),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              log.actorRole.toUpperCase(),
                                              style: const TextStyle(color: AppTheme.softText, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  log.details ?? log.actionType,
                                                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Actor: ${log.actorUserId} | Hora: ${log.timestamp.toLocal().toString().split('.')[0]}',
                                                  style: const TextStyle(color: AppTheme.softText, fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Row(
                                            children: [
                                              Icon(Icons.verified_user_outlined, color: AppTheme.activeGreen, size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                'SECURE',
                                                style: TextStyle(color: AppTheme.activeGreen, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppTheme.softText),
              ),
            ],
          )
        ],
      ),
    );
  }
}
