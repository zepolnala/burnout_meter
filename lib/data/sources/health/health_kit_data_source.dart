import '../../../domain/models/health_sample.dart';
import 'health_data_source.dart';

/// Production HealthKit stub. In a full production implementation on iOS/Android,
/// this class connects to package:health to fetch authentic sensor readings from
/// Apple Health / Google Health Connect.
class HealthKitDataSource implements HealthDataSource {
  @override
  Future<List<HealthSample>> fetchSamples({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    // Return empty list/stub. Demonstrates architecture readiness for hardware integration.
    // In production, we request permission via: Health().requestAuthorization(...)
    // and query data using: Health().getHealthDataFromTypes(...)
    return [];
  }
}
