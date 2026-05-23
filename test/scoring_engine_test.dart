import 'package:flutter_test/flutter_test.dart';
import 'package:burnout_meter_app/domain/models/health_sample.dart';
import 'package:burnout_meter_app/domain/services/scoring_engine.dart';

void main() {
  group('ScoringEngine physiological equations', () {
    final engine = ScoringEngine();

    test('Optimal biometrics should produce a very low burnout risk score', () {
      final now = DateTime.now();
      final List<HealthSample> samples = [
        // 8 hours of sleep
        HealthSample(id: 's1', userId: 'user1', type: 'sleep_duration', value: 8.0, timestamp: now, deviceSource: 'TestWatch'),
        // 60 bpm resting heart rate
        HealthSample(id: 's2', userId: 'user1', type: 'heart_rate', value: 60.0, timestamp: now, deviceSource: 'TestWatch'),
        // High HRV (Healthy Parasympathetic tone)
        HealthSample(id: 's3', userId: 'user1', type: 'hrv', value: 80.0, timestamp: now, deviceSource: 'TestWatch'),
        // Low breathing rate
        HealthSample(id: 's4', userId: 'user1', type: 'respiratory_rate', value: 12.0, timestamp: now, deviceSource: 'TestWatch'),
      ];

      final result = engine.calculateScore(
        userId: 'user1',
        orgId: 'org1',
        teamId: 'team1',
        samples: samples,
      );

      // Verify subscores are computed correctly
      expect(result.subscores.sleep, equals(100.0)); // Ideal sleep duration
      expect(result.subscores.recovery, equals(100.0)); // HRV >= 75ms
      expect(result.subscores.stress, lessThan(20.0)); // Very low stress factors
      
      // Aggregate Burnout Index should be extremely low
      expect(result.burnoutIndex, lessThan(15.0));
    });

    test('Oversleeping or sleep deprivation should reduce the sleep subscore', () {
      final now = DateTime.now();
      // Test sleep deprivation (4 hours)
      final List<HealthSample> lowSleepSamples = [
        HealthSample(id: 's1', userId: 'user1', type: 'sleep_duration', value: 4.0, timestamp: now, deviceSource: 'TestWatch'),
      ];

      final lowSleepResult = engine.calculateScore(
        userId: 'user1',
        orgId: 'org1',
        teamId: 'team1',
        samples: lowSleepSamples,
      );

      expect(lowSleepResult.subscores.sleep, lessThan(60.0));
    });

    test('Critical physiological stress biometrics should trigger a high burnout warning score', () {
      final now = DateTime.now();
      final List<HealthSample> distressedSamples = [
        // Sleep deprivation (4.5 hours of rest)
        HealthSample(id: 's1', userId: 'user1', type: 'sleep_duration', value: 4.5, timestamp: now, deviceSource: 'TestWatch'),
        // High resting heart rate
        HealthSample(id: 's2', userId: 'user1', type: 'heart_rate', value: 92.0, timestamp: now, deviceSource: 'TestWatch'),
        // Depressed HRV (High sympathetic fatigue/stress)
        HealthSample(id: 's3', userId: 'user1', type: 'hrv', value: 20.0, timestamp: now, deviceSource: 'TestWatch'),
        // Elevated breathing rate (Hyperventilating/Tense)
        HealthSample(id: 's4', userId: 'user1', type: 'respiratory_rate', value: 19.5, timestamp: now, deviceSource: 'TestWatch'),
      ];

      final result = engine.calculateScore(
        userId: 'user1',
        orgId: 'org1',
        teamId: 'team1',
        samples: distressedSamples,
      );

      // Verify subscores are computed correctly
      expect(result.subscores.sleep, lessThan(70.0));
      expect(result.subscores.recovery, lessThan(30.0)); // low HRV -> poor recovery
      expect(result.subscores.stress, greaterThan(70.0)); // high HR & resp -> high stress
      
      // Cumulative Burnout Index must be in danger zone (above 65)
      expect(result.burnoutIndex, greaterThan(65.0));
    });
  });
}
