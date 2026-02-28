import '../../domain/entities/breathing_log.dart';
import '../../domain/repositories/breathing_log_repository.dart';
import '../datasources/breathing_log_local_datasource.dart';

class BreathingLogRepositoryImpl implements BreathingLogRepository {
  final BreathingLogLocalDatasource _datasource;

  BreathingLogRepositoryImpl(this._datasource);

  @override
  Future<List<BreathingLog>> getAllLogs() => _datasource.getAllLogs();

  @override
  Future<void> saveLog(BreathingLog log) => _datasource.saveLog(log);

  @override
  Future<void> deleteLog(String id) => _datasource.deleteLog(id);

  @override
  Future<void> clearAllLogs() => _datasource.clearAllLogs();
}
