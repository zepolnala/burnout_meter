// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: json['id'] as String,
      actorUserId: json['actorUserId'] as String,
      actorRole: json['actorRole'] as String,
      actionType: json['actionType'] as String,
      orgId: json['orgId'] as String,
      targetUserId: json['targetUserId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorUserId': instance.actorUserId,
      'actorRole': instance.actorRole,
      'actionType': instance.actionType,
      'orgId': instance.orgId,
      'targetUserId': instance.targetUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'details': instance.details,
    };
