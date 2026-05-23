import '../models/health_sample.dart';
import '../models/score.dart';
import '../../../shared/logging/app_logger.dart';

class ScoringEngine {
  /// Calculates physiological subscores and the consolidated BurnoutIndex (0-100)
  /// from a time-window of raw biometrics samples.
  /// 
  /// --- CLINICAL & COMPLIANCE SPECIFICATIONS ---
  /// 🧬 **HRV (Heart Rate Variability)**: RMSSD (Root Mean Square of Successive Differences)
  ///    in milliseconds. Direct marker of parasympathetic (vagal) tone. Elevated HRV implies 
  ///    cardiorespiratory flexibility and positive physiological recovery.
  /// 🧠 **Sleep Duration decay**: Optimal baseline is set between 7.5 and 8.5 hours. Below 6.5 hours, 
  ///    cognitive and cardiovascular recovery drops exponentially rather than linearly.
  /// 🫁 **Respiratory Rate (RR)**: Breathing frequency in cycles per minute. Elevated RR (>18 breaths/min) 
  ///    indicates hyperventilation and sympathetic activation (fight-or-flight response).
  /// 🩺 **CE-MDR / FDA Audit Compliance**:
  ///    This calculator represents a Software-as-a-Medical-Device (SaMD) physiological algorithm.
  ///    Any changes to thresholds must trigger internal design file updates (MDR Class IIa compliance).
  Score calculateScore({
    required String userId,
    required String orgId,
    required String teamId,
    required List<HealthSample> samples,
  }) {
    AppLogger.scoring('Calculating consolidated Burnout Index for user: $userId');

    final sleepHours = _extractAverage(samples, 'sleep_duration', fallback: 7.5);
    final heartRate = _extractAverage(samples, 'heart_rate', fallback: 70.0);
    final hrv = _extractAverage(samples, 'hrv', fallback: 55.0);
    final respRate = _extractAverage(samples, 'respiratory_rate', fallback: 15.0);

    AppLogger.scoring('Parsed Biometrics -> Sleep: ${sleepHours.toStringAsFixed(1)}h, HR: ${heartRate.toStringAsFixed(1)}bpm, HRV: ${hrv.toStringAsFixed(1)}ms, RR: ${respRate.toStringAsFixed(1)}bpm');

    // 1. Sleep Subscore (0-100: Higher is better rest)
    // Optimal: 7.5 to 8.5 hours. Penalize sleep deprivation or oversleeping.
    double sleepScore = 100.0;
    if (sleepHours < 7.2) {
      // Exponential sleep deprivation decay curve
      sleepScore = ((sleepHours / 7.2) * (sleepHours / 7.2)) * 100.0;
    } else if (sleepHours > 9.0) {
      sleepScore = (9.0 / sleepHours) * 100.0;
    }
    sleepScore = sleepScore.clamp(0.0, 100.0);

    // 2. Recovery Subscore (0-100: Higher is better autonomic recovery)
    // Derived from HRV RMSSD in milliseconds. Base reference: 80ms is optimal recovery.
    double recoveryScore = (hrv / 80.0) * 100.0;
    recoveryScore = recoveryScore.clamp(0.0, 100.0);

    // 3. Stress Subscore (0-100: Higher is more sympathetic stress)
    // Combines waking Heart Rate elevations and breathing frequency shifts.
    final double hrFactor = ((heartRate - 55.0) / 45.0) * 100.0; // 55bpm base resting, 100bpm high resting
    final double respFactor = ((respRate - 12.0) / 8.0) * 100.0;  // 12bpm base resting, 20bpm high resting
    double stressScore = (hrFactor * 0.6) + (respFactor * 0.4);
    stressScore = stressScore.clamp(0.0, 100.0);

    // 4. Load Subscore (0-100: Higher is greater cumulative physical work load)
    // Derived from heart rate elevations and physical activity baselines
    double loadScore = ((heartRate - 50.0) / 45.0) * 100.0;
    loadScore = loadScore.clamp(0.0, 100.0);

    // 5. Consolidated Burnout Index (0-100)
    // Formula: Sympathetic Stress adds risk, Autonomic Recovery and Sleep debts amplify risk.
    final double sleepDebt = 100.0 - sleepScore;
    final double recoveryDebt = 100.0 - recoveryScore;

    final double burnoutIndex = (stressScore * 0.40) + 
                               (recoveryDebt * 0.30) + 
                               (sleepDebt * 0.20) + 
                               (loadScore * 0.10);

    final double finalizedIndex = burnoutIndex.clamp(0.0, 100.0);

    AppLogger.scoring('Calculated Burnout Index: ${finalizedIndex.toStringAsFixed(1)} (Stress Subscore: ${stressScore.toStringAsFixed(1)}%, Sleep Debt: ${sleepDebt.toStringAsFixed(1)}%)');

    return Score(
      id: 'score_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      orgId: orgId,
      teamId: teamId,
      burnoutIndex: finalizedIndex,
      subscores: Subscores(
        sleep: sleepScore,
        recovery: recoveryScore,
        stress: stressScore,
        load: loadScore,
      ),
      calculatedAt: DateTime.now(),
    );
  }

  double _extractAverage(List<HealthSample> samples, String type, {required double fallback}) {
    final filtered = samples.where((s) => s.type == type).toList();
    if (filtered.isEmpty) return fallback;
    final sum = filtered.map((s) => s.value).reduce((a, b) => a + b);
    return sum / filtered.length;
  }
}
