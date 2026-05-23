// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipImpl _$$MembershipImplFromJson(Map<String, dynamic> json) =>
    _$MembershipImpl(
      userId: json['userId'] as String,
      email: json['email'] as String,
      orgId: json['orgId'] as String,
      role: json['role'] as String,
      teamId: json['teamId'] as String?,
      managedTeamIds: (json['managedTeamIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MembershipImplToJson(_$MembershipImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'orgId': instance.orgId,
      'role': instance.role,
      'teamId': instance.teamId,
      'managedTeamIds': instance.managedTeamIds,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
