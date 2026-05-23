import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_sample.freezed.dart';
part 'health_sample.g.dart';

@freezed
class HealthSample with _$HealthSample {
  const factory HealthSample({
    required String id,
    required String userId,
    required String type, // 'heart_rate', 'hrv', 'sleep_duration', 'respiratory_rate'
    required double value,
    required DateTime timestamp,
    required String deviceSource, // e.g. 'E500_Watch', 'HealthKit_Stub'
  }) = _HealthSample;

  factory HealthSample.fromJson(Map<String, dynamic> json) => _$HealthSampleFromJson(json);
}
