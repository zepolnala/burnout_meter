import 'package:freezed_annotation/freezed_annotation.dart';

part 'action.freezed.dart';
part 'action.g.dart';

@freezed
class ActionTemplate with _$ActionTemplate {
  const factory ActionTemplate({
    required String type, // 'suggest_break', 'offer_1on1', 'share_resource', 'recommend_time_off', 'wellness_check'
    required String title,
    required String description,
    Map<String, dynamic>? defaultPayload,
  }) = _ActionTemplate;

  factory ActionTemplate.fromJson(Map<String, dynamic> json) => _$ActionTemplateFromJson(json);
}

@freezed
class ActionInstance with _$ActionInstance {
  const factory ActionInstance({
    required String id,
    required String orgId,
    required String teamId,
    required String type, // matches ActionTemplate.type
    required String targetUserId,
    required String senderUserId,
    required String status, // 'sent', 'received', 'acknowledged', 'dismissed'
    Map<String, dynamic>? payload, // e.g. { 'resourceLink': '...', 'notes': '...' }
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActionInstance;

  factory ActionInstance.fromJson(Map<String, dynamic> json) => _$ActionInstanceFromJson(json);
}
