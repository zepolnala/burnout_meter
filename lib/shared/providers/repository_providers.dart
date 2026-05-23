import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firestore_repositories.dart';
import '../../domain/repositories/action_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/repositories/membership_repository.dart';

final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  return FirestoreMembershipRepository();
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return FirestoreHealthRepository();
});

final consentRepositoryProvider = Provider<ConsentRepository>((ref) {
  return FirestoreConsentRepository();
});

final actionRepositoryProvider = Provider<ActionRepository>((ref) {
  return FirestoreActionRepository();
});

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  return FirestoreAuditRepository();
});
