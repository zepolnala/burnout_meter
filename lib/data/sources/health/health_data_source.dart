import '../../../domain/models/health_sample.dart';

abstract class HealthDataSource {
  /// Fetches physiological health samples for a given user in a time window.
  Future<List<HealthSample>> fetchSamples({
    required String userId,
    required DateTime start,
    required DateTime end,
  });
}
