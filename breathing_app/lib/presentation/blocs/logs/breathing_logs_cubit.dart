import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/breathing_log.dart';
import '../../../domain/repositories/breathing_log_repository.dart';
import '../breathing/breathing_state.dart';
import 'breathing_logs_state.dart';

class BreathingLogsCubit extends Cubit<BreathingLogsState> {
  final BreathingLogRepository _repository;

  BreathingState? _currentSessionSnapshot;
  DateTime? _sessionStartTime;

  BreathingLogsCubit(this._repository)
      : super(const BreathingLogsState());

  Future<void> loadLogs() async {
    emit(state.copyWith(status: BreathingLogsStatus.loading));
    try {
      final logs = await _repository.getAllLogs();
      emit(state.copyWith(status: BreathingLogsStatus.loaded, logs: logs));
    } catch (_) {
      emit(state.copyWith(status: BreathingLogsStatus.error));
    }
  }

  Future<void> deleteLog(String id) async {
    await _repository.deleteLog(id);
    await loadLogs();
  }

  Future<void> clearAllLogs() async {
    await _repository.clearAllLogs();
    emit(state.copyWith(
      status: BreathingLogsStatus.loaded,
      logs: [],
    ));
  }

  void startTrackingSession(DateTime startTime) {
    _sessionStartTime = startTime;
    _currentSessionSnapshot = null;
  }

  void updateSessionSnapshot(BreathingState breathingState) {
    _currentSessionSnapshot = breathingState;
  }

  Future<void> saveCompletedSession() async {
    final snapshot = _currentSessionSnapshot;
    final startTime = _sessionStartTime;
    if (snapshot == null || startTime == null) return;

    final log = BreathingLog(
      id: startTime.millisecondsSinceEpoch.toString(),
      sessionDateTime: startTime,
      completionStatus: SessionCompletionStatus.completed,
      breatheInDuration: snapshot.breatheInDuration,
      holdInDuration: snapshot.holdInDuration,
      breatheOutDuration: snapshot.breatheOutDuration,
      holdOutDuration: snapshot.holdOutDuration,
      totalRounds: snapshot.totalRounds,
      totalActiveSeconds: snapshot.totalElapsedSeconds,
      totalPlannedSeconds: snapshot.totalSessionSeconds,
      pauseCount: snapshot.pauseCount,
      totalPauseDurationSeconds: snapshot.totalPauseDurationSeconds,
    );

    await _repository.saveLog(log);
    _currentSessionSnapshot = null;
    _sessionStartTime = null;
    await loadLogs();
  }

  Future<void> saveCanceledSession() async {
    final snapshot = _currentSessionSnapshot;
    final startTime = _sessionStartTime;
    if (snapshot == null || startTime == null) return;

    final log = BreathingLog(
      id: startTime.millisecondsSinceEpoch.toString(),
      sessionDateTime: startTime,
      completionStatus: SessionCompletionStatus.canceled,
      breatheInDuration: snapshot.breatheInDuration,
      holdInDuration: snapshot.holdInDuration,
      breatheOutDuration: snapshot.breatheOutDuration,
      holdOutDuration: snapshot.holdOutDuration,
      totalRounds: snapshot.totalRounds,
      totalActiveSeconds: snapshot.totalElapsedSeconds,
      totalPlannedSeconds: snapshot.totalSessionSeconds,
      pauseCount: snapshot.pauseCount,
      totalPauseDurationSeconds: snapshot.totalPauseDurationSeconds,
      canceledAtRound: snapshot.currentRound,
      canceledAtPhase: snapshot.phaseDisplayName,
    );

    await _repository.saveLog(log);
    _currentSessionSnapshot = null;
    _sessionStartTime = null;
    await loadLogs();
  }
}
