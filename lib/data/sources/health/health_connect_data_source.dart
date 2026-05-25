import 'package:health/health.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/health_sample.dart';
import 'health_data_source.dart';
import '../../../shared/logging/app_logger.dart';

class HealthConnectDataSource implements HealthDataSource {
  final _uuid = const Uuid();
  final HealthFactory _health = HealthFactory();

  @override
  Future<List<HealthSample>> fetchSamples({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final List<HealthSample> samples = [];

    // Define the health data types we need to fetch for early psychophysiological risk detection
    final List<HealthDataType> types = [
      HealthDataType.HEART_RATE,
      HealthDataType.HEART_RATE_VARIABILITY_SDNN,
      HealthDataType.RESPIRATORY_RATE,
      HealthDataType.SLEEP_ASLEEP,
    ];

    final List<HealthDataAccess> permissions = types.map((e) => HealthDataAccess.READ).toList();

    try {
      AppLogger.info('⚡ [HEALTH_CONNECT] Requesting user permissions for Health Connect data...');
      
      // Request authorization to access the specific health metrics
      final bool authorized = await _health.requestAuthorization(types, permissions: permissions);
      
      if (!authorized) {
        AppLogger.warning('⚠️ [HEALTH_CONNECT] Access to Health Connect was denied by the user.');
        return [];
      }

      AppLogger.info('⚡ [HEALTH_CONNECT] Access granted. Fetching health data points...');
      
      // Fetch historical data points in the requested time window
      final List<HealthDataPoint> dataPoints = await _health.getHealthDataFromTypes(
        start,
        end,
        types,
      );

      AppLogger.info('⚡ [HEALTH_CONNECT] Retrieved ${dataPoints.length} raw data points.');

      // Map the third-party HealthDataPoints to our clean Domain HealthSamples
      for (final dp in dataPoints) {
        final double? val = _parseValue(dp.value);
        if (val == null) continue;

        String type;
        if (dp.type == HealthDataType.HEART_RATE) {
          type = 'heart_rate';
        } else if (dp.type == HealthDataType.HEART_RATE_VARIABILITY_SDNN) {
          type = 'hrv';
        } else if (dp.type == HealthDataType.RESPIRATORY_RATE) {
          type = 'respiratory_rate';
        } else if (dp.type == HealthDataType.SLEEP_ASLEEP) {
          type = 'sleep_duration';
        } else {
          continue; // Ignore unsupported data points
        }

        // For sleep duration, convert sleep minutes to hours if necessary
        double finalValue = val;
        if (type == 'sleep_duration') {
          if (dp.value is NumericHealthValue) {
            // Standard returns sleep minutes or seconds depending on configuration
            // Convert sleep duration minutes/seconds to decimal hours
            if (val > 24.0) {
              finalValue = val / 60.0; // assuming minutes -> convert to hours
            }
          }
        }

        samples.add(HealthSample(
          id: _uuid.v4(),
          userId: userId,
          type: type,
          value: finalValue,
          timestamp: dp.dateFrom,
          deviceSource: dp.sourceName.isNotEmpty ? dp.sourceName : 'Google_Health_Connect',
        ));
      }
    } catch (e, stack) {
      AppLogger.error('❌ [HEALTH_CONNECT] Exception fetching Google Health Connect data', e, stack);
    }

    return samples;
  }

  /// Safely extracts numeric double values from various Health value structures
  double? _parseValue(HealthValue val) {
    if (val is NumericHealthValue) {
      return val.numericValue.toDouble();
    }
    return double.tryParse(val.toString());
  }
}
