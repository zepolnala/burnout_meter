import '../models/audit_log.dart';

abstract class AuditRepository {
  Future<void> logAccess(AuditLog log);
  Future<List<AuditLog>> getLogsForOrg(String orgId);
}
