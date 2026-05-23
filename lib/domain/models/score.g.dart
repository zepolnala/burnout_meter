// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscoresImpl _$$SubscoresImplFromJson(Map<String, dynamic> json) =>
    _$SubscoresImpl(
      sleep: (json['sleep'] as num).toDouble(),
      recovery: (json['recovery'] as num).toDouble(),
      stress: (json['stress'] as num).toDouble(),
      load: (json['load'] as num).toDouble(),
    );

Map<String, dynamic> _$$SubscoresImplToJson(_$SubscoresImpl instance) =>
    <String, dynamic>{
      'sleep': instance.sleep,
      'recovery': instance.recovery,
      'stress': instance.stress,
      'load': instance.load,
    };

_$ScoreImpl _$$ScoreImplFromJson(Map<String, dynamic> json) => _$ScoreImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orgId: json['orgId'] as String,
      teamId: json['teamId'] as String,
      burnoutIndex: (json['burnoutIndex'] as num).toDouble(),
      subscores: Subscores.fromJson(json['subscores'] as Map<String, dynamic>),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$ScoreImplToJson(_$ScoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orgId': instance.orgId,
      'teamId': instance.teamId,
      'burnoutIndex': instance.burnoutIndex,
      'subscores': instance.subscores,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };
