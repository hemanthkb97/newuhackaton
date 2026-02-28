import '../entities/breathing_log.dart';

abstract class BreathingLogRepository {
  Future<List<BreathingLog>> getAllLogs();
  Future<void> saveLog(BreathingLog log);
  Future<void> deleteLog(String id);
  Future<void> clearAllLogs();
}
