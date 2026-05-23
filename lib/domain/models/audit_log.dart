import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String actorUserId, // User making the access
    required String actorRole,   // Role of the actor
    required String actionType,  // 'read_score_detail', 'read_team_aggregates', 'create_action', 'update_consent'
    required String orgId,
    String? targetUserId,        // Whose data was accessed (if individual)
    required DateTime timestamp,
    String? details,             // Additional context
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);
}
