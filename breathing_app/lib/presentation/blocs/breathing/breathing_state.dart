import 'package:equatable/equatable.dart';
import '../../../domain/entities/breathing_phase.dart';

enum BreathingStatus { idle, running, paused, completed }

class BreathingState extends Equatable {
  final BreathingStatus status;
  final BreathingPhaseType currentPhaseType;
  final int currentRound;
  final int totalRounds;
  final int phaseElapsedSeconds;
  final int phaseTotalSeconds;
  final int totalElapsedSeconds;
  final int totalSessionSeconds;
  final int encouragingTextIndex;

  // Per-phase durations for progress calculation
  final int breatheInDuration;
  final int holdInDuration;
  final int breatheOutDuration;
  final int holdOutDuration;

  const BreathingState({
    this.status = BreathingStatus.idle,
    this.currentPhaseType = BreathingPhaseType.breatheIn,
    this.currentRound = 1,
    this.totalRounds = 4,
    this.phaseElapsedSeconds = 0,
    this.phaseTotalSeconds = 4,
    this.totalElapsedSeconds = 0,
    this.totalSessionSeconds = 64,
    this.encouragingTextIndex = 0,
    this.breatheInDuration = 4,
    this.holdInDuration = 4,
    this.breatheOutDuration = 4,
    this.holdOutDuration = 4,
  });

  BreathingState copyWith({
    BreathingStatus? status,
    BreathingPhaseType? currentPhaseType,
    int? currentRound,
    int? totalRounds,
    int? phaseElapsedSeconds,
    int? phaseTotalSeconds,
    int? totalElapsedSeconds,
    int? totalSessionSeconds,
    int? encouragingTextIndex,
    int? breatheInDuration,
    int? holdInDuration,
    int? breatheOutDuration,
    int? holdOutDuration,
  }) {
    return BreathingState(
      status: status ?? this.status,
      currentPhaseType: currentPhaseType ?? this.currentPhaseType,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      phaseElapsedSeconds: phaseElapsedSeconds ?? this.phaseElapsedSeconds,
      phaseTotalSeconds: phaseTotalSeconds ?? this.phaseTotalSeconds,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      totalSessionSeconds: totalSessionSeconds ?? this.totalSessionSeconds,
      encouragingTextIndex: encouragingTextIndex ?? this.encouragingTextIndex,
      breatheInDuration: breatheInDuration ?? this.breatheInDuration,
      holdInDuration: holdInDuration ?? this.holdInDuration,
      breatheOutDuration: breatheOutDuration ?? this.breatheOutDuration,
      holdOutDuration: holdOutDuration ?? this.holdOutDuration,
    );
  }

  String get phaseDisplayName {
    switch (currentPhaseType) {
      case BreathingPhaseType.breatheIn:
        return 'Breathe in';
      case BreathingPhaseType.holdIn:
        return 'Hold gently';
      case BreathingPhaseType.breatheOut:
        return 'Breathe out';
      case BreathingPhaseType.holdOut:
        return 'Hold softly';
    }
  }

  bool get isHoldPhase =>
      currentPhaseType == BreathingPhaseType.holdIn ||
      currentPhaseType == BreathingPhaseType.holdOut;

  /// Counter value to display in the bubble
  int get displayCounter {
    if (currentPhaseType == BreathingPhaseType.breatheIn) {
      return phaseElapsedSeconds + 1; // counts UP 1,2,3,4
    } else if (currentPhaseType == BreathingPhaseType.breatheOut) {
      return phaseTotalSeconds - phaseElapsedSeconds; // counts DOWN 4,3,2,1
    }
    return 0; // holds don't show counter
  }

  double get progressFraction {
    if (totalSessionSeconds == 0) return 0;
    return totalElapsedSeconds / totalSessionSeconds;
  }

  @override
  List<Object?> get props => [
        status,
        currentPhaseType,
        currentRound,
        totalRounds,
        phaseElapsedSeconds,
        phaseTotalSeconds,
        totalElapsedSeconds,
        totalSessionSeconds,
        encouragingTextIndex,
        breatheInDuration,
        holdInDuration,
        breatheOutDuration,
        holdOutDuration,
      ];
}
