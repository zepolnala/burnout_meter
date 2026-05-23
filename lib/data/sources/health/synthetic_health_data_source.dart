import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../../domain/models/health_sample.dart';
import 'health_data_source.dart';

class SyntheticHealthDataSource implements HealthDataSource {
  final _random = Random();
  final _uuid = const Uuid();

  @override
  Future<List<HealthSample>> fetchSamples({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final List<HealthSample> samples = [];
    DateTime current = start;

    // Generate samples in 1-hour intervals
    while (current.isBefore(end)) {
      // 1. Heart Rate (bpm)
      samples.add(HealthSample(
        id: _uuid.v4(),
        userId: userId,
        type: 'heart_rate',
        value: 55.0 + _random.nextDouble() * 35.0, // 55 - 90 bpm
        timestamp: current,
        deviceSource: 'Synthetic_Wearable_E500',
      ));

      // 2. HRV (ms) - lower means more stressed
      samples.add(HealthSample(
        id: _uuid.v4(),
        userId: userId,
        type: 'hrv',
        value: 25.0 + _random.nextDouble() * 55.0, // 25 - 80 ms
        timestamp: current,
        deviceSource: 'Synthetic_Wearable_E500',
      ));

      // 3. Respiratory Rate (breaths/min)
      samples.add(HealthSample(
        id: _uuid.v4(),
        userId: userId,
        type: 'respiratory_rate',
        value: 12.0 + _random.nextDouble() * 6.0, // 12 - 18 breaths/min
        timestamp: current,
        deviceSource: 'Synthetic_Wearable_E500',
      ));

      current = current.add(const Duration(hours: 1));
    }

    // 4. Daily sleep duration (hours)
    final int days = end.difference(start).inDays.clamp(1, 30);
    for (int i = 0; i < days; i++) {
      samples.add(HealthSample(
        id: _uuid.v4(),
        userId: userId,
        type: 'sleep_duration',
        value: 5.0 + _random.nextDouble() * 4.0, // 5.0 - 9.0 hours
        timestamp: start.add(Duration(days: i, hours: 8)), // 8:00 AM wake up
        deviceSource: 'Synthetic_Wearable_E500',
      ));
    }

    return samples;
  }
}
