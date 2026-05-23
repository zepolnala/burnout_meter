import 'package:freezed_annotation/freezed_annotation.dart';

part 'score.freezed.dart';
part 'score.g.dart';

@freezed
class Subscores with _$Subscores {
  const factory Subscores({
    required double sleep,    // 0-100 derived sleep score
    required double recovery, // 0-100 recovery score (based on HRV)
    required double stress,   // 0-100 stress index
    required double load,     // 0-100 work/physiological load
  }) = _Subscores;

  factory Subscores.fromJson(Map<String, dynamic> json) => _$SubscoresFromJson(json);
}

@freezed
class Score with _$Score {
  const factory Score({
    required String id,
    required String userId,
    required String orgId,
    required String teamId,
    required double burnoutIndex, // 0-100 overall score
    required Subscores subscores, // desglosado
    required DateTime calculatedAt,
  }) = _Score;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}
