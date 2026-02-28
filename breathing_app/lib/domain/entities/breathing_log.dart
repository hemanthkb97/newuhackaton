import 'package:equatable/equatable.dart';

enum SessionCompletionStatus { completed, canceled }

class BreathingLog extends Equatable {
  final String id;
  final DateTime sessionDateTime;
  final SessionCompletionStatus completionStatus;

  // Config
  final int breatheInDuration;
  final int holdInDuration;
  final int breatheOutDuration;
  final int holdOutDuration;
  final int totalRounds;

  // Results
  final int totalActiveSeconds;
  final int totalPlannedSeconds;

  // Pause data
  final int pauseCount;
  final int totalPauseDurationSeconds;

  // Cancel context (nullable)
  final int? canceledAtRound;
  final String? canceledAtPhase;

  const BreathingLog({
    required this.id,
    required this.sessionDateTime,
    required this.completionStatus,
    required this.breatheInDuration,
    required this.holdInDuration,
    required this.breatheOutDuration,
    required this.holdOutDuration,
    required this.totalRounds,
    required this.totalActiveSeconds,
    required this.totalPlannedSeconds,
    required this.pauseCount,
    required this.totalPauseDurationSeconds,
    this.canceledAtRound,
    this.canceledAtPhase,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionDateTime': sessionDateTime.toIso8601String(),
      'completionStatus': completionStatus.name,
      'breatheInDuration': breatheInDuration,
      'holdInDuration': holdInDuration,
      'breatheOutDuration': breatheOutDuration,
      'holdOutDuration': holdOutDuration,
      'totalRounds': totalRounds,
      'totalActiveSeconds': totalActiveSeconds,
      'totalPlannedSeconds': totalPlannedSeconds,
      'pauseCount': pauseCount,
      'totalPauseDurationSeconds': totalPauseDurationSeconds,
      'canceledAtRound': canceledAtRound,
      'canceledAtPhase': canceledAtPhase,
    };
  }

  factory BreathingLog.fromJson(Map<String, dynamic> json) {
    return BreathingLog(
      id: json['id'] as String,
      sessionDateTime: DateTime.parse(json['sessionDateTime'] as String),
      completionStatus: SessionCompletionStatus.values
          .firstWhere((e) => e.name == json['completionStatus']),
      breatheInDuration: json['breatheInDuration'] as int,
      holdInDuration: json['holdInDuration'] as int,
      breatheOutDuration: json['breatheOutDuration'] as int,
      holdOutDuration: json['holdOutDuration'] as int,
      totalRounds: json['totalRounds'] as int,
      totalActiveSeconds: json['totalActiveSeconds'] as int,
      totalPlannedSeconds: json['totalPlannedSeconds'] as int,
      pauseCount: json['pauseCount'] as int,
      totalPauseDurationSeconds: json['totalPauseDurationSeconds'] as int,
      canceledAtRound: json['canceledAtRound'] as int?,
      canceledAtPhase: json['canceledAtPhase'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sessionDateTime,
        completionStatus,
        breatheInDuration,
        holdInDuration,
        breatheOutDuration,
        holdOutDuration,
        totalRounds,
        totalActiveSeconds,
        totalPlannedSeconds,
        pauseCount,
        totalPauseDurationSeconds,
        canceledAtRound,
        canceledAtPhase,
      ];
}
