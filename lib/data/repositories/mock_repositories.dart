import 'dart:async';
import '../../domain/models/action.dart';
import '../../domain/models/audit_log.dart';
import '../../domain/models/consent.dart';
import '../../domain/models/health_sample.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/score.dart';
import '../../domain/repositories/action_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/repositories/membership_repository.dart';

class MockMembershipRepository implements MembershipRepository {
  final Map<String, Membership> _memberships = {};

  MockMembershipRepository() {
    // Seed initial users for multi-role shells demonstration
    _seedInitialUsers();
  }

  void _seedInitialUsers() {
    final now = DateTime.now();
    
    // 1. Employee User
    _memberships['emp123'] = Membership(
      userId: 'emp123',
      email: 'employee@burnoutmeter.com',
      orgId: 'org789',
      role: 'employee',
      teamId: 'teamAlpha',
      updatedAt: now,
    );

    // 2. Manager User
    _memberships['mgr456'] = Membership(
      userId: 'mgr456',
      email: 'manager@burnoutmeter.com',
      orgId: 'org789',
      role: 'manager',
      teamId: 'teamAlpha',
      managedTeamIds: ['teamAlpha', 'teamBeta'],
      updatedAt: now,
    );

    // 3. Admin User
    _memberships['adm789'] = Membership(
      userId: 'adm789',
      email: 'admin@burnoutmeter.com',
      orgId: 'org789',
      role: 'admin',
      updatedAt: now,
    );
  }

  @override
  Future<Membership?> getMembership(String userId) async {
    return _memberships[userId];
  }

  @override
  Future<List<Membership>> getTeamMemberships(String teamId, String orgId) async {
    return _memberships.values.where((m) => m.teamId == teamId && m.orgId == orgId).toList();
  }

  @override
  Future<List<Membership>> getOrgMemberships(String orgId) async {
    return _memberships.values.where((m) => m.orgId == orgId).toList();
  }

  @override
  Future<void> updateMembership(Membership membership) async {
    _memberships[membership.userId] = membership;
  }
}

class MockHealthRepository implements HealthRepository {
  final List<HealthSample> _samples = [];
  final Map<String, Score> _scores = {};

  @override
  Future<void> saveSamples(List<HealthSample> samples) async {
    _samples.addAll(samples);
  }

  @override
  Future<List<HealthSample>> getSamples(String userId, DateTime start, DateTime end) async {
    return _samples.where((s) => 
      s.userId == userId && 
      s.timestamp.isAfter(start) && 
      s.timestamp.isBefore(end)
    ).toList();
  }

  @override
  Future<void> saveScore(Score score) async {
    _scores[score.userId] = score;
  }

  @override
  Future<Score?> getLastScore(String userId, {String? teamId, String? orgId}) async {
    final userScores = _scores.values.where((s) {
      if (s.userId != userId) return false;
      if (teamId != null && s.teamId != teamId) return false;
      if (orgId != null && s.orgId != orgId) return false;
      return true;
    }).toList();
    return userScores.isNotEmpty ? userScores.first : null;
  }

  @override
  Future<List<Score>> getTeamLatestScores(List<String> userIds) async {
    final List<Score> results = [];
    for (final uid in userIds) {
      if (_scores.containsKey(uid)) {
        results.add(_scores[uid]!);
      }
    }
    return results;
  }
}

class MockConsentRepository implements ConsentRepository {
  final Map<String, Consent> _consents = {};
  final Map<String, StreamController<Consent?>> _controllers = {};

  MockConsentRepository() {
    // Seed initial default consents
    _consents['emp123'] = Consent(
      userId: 'emp123',
      sharingEnabled: true,
      actionsEnabled: true,
      updatedAt: DateTime.now(),
    );
  }

  StreamController<Consent?> _getOrCreateController(String userId) {
    if (!_controllers.containsKey(userId)) {
      _controllers[userId] = StreamController<Consent?>.broadcast();
    }
    return _controllers[userId]!;
  }

  @override
  Future<Consent?> getConsent(String userId) async {
    return _consents[userId] ?? Consent(
      userId: userId,
      sharingEnabled: false,
      actionsEnabled: false,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveConsent(Consent consent) async {
    _consents[consent.userId] = consent;
    _getOrCreateController(consent.userId).add(consent);
  }

  @override
  Stream<Consent?> watchConsent(String userId) {
    // ignore: close_sinks
    final controller = _getOrCreateController(userId);
    // Emit current value immediately if available
    Future.microtask(() {
      controller.add(_consents[userId]);
    });
    return controller.stream;
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}

class MockActionRepository implements ActionRepository {
  final List<ActionInstance> _actions = [];
  final StreamController<List<ActionInstance>> _actionsController = 
      StreamController<List<ActionInstance>>.broadcast();

  MockActionRepository() {
    // Seed an initial sent action for emp123 from mgr456
    _actions.add(ActionInstance(
      id: 'action_seed_1',
      orgId: 'org789',
      teamId: 'teamAlpha',
      type: 'suggest_break',
      targetUserId: 'emp123',
      senderUserId: 'mgr456',
      status: 'received',
      payload: {'notes': 'He visto mucha carga fisiológica hoy. Tómate 15 min por favor.'},
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ));
  }

  @override
  Future<void> sendAction(ActionInstance action) async {
    _actions.add(action);
    _actionsController.add(List.from(_actions));
  }

  @override
  Future<void> updateActionStatus(String actionId, String status) async {
    final idx = _actions.indexWhere((a) => a.id == actionId);
    if (idx != -1) {
      final updated = _actions[idx].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _actions[idx] = updated;
      _actionsController.add(List.from(_actions));
    }
  }

  @override
  Future<List<ActionInstance>> getActionsForUser(String userId) async {
    return _actions.where((a) => a.targetUserId == userId).toList();
  }

  @override
  Future<List<ActionInstance>> getActionsSentByUser(String senderUserId) async {
    return _actions.where((a) => a.senderUserId == senderUserId).toList();
  }

  @override
  Stream<List<ActionInstance>> watchActionsForUser(String userId) {
    Future.microtask(() {
      _actionsController.add(List.from(_actions));
    });
    return _actionsController.stream.map((list) => 
      list.where((a) => a.targetUserId == userId).toList()
    );
  }
}

class MockAuditRepository implements AuditRepository {
  final List<AuditLog> _logs = [];

  @override
  Future<void> logAccess(AuditLog log) async {
    // Write-once principle simulation (just adding to list)
    _logs.add(log);
  }

  @override
  Future<List<AuditLog>> getLogsForOrg(String orgId) async {
    return _logs.where((l) => l.orgId == orgId).toList();
  }
}
