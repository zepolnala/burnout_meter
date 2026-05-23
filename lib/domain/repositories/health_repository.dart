import '../models/health_sample.dart';
import '../models/score.dart';

abstract class HealthRepository {
  Future<void> saveSamples(List<HealthSample> samples);
  Future<List<HealthSample>> getSamples(String userId, DateTime start, DateTime end);
  
  Future<void> saveScore(Score score);
  Future<Score?> getLastScore(String userId, {String? teamId, String? orgId});
  Future<List<Score>> getTeamLatestScores(List<String> userIds);
}
