import 'package:equatable/equatable.dart';
import '../../../domain/entities/breathing_session.dart';

abstract class BreathingEvent extends Equatable {
  const BreathingEvent();
  @override
  List<Object?> get props => [];
}

class StartBreathing extends BreathingEvent {
  final BreathingSession session;
  const StartBreathing(this.session);
  @override
  List<Object?> get props => [session];
}

class TickBreathing extends BreathingEvent {
  const TickBreathing();
}

class PauseBreathing extends BreathingEvent {
  const PauseBreathing();
}

class ResumeBreathing extends BreathingEvent {
  const ResumeBreathing();
}

class StopBreathing extends BreathingEvent {
  const StopBreathing();
}
