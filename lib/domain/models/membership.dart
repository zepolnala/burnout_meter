import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@freezed
class Membership with _$Membership {
  const factory Membership({
    required String userId,
    required String email,
    required String orgId,
    required String role, // 'employee', 'manager', 'admin'
    String? teamId,      // For employees (assigned to single team)
    List<String>? managedTeamIds, // For managers (managing list of teams)
    required DateTime updatedAt,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);
}
