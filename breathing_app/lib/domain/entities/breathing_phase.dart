enum BreathingPhaseType {
  breatheIn,
  holdIn,
  breatheOut,
  holdOut,
}

class BreathingPhase {
  final BreathingPhaseType type;
  final int durationSeconds;

  const BreathingPhase({
    required this.type,
    required this.durationSeconds,
  });

  String get displayName {
    switch (type) {
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

  bool get isHold =>
      type == BreathingPhaseType.holdIn || type == BreathingPhaseType.holdOut;

  bool get showCounter => !isHold;
}
