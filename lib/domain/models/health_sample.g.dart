// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthSampleImpl _$$HealthSampleImplFromJson(Map<String, dynamic> json) =>
    _$HealthSampleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      deviceSource: json['deviceSource'] as String,
    );

Map<String, dynamic> _$$HealthSampleImplToJson(_$HealthSampleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'value': instance.value,
      'timestamp': instance.timestamp.toIso8601String(),
      'deviceSource': instance.deviceSource,
    };
