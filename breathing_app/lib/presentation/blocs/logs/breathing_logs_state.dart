import 'package:equatable/equatable.dart';

import '../../../domain/entities/breathing_log.dart';

enum BreathingLogsStatus { initial, loading, loaded, error }

class BreathingLogsState extends Equatable {
  final BreathingLogsStatus status;
  final List<BreathingLog> logs;

  const BreathingLogsState({
    this.status = BreathingLogsStatus.initial,
    this.logs = const [],
  });

  BreathingLogsState copyWith({
    BreathingLogsStatus? status,
    List<BreathingLog>? logs,
  }) {
    return BreathingLogsState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
    );
  }

  @override
  List<Object?> get props => [status, logs];
}
