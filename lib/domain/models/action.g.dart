// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionTemplateImpl _$$ActionTemplateImplFromJson(Map<String, dynamic> json) =>
    _$ActionTemplateImpl(
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      defaultPayload: json['defaultPayload'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ActionTemplateImplToJson(
        _$ActionTemplateImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'defaultPayload': instance.defaultPayload,
    };

_$ActionInstanceImpl _$$ActionInstanceImplFromJson(Map<String, dynamic> json) =>
    _$ActionInstanceImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      teamId: json['teamId'] as String,
      type: json['type'] as String,
      targetUserId: json['targetUserId'] as String,
      senderUserId: json['senderUserId'] as String,
      status: json['status'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ActionInstanceImplToJson(
        _$ActionInstanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'teamId': instance.teamId,
      'type': instance.type,
      'targetUserId': instance.targetUserId,
      'senderUserId': instance.senderUserId,
      'status': instance.status,
      'payload': instance.payload,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
