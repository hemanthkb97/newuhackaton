import 'package:equatable/equatable.dart';

class SetupState extends Equatable {
  final int breathDuration;
  final int rounds;
  final bool soundEnabled;
  final bool advancedOpen;
  final int breatheInSeconds;
  final int holdInSeconds;
  final int breatheOutSeconds;
  final int holdOutSeconds;

  const SetupState({
    this.breathDuration = 4,
    this.rounds = 4,
    this.soundEnabled = true,
    this.advancedOpen = false,
    this.breatheInSeconds = 4,
    this.holdInSeconds = 4,
    this.breatheOutSeconds = 4,
    this.holdOutSeconds = 4,
  });

  SetupState copyWith({
    int? breathDuration,
    int? rounds,
    bool? soundEnabled,
    bool? advancedOpen,
    int? breatheInSeconds,
    int? holdInSeconds,
    int? breatheOutSeconds,
    int? holdOutSeconds,
  }) {
    return SetupState(
      breathDuration: breathDuration ?? this.breathDuration,
      rounds: rounds ?? this.rounds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      advancedOpen: advancedOpen ?? this.advancedOpen,
      breatheInSeconds: breatheInSeconds ?? this.breatheInSeconds,
      holdInSeconds: holdInSeconds ?? this.holdInSeconds,
      breatheOutSeconds: breatheOutSeconds ?? this.breatheOutSeconds,
      holdOutSeconds: holdOutSeconds ?? this.holdOutSeconds,
    );
  }

  int get effectiveBreatheIn =>
      advancedOpen ? breatheInSeconds : breathDuration;
  int get effectiveHoldIn => advancedOpen ? holdInSeconds : breathDuration;
  int get effectiveBreatheOut =>
      advancedOpen ? breatheOutSeconds : breathDuration;
  int get effectiveHoldOut => advancedOpen ? holdOutSeconds : breathDuration;

  @override
  List<Object?> get props => [
        breathDuration,
        rounds,
        soundEnabled,
        advancedOpen,
        breatheInSeconds,
        holdInSeconds,
        breatheOutSeconds,
        holdOutSeconds,
      ];
}
