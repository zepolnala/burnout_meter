import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sources/health/replay_health_data_source.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/burnout_providers.dart';
import '../../shared/providers/repository_providers.dart';
import '../../domain/models/action.dart';
import '../../shared/theme/app_theme.dart';
import '../shared/vector_icons.dart';
import '../shared/burnout_radial_score.dart';

class EmployeeShell extends ConsumerStatefulWidget {
  const EmployeeShell({super.key});

  @override
  ConsumerState<EmployeeShell> createState() => _EmployeeShellState();
}

class _EmployeeShellState extends ConsumerState<EmployeeShell> {
  int _activeTab = 0; // 0: Dashboard, 1: Privacy, 2: Actions

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWearableOnboardingModal();
    });
  }

  void _showWearableOnboardingModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.cardSlate,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 24,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.cardSlate,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.watch_rounded, color: AppTheme.accentTeal, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Vincular tu Wearable',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Para calcular tu Índice de Burnout en tiempo real de manera científica, BurnoutMeter puede conectarse de forma segura con tus cuentas de salud de Apple Health, Google Health Connect, Fitbit o Garmin.',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  '🔒 Privacidad de Datos Garantizada: Los datos biométricos crudos (sueño, HRV) permanecen en el almacenamiento local seguro de tu dispositivo (Drift). Tu organización solo recibe el Score de Burnout procesado (0-100), si autorizas compartirlo.',
                  style: TextStyle(color: AppTheme.softText, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: [
                      _buildIntegrationRow(
                        icon: Icons.apple,
                        name: 'Apple Health',
                        color: Colors.white,
                      ),
                      const Divider(color: Colors.white12, height: 16),
                      _buildIntegrationRow(
                        icon: Icons.fitbit,
                        name: 'Google Health Connect / Fitbit',
                        color: const Color(0xFF00B0B9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentTeal,
                        foregroundColor: AppTheme.darkSlate,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        navigator.pop();
                        
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                CircularProgressIndicator(color: AppTheme.accentTeal),
                                SizedBox(width: 16),
                                Text('Vinculando con Apple Health / Google Connect...'),
                              ],
                            ),
                            backgroundColor: AppTheme.cardSlate,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                        await Future<void>.delayed(const Duration(seconds: 2));
                        
                        final authState = ref.read(authStateProvider);
                        final userId = authState.value?.userId;
                        if (userId != null) {
                          final healthRepo = ref.read(healthRepositoryProvider);
                          final replaySource = ReplayHealthDataSource();
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 7));
                          
                          final samples = await replaySource.fetchSamples(userId: userId, start: start, end: end);
                          await healthRepo.saveSamples(samples);
                          
                          final member = await ref.read(membershipRepositoryProvider).getMembership(userId);
                          final orgId = member?.orgId ?? 'org789';
                          final teamId = member?.teamId ?? 'teamEng';
                          
                          final calculated = ref.read(scoringEngineProvider).calculateScore(
                            userId: userId,
                            orgId: orgId,
                            teamId: teamId,
                            samples: samples,
                          );
                          
                          await healthRepo.saveScore(calculated);
                          ref.invalidate(personalScoreProvider(userId));
                          
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('¡Wearable vinculado y sincronizado con éxito! Métricas cargadas.'),
                              backgroundColor: AppTheme.activeGreen,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.watch_rounded),
                      label: const Text('Vincular y Sincronizar Wearable', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF334155),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        navigator.pop();
                        
                        final authState = ref.read(authStateProvider);
                        final userId = authState.value?.userId;
                        if (userId != null) {
                          final healthRepo = ref.read(healthRepositoryProvider);
                          final replaySource = ReplayHealthDataSource();
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 7));
                          
                          final samples = await replaySource.fetchSamples(userId: userId, start: start, end: end);
                          await healthRepo.saveSamples(samples);
                          
                          final member = await ref.read(membershipRepositoryProvider).getMembership(userId);
                          final orgId = member?.orgId ?? 'org789';
                          final teamId = member?.teamId ?? 'teamEng';
                          
                          final calculated = ref.read(scoringEngineProvider).calculateScore(
                            userId: userId,
                            orgId: orgId,
                            teamId: teamId,
                            samples: samples,
                          );
                          
                          await healthRepo.saveScore(calculated);
                          ref.invalidate(personalScoreProvider(userId));
                          
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Datos demo simulados de forma local.'),
                              backgroundColor: AppTheme.activeGreen,
                            ),
                          );
                        }
                      },
                      child: const Text('Simular datos (Demo)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Decidir más tarde / Cancelar',
                        style: TextStyle(color: AppTheme.softText, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntegrationRow({required IconData icon, required String name, required Color color}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.2)),
          ),
          child: const Text(
            'Disponible',
            style: TextStyle(color: AppTheme.accentTeal, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _getNameFromEmail(String email) {
    if (email.startsWith('employee_eng1')) return 'Alan (Empleado Demo)';
    if (email.startsWith('employee_eng2')) return 'Sofía Martín';
    if (email.startsWith('employee_cs1')) return 'Tomás (Customer Success)';
    final prefix = email.split('@').first;
    return prefix.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final actionsAsync = ref.watch(employeeActionsProvider(user.userId));
    final int pendingCount = actionsAsync.maybeWhen(
      data: (actions) => actions.where((a) => a.status == 'sent' || a.status == 'received').length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppTheme.darkSlate,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480), // Mobile phone simulator frame
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            border: Border.all(color: const Color(0xFF334155), width: 2),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              )
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          clipBehavior: Clip.antiAlias,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F172A),
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'BurnoutMeter Mobile',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppTheme.activeGreen,
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
                    'Perfil: ${_getNameFromEmail(user.email)}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.softText),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Cerrar Sesión',
                  icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logout();
                  },
                ),
              ],
            ),
            body: IndexedStack(
              index: _activeTab,
              children: [
                _buildDashboardTab(user.userId),
                _buildPrivacyTab(user.userId),
                _buildActionsTab(user.userId),
              ],
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                canvasColor: const Color(0xFF0F172A),
              ),
              child: BottomNavigationBar(
                currentIndex: _activeTab,
                onTap: (index) => setState(() => _activeTab = index),
                backgroundColor: const Color(0xFF0F172A),
                selectedItemColor: AppTheme.accentTeal,
                unselectedItemColor: AppTheme.softText,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                    label: 'Mi Estado',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.privacy_tip_outlined),
                    activeIcon: Icon(Icons.privacy_tip),
                    label: 'Privacidad',
                  ),
                  BottomNavigationBarItem(
                    icon: pendingCount > 0 
                      ? Badge(
                          label: Text(pendingCount.toString()),
                          backgroundColor: AppTheme.activeRed,
                          child: const Icon(Icons.notifications_none_outlined),
                        )
                      : const Icon(Icons.notifications_none_outlined),
                    activeIcon: pendingCount > 0
                      ? Badge(
                          label: Text(pendingCount.toString()),
                          backgroundColor: AppTheme.activeRed,
                          child: const Icon(Icons.notifications),
                        )
                      : const Icon(Icons.notifications),
                    label: 'Acciones',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  // --- TAB 1: DASHBOARD ---
  Widget _buildDashboardTab(String userId) {
    final scoreAsync = ref.watch(personalScoreProvider(userId));

    return scoreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentTeal)),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
      data: (score) {
        if (score == null) return const Center(child: Text('No hay datos disponibles.'));
        
        final idx = score.burnoutIndex;
        final color = AppTheme.getScoreColor(idx);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Executive narrative card
              _buildDemoNarrativeCard(
                context: context,
                role: 'EMPLEADO',
                text: 'Estás simulando tu sesión móvil. Puedes simular lecturas en tiempo real de tu wearable (Replay JSON) y ver el cálculo de burnout. Para probar las reglas de seguridad GDPR, desactiva compartir en la pestaña "Privacidad" y cambia al rol de Manager.',
              ),
              const SizedBox(height: 20),

              // Radial Burnout Meter Widget representation
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'ÍNDICE DE CARGA DIARIA',
                      style: TextStyle(color: AppTheme.softText, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                    ),
                    const SizedBox(height: 24),
                    // Beautiful Custom Radial Score Dial
                    BurnoutRadialScore(score: idx, size: 160),
                    const SizedBox(height: 24),
                    const Text(
                      'Biometría cargada de Wearable E500. Tu manager nunca accede a tus datos biológicos crudos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.softText, fontSize: 11),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentTeal,
                        foregroundColor: AppTheme.darkSlate,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () async {
                        final healthRepo = ref.read(healthRepositoryProvider);
                        final replaySource = ReplayHealthDataSource();
                        final end = DateTime.now();
                        final start = end.subtract(const Duration(days: 7));
                        
                        final samples = await replaySource.fetchSamples(userId: userId, start: start, end: end);
                        await healthRepo.saveSamples(samples);
                        
                        final member = await ref.read(membershipRepositoryProvider).getMembership(userId);
                        final orgId = member?.orgId ?? 'org789';
                        final teamId = member?.teamId ?? 'teamEng';
                        
                        final calculated = ref.read(scoringEngineProvider).calculateScore(
                          userId: userId,
                          orgId: orgId,
                          teamId: teamId,
                          samples: samples,
                        );
                        
                        await healthRepo.saveScore(calculated);
                        ref.invalidate(personalScoreProvider(userId));
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cálculo completado a través de ReplayHealthDataSource.'),
                              backgroundColor: AppTheme.activeGreen,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Simular Lectura Wearable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Subscores desglosados
              const Text(
                'FACTORES FISIOLÓGICOS',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildSubscoreRow('Sueño (Calidad & Horas)', score.subscores.sleep, true, const SleepVectorIcon(size: 20)),
              const SizedBox(height: 10),
              _buildSubscoreRow('Recuperación (HRV)', score.subscores.recovery, true, const RecoveryVectorIcon(size: 20)),
              const SizedBox(height: 10),
              _buildSubscoreRow('Estrés Interno (Frecuencia)', score.subscores.stress, false, const StressVectorIcon(size: 20)),
              const SizedBox(height: 10),
              _buildSubscoreRow('Carga Física Diaria', score.subscores.load, false, const LoadVectorIcon(size: 20)),
              const SizedBox(height: 24),

              // Trend section
              _buildTrendSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendSection() {
    final List<double> values = [62, 68, 54, 78, 85, 70, 60];
    final List<String> days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TENDENCIA HRV / PULSO DE LA SEMANA',
            style: TextStyle(color: AppTheme.softText, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (idx) {
              final val = values[idx];
              final isHigh = val >= 75;
              final color = isHigh ? AppTheme.activeOrange : AppTheme.accentTeal;
              
              return Column(
                children: [
                  Container(
                    height: 80,
                    width: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: (val / 100) * 80,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(days[idx], style: const TextStyle(color: AppTheme.softText, fontSize: 10)),
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildSubscoreRow(String label, double value, bool invertColor, Widget vectorIcon) {
    // invertColor means higher score = healthier (green). E.g. Sleep & Recovery
    final bool isHealthy = invertColor ? value >= 60 : value < 50;
    final color = isHealthy ? AppTheme.activeGreen : AppTheme.activeOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          vectorIcon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          )
        ],
      ),
    );
  }

  // --- TAB 2: PRIVACY ---
  Widget _buildPrivacyTab(String userId) {
    final consentAsync = ref.watch(consentProvider(userId));

    return consentAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (consent) {
        if (consent == null) return const Center(child: Text('Consentimiento no inicializado.'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDemoNarrativeCard(
                context: context,
                role: 'PRIVACIDAD',
                text: 'GDPR en Acción: Al apagar "Compartir mi Burnout Index", el sistema ejecuta una transacción que actualiza tu perfil en Firestore. La regla de base de datos se activa en el acto, bloqueando de raíz cualquier lectura externa.',
              ),
              const SizedBox(height: 20),
              const Center(child: ShieldVectorIcon(size: 64)),
              const SizedBox(height: 16),
              const Text(
                'Centro de Consentimientos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'BurnoutMeter está diseñado bajo el principio Privacy-by-Design. Tú controlas en todo momento tu información corporativa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.softText, fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 28),

              // Sharing Toggle
              _buildConsentSwitch(
                title: 'Compartir mi Burnout Index',
                description: 'Permitir al Manager asignado ver mi Score general (0-100) derivado. Los datos crudos (HRV/Sueño) NUNCA se comparten.',
                value: consent.sharingEnabled,
                onChanged: (val) {
                  ref.read(consentProvider(userId).notifier).updateConsent(
                    sharingEnabled: val,
                    actionsEnabled: consent.actionsEnabled,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Actions Toggle
              _buildConsentSwitch(
                title: 'Recibir sugerencias wellness',
                description: 'Permitir a mi Manager enviarme sugerencias de pausas o recursos (artículos, 1-to-1) si detecta carga elevada.',
                value: consent.actionsEnabled,
                onChanged: (val) {
                  ref.read(consentProvider(userId).notifier).updateConsent(
                    sharingEnabled: consent.sharingEnabled,
                    actionsEnabled: val,
                  );
                },
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Text(
                  'Cumplimiento GDPR: Cada cambio en estas opciones genera un "Audit Log" inmutable que valida el cumplimiento normativo en backend.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.softText, fontSize: 10, height: 1.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsentSwitch({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: AppTheme.accentTeal,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: AppTheme.softText, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: ACTIONS ---
  Widget _buildActionsTab(String userId) {
    final actionsAsync = ref.watch(employeeActionsProvider(userId));

    return actionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (actions) {
        final pending = actions.where((a) => a.status == 'sent' || a.status == 'received').toList();
        final processed = actions.where((a) => a.status == 'acknowledged' || a.status == 'dismissed').toList();

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildDemoNarrativeCard(
              context: context,
              role: 'ACCIONES COLECTIVAS',
              text: 'Intervenciones B2B: Aquí aparecen las recomendaciones de descanso enviadas por tu mánager. Al presionar "Aceptar" o "Descartar", se actualiza Firestore, permitiendo al mánager auditar el impacto desde su consola.',
            ),
            const SizedBox(height: 20),
            const Text(
              'RECOMENDACIONES ACTIVAS',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            if (pending.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No tienes sugerencias de bienestar pendientes por ahora. ¡Buen trabajo manteniéndote recargado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.softText, fontSize: 12),
                ),
              )
            else
              ...pending.map((action) => _buildActionCard(action)),

            const SizedBox(height: 24),
            const Text(
              'HISTORIAL DE INTERVENCIONES',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            if (processed.isEmpty)
              const Text('No hay registros históricos.', style: TextStyle(color: AppTheme.softText, fontSize: 12))
            else
              ...processed.map((action) => _buildHistoricActionRow(action)),
          ],
        );
      },
    );
  }

  Widget _buildActionCard(ActionInstance action) {
    final Map<String, String> titles = {
      'suggest_break': 'Sugerencia: Pausa Breve',
      'offer_1on1': 'Propuesta: Charla 1:1',
      'share_resource': 'Recurso Compartido',
      'recommend_time_off': 'Sugerencia: Descanso',
      'wellness_check': 'Bienestar: Check-in',
    };

    final title = titles[action.type] ?? 'Recomendación de Bienestar';
    final notes = action.payload?['notes'] as String? ?? 'Tu manager te ha enviado esta sugerencia.';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const WellnessSparkles(size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            notes,
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppTheme.activeRed),
                onPressed: () {
                  ref.read(actionRepositoryProvider).updateActionStatus(action.id, 'dismissed');
                },
                child: const Text('Descartar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.activeGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  ref.read(actionRepositoryProvider).updateActionStatus(action.id, 'acknowledged');
                },
                child: const Text('Aceptar'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoricActionRow(ActionInstance action) {
    final bool isAccepted = action.status == 'acknowledged';
    final color = isAccepted ? AppTheme.activeGreen : AppTheme.softText;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            action.type == 'suggest_break' ? 'Pausa sugerida' : 'Conversación 1:1',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isAccepted ? 'Aceptado' : 'Descartado',
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
