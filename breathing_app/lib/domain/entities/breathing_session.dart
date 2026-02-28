import 'breathing_phase.dart';

class BreathingSession {
  final int breatheInSeconds;
  final int holdInSeconds;
  final int breatheOutSeconds;
  final int holdOutSeconds;
  final int totalRounds;
  final bool soundEnabled;

  const BreathingSession({
    required this.breatheInSeconds,
    required this.holdInSeconds,
    required this.breatheOutSeconds,
    required this.holdOutSeconds,
    required this.totalRounds,
    required this.soundEnabled,
  });

  List<BreathingPhase> get phases => [
        BreathingPhase(
            type: BreathingPhaseType.breatheIn,
            durationSeconds: breatheInSeconds),
        BreathingPhase(
            type: BreathingPhaseType.holdIn,
            durationSeconds: holdInSeconds),
        BreathingPhase(
            type: BreathingPhaseType.breatheOut,
            durationSeconds: breatheOutSeconds),
        BreathingPhase(
            type: BreathingPhaseType.holdOut,
            durationSeconds: holdOutSeconds),
      ];

  int get singleRoundSeconds =>
      breatheInSeconds + holdInSeconds + breatheOutSeconds + holdOutSeconds;

  int get totalSessionSeconds => singleRoundSeconds * totalRounds;
}
