import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';
import '../../../domain/models/health_sample.dart';
import 'health_data_source.dart';

class ReplayHealthDataSource implements HealthDataSource {
  final String? mockJsonString;
  final _uuid = const Uuid();

  ReplayHealthDataSource({this.mockJsonString});

  @override
  Future<List<HealthSample>> fetchSamples({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      String jsonContent;
      if (mockJsonString != null) {
        jsonContent = mockJsonString!;
      } else {
        jsonContent = await rootBundle.loadString('assets/fixtures/replay_health_data.json');
      }

      final List<dynamic> list = json.decode(jsonContent) as List<dynamic>;
      final List<HealthSample> parsedSamples = list.map((item) {
        final map = item as Map<String, dynamic>;
        final int hoursOffset = map['hoursOffset'] as int? ?? 0;
        final DateTime sampleTime = start.add(Duration(hours: hoursOffset));

        return HealthSample(
          id: _uuid.v4(),
          userId: userId,
          type: map['type'] as String,
          value: (map['value'] as num).toDouble(),
          timestamp: sampleTime,
          deviceSource: map['deviceSource'] as String? ?? 'ReplayWatch_Fixture',
        );
      }).toList();

      return parsedSamples.where((s) => s.timestamp.isAfter(start) && s.timestamp.isBefore(end)).toList();
    } catch (e) {
      // Fallback helper to remain functional during headless unit test suites
      return _generateDeterministicReplay(userId, start, end);
    }
  }

  List<HealthSample> _generateDeterministicReplay(String userId, DateTime start, DateTime end) {
    final List<HealthSample> samples = [];
    DateTime current = start;
    int index = 0;

    while (current.isBefore(end)) {
      final double hrValue = 72.0 + (index % 5) * 4.0 - (index % 3) * 2.0;
      final double hrvValue = 48.0 - (index % 4) * 5.0 + (index % 3) * 3.0;

      samples.add(HealthSample(
        id: 'replay-hr-$index-$userId',
        userId: userId,
        type: 'heart_rate',
        value: hrValue,
        timestamp: current,
        deviceSource: 'DeterministicReplay_Backup',
      ));

      samples.add(HealthSample(
        id: 'replay-hrv-$index-$userId',
        userId: userId,
        type: 'hrv',
        value: hrvValue,
        timestamp: current,
        deviceSource: 'DeterministicReplay_Backup',
      ));

      samples.add(HealthSample(
        id: 'replay-resp-$index-$userId',
        userId: userId,
        type: 'respiratory_rate',
        value: 14.0 + (index % 2) * 1.5,
        timestamp: current,
        deviceSource: 'DeterministicReplay_Backup',
      ));

      current = current.add(const Duration(hours: 2));
      index++;
    }

    final int days = end.difference(start).inDays.clamp(1, 30);
    for (int i = 0; i < days; i++) {
      samples.add(HealthSample(
        id: 'replay-sleep-$i-$userId',
        userId: userId,
        type: 'sleep_duration',
        value: 6.8 + (i % 3) * 0.4,
        timestamp: start.add(Duration(days: i, hours: 8)),
        deviceSource: 'DeterministicReplay_Backup',
      ));
    }

    return samples;
  }
}
