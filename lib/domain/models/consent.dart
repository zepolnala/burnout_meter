import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent.freezed.dart';
part 'consent.g.dart';

@freezed
class Consent with _$Consent {
  const factory Consent({
    required String userId,
    required bool sharingEnabled, // Enable sharing of calculated scores
    required bool actionsEnabled, // Enable receiving manager/admin actions
    required DateTime updatedAt,
  }) = _Consent;

  factory Consent.fromJson(Map<String, dynamic> json) => _$ConsentFromJson(json);
}
