import 'package:flutter_bloc/flutter_bloc.dart';
import 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  SetupCubit() : super(const SetupState());

  void setBreathDuration(int seconds) {
    emit(state.copyWith(breathDuration: seconds));
  }

  void setRounds(int rounds) {
    emit(state.copyWith(rounds: rounds));
  }

  void toggleSound() {
    emit(state.copyWith(soundEnabled: !state.soundEnabled));
  }

  void toggleAdvanced() {
    final opening = !state.advancedOpen;
    if (opening) {
      // When opening, sync advanced values to current breath duration
      emit(state.copyWith(
        advancedOpen: true,
        breatheInSeconds: state.breathDuration,
        holdInSeconds: state.breathDuration,
        breatheOutSeconds: state.breathDuration,
        holdOutSeconds: state.breathDuration,
      ));
    } else {
      // When closing, reset advanced values to breath duration
      emit(state.copyWith(
        advancedOpen: false,
        breatheInSeconds: state.breathDuration,
        holdInSeconds: state.breathDuration,
        breatheOutSeconds: state.breathDuration,
        holdOutSeconds: state.breathDuration,
      ));
    }
  }

  void setBreatheIn(int seconds) {
    emit(state.copyWith(breatheInSeconds: seconds.clamp(2, 10)));
  }

  void setHoldIn(int seconds) {
    emit(state.copyWith(holdInSeconds: seconds.clamp(2, 10)));
  }

  void setBreatheOut(int seconds) {
    emit(state.copyWith(breatheOutSeconds: seconds.clamp(2, 10)));
  }

  void setHoldOut(int seconds) {
    emit(state.copyWith(holdOutSeconds: seconds.clamp(2, 10)));
  }
}
