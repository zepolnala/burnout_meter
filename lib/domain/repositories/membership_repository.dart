import '../models/membership.dart';

abstract class MembershipRepository {
  Future<Membership?> getMembership(String userId);
  Future<List<Membership>> getTeamMemberships(String teamId, String orgId);
  Future<List<Membership>> getOrgMemberships(String orgId);
  Future<void> updateMembership(Membership membership);
}
