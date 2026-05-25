import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/membership.dart';
import '../../domain/models/score.dart';
import '../../domain/models/action.dart';

import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/burnout_providers.dart';

import '../../shared/theme/app_theme.dart';
import '../shared/vector_icons.dart';
import '../shared/burnout_radial_score.dart';
import '../shared/onboarding_dialog.dart';

class ManagerShell extends ConsumerStatefulWidget {
  const ManagerShell({super.key});

  @override
  ConsumerState<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends ConsumerState<ManagerShell> {
  String? _selectedEmployeeId;
  String? _selectedActionType;
  final TextEditingController _notesController = TextEditingController();

  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_dialogShown && mounted) {
        _dialogShown = true;
        await OnboardingDialog.show(context);
      }
    });
  }

  String _getNameFromEmail(String email) {
    if (email.startsWith('employee_eng1')) return 'Alan (Empleado Demo)';
    if (email.startsWith('employee_eng2')) return 'Sofía Martín';
    if (email.startsWith('employee_cs1')) return 'Tomás (Customer Success)';
    if (email.startsWith('manager_eng')) return 'Victor (Manager)';
    final prefix = email.split('@').first;
    return prefix.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
                '💡 GUÍA DE EVALUACIÓN CTO • ROL: ${role.toUpperCase()}',
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
    final manager = authState.value;
    const bool useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: false);

    if (manager == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        OnboardingDialog.show(context);
      });
    }

    final teamId = manager.teamId ?? 'teamEng';
    final membersAsync = ref.watch(teamMembersProvider(teamId));
    final scoresAsync = ref.watch(teamScoresProvider(teamId));
    final sentActionsAsync = ref.watch(managerActionsProvider(manager.userId));
    final templates = ref.watch(actionTemplatesProvider);

    final members = membersAsync.value ?? [];
    final selectedMember = members.where((m) => m.userId == _selectedEmployeeId).firstOrNull;
    final selectedEmployeeName = selectedMember != null ? _getNameFromEmail(selectedMember.email) : 'Empleado';

    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: AppTheme.darkSlate,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        titleSpacing: isMobile ? 8 : 16,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 6 : 8),
              decoration: BoxDecoration(
                color: AppTheme.activeOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.dashboard_outlined, color: AppTheme.activeOrange, size: isMobile ? 18 : 20),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          isMobile ? 'BurnoutMeter Manager' : 'BurnoutMeter Manager Console',
                          style: TextStyle(fontSize: isMobile ? 13 : 15, fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: useEmulator ? Color(0xFFF59E0B) : AppTheme.activeGreen,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: const Text(
                            useEmulator ? 'EMULADOR LOCAL' : 'NUBE FIREBASE',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    isMobile ? 'Equipo: $teamId' : 'Organización: ${manager.orgId}  |  Equipo: $teamId',
                    style: TextStyle(fontSize: isMobile ? 10 : 11, color: AppTheme.softText),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              tooltip: 'Cerrar Sesión',
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
              },
            )
          else
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
      body: isMobile
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildMainContent(
                      context,
                      manager,
                      teamId,
                      membersAsync,
                      scoresAsync,
                      sentActionsAsync,
                      members,
                      isMobile,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      border: Border(top: BorderSide(color: Color(0xFF334155))),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _buildActionPanelContent(
                      manager,
                      teamId,
                      selectedEmployeeName,
                      scoresAsync,
                      templates,
                      isMobile,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // MAIN BODY: Team List Grid
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildMainContent(
                      context,
                      manager,
                      teamId,
                      membersAsync,
                      scoresAsync,
                      sentActionsAsync,
                      members,
                      isMobile,
                    ),
                  ),
                ),
                // SIDE PANEL: Action Trigger Console
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      border: Border(left: BorderSide(color: Color(0xFF334155))),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: _buildActionPanelContent(
                      manager,
                      teamId,
                      selectedEmployeeName,
                      scoresAsync,
                      templates,
                      isMobile,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    Membership manager,
    String teamId,
    AsyncValue<List<Membership>> membersAsync,
    AsyncValue<List<Score>> scoresAsync,
    AsyncValue<List<ActionInstance>> sentActionsAsync,
    List<Membership> members,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Demo Narrative guide at the top of Manager view
        _buildDemoNarrativeCard(
          context: context,
          role: 'MÁNAGER',
          text: 'Consola de Supervisión Organizacional: Aquí observas el riesgo de burnout consolidado de tus colaboradores. Por diseño, los datos fisiológicos crudos (HRV/sueño) jamás viajan a tu pantalla. Nota el bloqueo en Sofía Martín: al no tener consentimiento activo, el servidor deniega su puntuación.',
        ),
        const SizedBox(height: 24),

        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Miembros del Equipo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isMobile 
                        ? 'Supervisa los indicadores y emite recomendaciones.'
                        : 'Supervisa los indicadores de burnout agregados y emite recomendaciones.',
                    style: const TextStyle(fontSize: 13, color: AppTheme.softText),
                  ),
                ],
              ),
            ),
            // Privacy notice label
            if (!isMobile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, color: AppTheme.accentTeal, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Privacy-by-Design Enforced',
                      style: TextStyle(color: AppTheme.accentTeal, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
          ],
        ),
        const SizedBox(height: 24),

        // Load Team Members & Scores
        membersAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(color: AppTheme.accentTeal),
            ),
          ),
          error: (err, stack) => Center(
            child: Text('Error al cargar miembros: $err', style: const TextStyle(color: Colors.red)),
          ),
          data: (members) {
            return scoresAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(48.0),
                  child: CircularProgressIndicator(color: AppTheme.accentTeal),
                ),
              ),
              error: (err, stack) => Center(
                child: Text('Error al cargar scores: $err', style: const TextStyle(color: Colors.red)),
              ),
              data: (scores) {
                // Dynamic Attention Needed Alarm
                final highRiskScores = scores.where((s) => s.burnoutIndex >= 70).toList();
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (highRiskScores.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppTheme.activeOrange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.activeOrange.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppTheme.activeOrange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ATENCIÓN REQUERIDA: ${highRiskScores.length} miembro(s) reportan fatiga psicofisiológica severa (Carga >= 70). Considera enviar sugerencias wellness.',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isMobile ? 280 : 320,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isMobile ? 1.45 : 1.3,
                      ),
                      itemCount: members.length,
                      itemBuilder: (context, idx) {
                        final member = members[idx];
                        final memberId = member.userId;
                        
                        final score = scores.where((s) => s.userId == memberId).firstOrNull;
                        final bool isSelected = _selectedEmployeeId == memberId;

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppTheme.accentTeal : const Color(0xFF334155),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedEmployeeId = memberId;
                                _selectedActionType = null;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(isMobile ? 16 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getNameFromEmail(member.email),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    member.email,
                                    style: const TextStyle(color: AppTheme.softText, fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),

                                  if (score != null) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Carga Laboral:',
                                          style: TextStyle(color: AppTheme.softText, fontSize: 12),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.getScoreColor(score.burnoutIndex).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            score.burnoutIndex.toStringAsFixed(0),
                                            style: TextStyle(
                                              color: AppTheme.getScoreColor(score.burnoutIndex),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ] else ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Carga Laboral:',
                                          style: TextStyle(color: AppTheme.softText, fontSize: 12),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.04),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ShieldVectorIcon(size: 12, color: AppTheme.softText),
                                              SizedBox(width: 6),
                                              Text(
                                                'Privado',
                                                style: TextStyle(
                                                  color: AppTheme.softText,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        
        const SizedBox(height: 40),

        // Actions history log list sent by manager
        const Text(
          'Historial de Recomendaciones Enviadas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        sentActionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error al cargar historial: $err'),
          data: (actions) {
            if (actions.isEmpty) {
              return const Text(
                'No has enviado ninguna acción correctiva a tu equipo todavía.',
                style: TextStyle(color: AppTheme.softText, fontSize: 13),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              separatorBuilder: (context, idx) => const Divider(color: Color(0xFF334155)),
              itemBuilder: (context, idx) {
                final act = actions[idx];
                
                Color statusColor = AppTheme.softText;
                IconData statusIcon = Icons.query_builder;

                if (act.status == 'acknowledged') {
                  statusColor = AppTheme.activeGreen;
                  statusIcon = Icons.check_circle_outline;
                } else if (act.status == 'dismissed') {
                  statusColor = AppTheme.activeRed;
                  statusIcon = Icons.highlight_off;
                } else if (act.status == 'received') {
                  statusColor = AppTheme.accentTeal;
                  statusIcon = Icons.mark_chat_read_outlined;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(statusIcon, color: statusColor),
                  title: Text(
                    'Intervención: ${act.type.replaceAll('_', ' ').toUpperCase()}',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Destinatario: ${_getNameFromEmail(members.where((m) => m.userId == act.targetUserId).firstOrNull?.email ?? act.targetUserId)} | Nota: ${act.payload?['notes'] ?? 'Sin descripción'}',
                    style: const TextStyle(color: AppTheme.softText, fontSize: 11),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      act.status.toUpperCase(),
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionPanelContent(
    Membership manager,
    String teamId,
    String selectedEmployeeName,
    AsyncValue<List<Score>> scoresAsync,
    List<ActionTemplate> templates,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'ACCIONES CORRECTIVAS',
          style: TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        
        if (_selectedEmployeeId == null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                isMobile 
                    ? 'Selecciona un miembro del equipo arriba para iniciar una acción preventiva.'
                    : 'Selecciona un miembro del equipo a la izquierda para iniciar una acción preventiva.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.softText, fontSize: 13, height: 1.5),
              ),
            ),
          ),
        ] else ...[
          Text(
            'Destinatario: $selectedEmployeeName',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (scoresAsync.value != null && 
              scoresAsync.value!.where((s) => s.userId == _selectedEmployeeId).firstOrNull != null) ...[
            const SizedBox(height: 16),
            Center(
              child: BurnoutRadialScore(
                score: scoresAsync.value!.where((s) => s.userId == _selectedEmployeeId).first.burnoutIndex,
                size: 110,
              ),
            ),
          ],
          const SizedBox(height: 24),
          
          const Text('1. Selecciona tipo de intervención:', style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 10),

          if (isMobile)
            Column(
              children: templates.map((tmpl) {
                final isSelected = _selectedActionType == tmpl.type;
                return _buildTemplateCard(tmpl, isSelected);
              }).toList(),
            )
          else
            Expanded(
              child: ListView(
                children: templates.map((tmpl) {
                  final isSelected = _selectedActionType == tmpl.type;
                  return _buildTemplateCard(tmpl, isSelected);
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),
          const Text('2. Escribe una nota de apoyo:', style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E293B),
              hintText: 'Ej. He notado stress elevado en las últimas señales. Tómate el resto de la tarde libre...',
              hintStyle: const TextStyle(color: AppTheme.softText, fontSize: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accentTeal),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Send Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentTeal,
              foregroundColor: AppTheme.darkSlate,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _selectedActionType == null
              ? null
              : () async {
                  try {
                    await ref.read(managerActionsProvider(manager.userId).notifier).sendIntervention(
                      targetUserId: _selectedEmployeeId!,
                      type: _selectedActionType!,
                      teamId: teamId,
                      orgId: manager.orgId,
                      payload: {'notes': _notesController.text},
                    );
                    
                    _notesController.clear();
                    setState(() {
                      _selectedEmployeeId = null;
                      _selectedActionType = null;
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Intervención de bienestar enviada con éxito.'),
                          backgroundColor: AppTheme.activeGreen,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString().replaceAll('Exception:', '')}'),
                          backgroundColor: AppTheme.activeRed,
                        ),
                      );
                    }
                  }
                },
            child: const Text('Enviar Recomendación', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ]
      ],
    );
  }

  Widget _buildTemplateCard(ActionTemplate tmpl, bool isSelected) {
    return Card(
      color: isSelected ? AppTheme.accentTeal.withValues(alpha: 0.12) : const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isSelected ? AppTheme.accentTeal : const Color(0xFF334155)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _selectedActionType = tmpl.type),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tmpl.title,
                style: TextStyle(
                  color: isSelected ? AppTheme.accentTeal : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(tmpl.description, style: const TextStyle(color: AppTheme.softText, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
