import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/sources/health/synthetic_health_data_source.dart';
import '../../domain/models/action.dart';
import '../../domain/models/audit_log.dart';
import '../../domain/models/consent.dart';
import '../../domain/models/score.dart';
import '../../domain/services/scoring_engine.dart';
import 'auth_provider.dart';
import 'repository_providers.dart';

// --- Scoring Engine ---
final scoringEngineProvider = Provider<ScoringEngine>((ref) {
  return ScoringEngine();
});

// --- Consent State Provider ---
class ConsentNotifier extends StateNotifier<AsyncValue<Consent?>> {
  final Ref _ref;
  final String _userId;

  ConsentNotifier(this._ref, this._userId) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _ref.read(consentRepositoryProvider).watchConsent(_userId).listen(
      (consent) {
        state = AsyncValue.data(consent);
      },
      onError: (Object err, StackTrace stack) {
        state = AsyncValue.error(err, stack);
      },
    );
  }

  Future<void> updateConsent({required bool sharingEnabled, required bool actionsEnabled}) async {
    final oldConsent = state.value;
    final updated = Consent(
      userId: _userId,
      sharingEnabled: sharingEnabled,
      actionsEnabled: actionsEnabled,
      updatedAt: DateTime.now(),
    );

    state = AsyncValue.data(updated);

    try {
      await _ref.read(consentRepositoryProvider).saveConsent(updated);
      
      // Log audit trail for consent modification
      await _ref.read(auditRepositoryProvider).logAccess(AuditLog(
        id: const Uuid().v4(),
        actorUserId: _userId,
        actorRole: 'employee',
        actionType: 'update_consent',
        orgId: 'org789',
        targetUserId: _userId,
        timestamp: DateTime.now(),
        details: 'Consent updated. Sharing: $sharingEnabled, Actions: $actionsEnabled',
      ));
    } catch (e, stack) {
      state = AsyncValue.data(oldConsent); // Rollback on error
      state = AsyncValue.error(e, stack);
    }
  }
}

final consentProvider = StateNotifierProvider.family<ConsentNotifier, AsyncValue<Consent?>, String>((ref, userId) {
  return ConsentNotifier(ref, userId);
});

// --- Personal Score Provider (Employee) ---
final personalScoreProvider = FutureProvider.family<Score?, String>((ref, userId) async {
  final healthRepo = ref.read(healthRepositoryProvider);
  
  // Try retrieving the last saved score first
  final cached = await healthRepo.getLastScore(userId);
  if (cached != null) return cached;

  // Otherwise, simulate a scoring run by pulling recent synthetic samples
  final syntheticSource = SyntheticHealthDataSource();
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 7));
  
  final samples = await syntheticSource.fetchSamples(userId: userId, start: start, end: end);
  await healthRepo.saveSamples(samples);

  // Read active membership info
  final member = await ref.read(membershipRepositoryProvider).getMembership(userId);
  final orgId = member?.orgId ?? 'org789';
  final teamId = member?.teamId ?? 'teamAlpha';

  final engine = ref.read(scoringEngineProvider);
  final calculated = engine.calculateScore(
    userId: userId,
    orgId: orgId,
    teamId: teamId,
    samples: samples,
  );

  await healthRepo.saveScore(calculated);
  return calculated;
});

// --- Team Scores Provider (Manager - Privacy Enforced) ---
final teamScoresProvider = FutureProvider.family<List<Score>, String>((ref, teamId) async {
  final authState = ref.read(authStateProvider).value;
  if (authState == null || (authState.role != 'manager' && authState.role != 'admin')) {
    throw Exception('Unauthorized: Only Managers or Admins can query team scores.');
  }

  final membershipRepo = ref.read(membershipRepositoryProvider);
  final healthRepo = ref.read(healthRepositoryProvider);
  final auditRepo = ref.read(auditRepositoryProvider);

  // Load all team members
  final members = await membershipRepo.getTeamMemberships(teamId);
  final List<Score> sharedScores = [];

  for (final member in members) {
    // 1. Core Privacy Rule: Load employee consent
    final consentRepo = ref.read(consentRepositoryProvider);
    final consent = await consentRepo.getConsent(member.userId);

    // Only fetch score if sharing is explicitly granted
    if (consent?.sharingEnabled == true) {
      final score = await ref.read(personalScoreProvider(member.userId).future);
      if (score != null) {
        sharedScores.add(score);
      }
    }
  }

  // 2. Security Log Audit: record that the manager queried these team scores
  await auditRepo.logAccess(AuditLog(
    id: const Uuid().v4(),
    actorUserId: authState.userId,
    actorRole: authState.role,
    actionType: 'read_team_aggregates',
    orgId: authState.orgId,
    timestamp: DateTime.now(),
    details: 'Queried aggregated scores for team $teamId. Received ${sharedScores.length} of ${members.length} members (consent filtered).',
  ));

  return sharedScores;
});

// --- Action Templates Provider ---
final actionTemplatesProvider = Provider<List<ActionTemplate>>((ref) {
  return const [
    ActionTemplate(
      type: 'suggest_break',
      title: 'Sugerir pausa breve',
      description: 'Sugerir al empleado una pausa de 15 minutos en su jornada laboral actual.',
    ),
    ActionTemplate(
      type: 'offer_1on1',
      title: 'Ofrecer conversación 1:1',
      description: 'Programar una charla informal privada de apoyo emocional o sobrecarga de tareas.',
    ),
    ActionTemplate(
      type: 'share_resource',
      title: 'Compartir recurso wellness',
      description: 'Compartir un material de apoyo (artículo de técnicas de respiración, meditación guiada).',
    ),
    ActionTemplate(
      type: 'recommend_time_off',
      title: 'Recomendar día libre',
      description: 'Sugerir formalmente tomar un día de descanso para mitigar la sobrecarga psicofisiológica.',
    ),
    ActionTemplate(
      type: 'wellness_check',
      title: 'Enviar check-in emocional',
      description: 'Enviar una pregunta breve para evaluar el bienestar percibido por el empleado.',
    ),
  ];
});

// --- Action Instances State Providers ---
final employeeActionsProvider = StreamProvider.family<List<ActionInstance>, String>((ref, userId) {
  return ref.read(actionRepositoryProvider).watchActionsForUser(userId);
});

class ManagerActionsNotifier extends StateNotifier<AsyncValue<List<ActionInstance>>> {
  final Ref _ref;
  final String _managerId;

  ManagerActionsNotifier(this._ref, this._managerId) : super(const AsyncValue.loading()) {
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final list = await _ref.read(actionRepositoryProvider).getActionsSentByUser(_managerId);
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendIntervention({
    required String targetUserId,
    required String type,
    required String teamId,
    required String orgId,
    Map<String, dynamic>? payload,
  }) async {
    // Check target user consent for receiving actions
    final consent = await _ref.read(consentRepositoryProvider).getConsent(targetUserId);
    if (consent?.actionsEnabled != true) {
      throw Exception('El empleado tiene deshabilitada la recepción de sugerencias de bienestar.');
    }

    final newAction = ActionInstance(
      id: const Uuid().v4(),
      orgId: orgId,
      teamId: teamId,
      type: type,
      targetUserId: targetUserId,
      senderUserId: _managerId,
      status: 'sent',
      payload: payload,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _ref.read(actionRepositoryProvider).sendAction(newAction);
      
      // Log audit access
      await _ref.read(auditRepositoryProvider).logAccess(AuditLog(
        id: const Uuid().v4(),
        actorUserId: _managerId,
        actorRole: 'manager',
        actionType: 'create_action',
        orgId: orgId,
        targetUserId: targetUserId,
        timestamp: DateTime.now(),
        details: 'Sent action type: $type',
      ));

      await _refresh();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final managerActionsProvider = StateNotifierProvider.family<ManagerActionsNotifier, AsyncValue<List<ActionInstance>>, String>((ref, managerId) {
  return ManagerActionsNotifier(ref, managerId);
});
