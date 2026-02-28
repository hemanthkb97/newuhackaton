import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/breathing_phase.dart';
import '../../../domain/entities/breathing_session.dart';
import 'breathing_event.dart';
import 'breathing_state.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  Timer? _timer;
  late BreathingSession _session;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _encouragingIndex = 0;

  BreathingBloc() : super(const BreathingState()) {
    on<StartBreathing>(_onStart);
    on<TickBreathing>(_onTick);
    on<PauseBreathing>(_onPause);
    on<ResumeBreathing>(_onResume);
    on<StopBreathing>(_onStop);
  }

  void _onStart(StartBreathing event, Emitter<BreathingState> emit) {
    _session = event.session;
    _encouragingIndex = 0;
    _timer?.cancel();

    emit(BreathingState(
      status: BreathingStatus.running,
      currentPhaseType: BreathingPhaseType.breatheIn,
      currentRound: 1,
      totalRounds: _session.totalRounds,
      phaseElapsedSeconds: 0,
      phaseTotalSeconds: _session.breatheInSeconds,
      totalElapsedSeconds: 0,
      totalSessionSeconds: _session.totalSessionSeconds,
      encouragingTextIndex: 0,
      breatheInDuration: _session.breatheInSeconds,
      holdInDuration: _session.holdInSeconds,
      breatheOutDuration: _session.breatheOutSeconds,
      holdOutDuration: _session.holdOutSeconds,
    ));

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickBreathing());
    });
  }

  void _onTick(TickBreathing event, Emitter<BreathingState> emit) {
    if (state.status != BreathingStatus.running) return;

    final newPhaseElapsed = state.phaseElapsedSeconds + 1;
    final newTotalElapsed = state.totalElapsedSeconds + 1;

    if (newPhaseElapsed >= state.phaseTotalSeconds) {
      // Phase completed, move to next
      _moveToNextPhase(emit, newTotalElapsed);
    } else {
      emit(state.copyWith(
        phaseElapsedSeconds: newPhaseElapsed,
        totalElapsedSeconds: newTotalElapsed,
      ));
    }
  }

  void _moveToNextPhase(Emitter<BreathingState> emit, int totalElapsed) {
    final phases = [
      BreathingPhaseType.breatheIn,
      BreathingPhaseType.holdIn,
      BreathingPhaseType.breatheOut,
      BreathingPhaseType.holdOut,
    ];

    final currentIndex = phases.indexOf(state.currentPhaseType);
    final nextIndex = currentIndex + 1;

    if (nextIndex >= phases.length) {
      // Completed a full round
      final nextRound = state.currentRound + 1;
      if (nextRound > state.totalRounds) {
        // Session complete
        _timer?.cancel();
        emit(state.copyWith(
          status: BreathingStatus.completed,
          totalElapsedSeconds: totalElapsed,
        ));
        return;
      }
      // Start next round
      _playChime();
      _encouragingIndex =
          (_encouragingIndex + 1) % AppStrings.encouragingTexts.length;
      emit(state.copyWith(
        currentPhaseType: BreathingPhaseType.breatheIn,
        currentRound: nextRound,
        phaseElapsedSeconds: 0,
        phaseTotalSeconds: _session.breatheInSeconds,
        totalElapsedSeconds: totalElapsed,
        encouragingTextIndex: _encouragingIndex,
      ));
    } else {
      // Move to next phase in same round
      _playChime();
      final nextPhase = phases[nextIndex];
      _encouragingIndex =
          (_encouragingIndex + 1) % AppStrings.encouragingTexts.length;
      emit(state.copyWith(
        currentPhaseType: nextPhase,
        phaseElapsedSeconds: 0,
        phaseTotalSeconds: _getDurationForPhase(nextPhase),
        totalElapsedSeconds: totalElapsed,
        encouragingTextIndex: _encouragingIndex,
      ));
    }
  }

  int _getDurationForPhase(BreathingPhaseType phase) {
    switch (phase) {
      case BreathingPhaseType.breatheIn:
        return _session.breatheInSeconds;
      case BreathingPhaseType.holdIn:
        return _session.holdInSeconds;
      case BreathingPhaseType.breatheOut:
        return _session.breatheOutSeconds;
      case BreathingPhaseType.holdOut:
        return _session.holdOutSeconds;
    }
  }

  void _playChime() {
    if (_session.soundEnabled) {
      _audioPlayer.play(AssetSource('audio/chime.mp3'));
    }
  }

  void _onPause(PauseBreathing event, Emitter<BreathingState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: BreathingStatus.paused));
  }

  void _onResume(ResumeBreathing event, Emitter<BreathingState> emit) {
    emit(state.copyWith(status: BreathingStatus.running));
    _startTimer();
  }

  void _onStop(StopBreathing event, Emitter<BreathingState> emit) {
    _timer?.cancel();
    emit(const BreathingState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
