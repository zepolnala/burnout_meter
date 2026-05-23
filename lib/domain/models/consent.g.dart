// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsentImpl _$$ConsentImplFromJson(Map<String, dynamic> json) =>
    _$ConsentImpl(
      userId: json['userId'] as String,
      sharingEnabled: json['sharingEnabled'] as bool,
      actionsEnabled: json['actionsEnabled'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConsentImplToJson(_$ConsentImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sharingEnabled': instance.sharingEnabled,
      'actionsEnabled': instance.actionsEnabled,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
