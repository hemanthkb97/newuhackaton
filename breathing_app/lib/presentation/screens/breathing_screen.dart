import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/breathing_phase.dart';
import '../../domain/entities/breathing_session.dart';
import '../blocs/breathing/breathing_bloc.dart';
import '../blocs/breathing/breathing_event.dart';
import '../blocs/breathing/breathing_state.dart';
import '../blocs/setup/setup_cubit.dart';
import '../blocs/theme/theme_cubit.dart';

class BreathingScreen extends StatelessWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final setup = context.read<SetupCubit>().state;
    final session = BreathingSession(
      breatheInSeconds: setup.effectiveBreatheIn,
      holdInSeconds: setup.effectiveHoldIn,
      breatheOutSeconds: setup.effectiveBreatheOut,
      holdOutSeconds: setup.effectiveHoldOut,
      totalRounds: setup.rounds,
      soundEnabled: setup.soundEnabled,
    );

    return BlocProvider(
      create: (_) => BreathingBloc()..add(StartBreathing(session)),
      child: const _BreathingView(),
    );
  }
}

class _BreathingCircle extends StatefulWidget {
  final BreathingState state;
  final bool isDark;

  const _BreathingCircle({required this.state, required this.isDark});

  @override
  State<_BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<_BreathingCircle>
    with SingleTickerProviderStateMixin {
  static const double _minScale = 0.55;
  static const double _maxScale = 1.0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  BreathingPhaseType? _lastPhase;
  int? _lastRound;
  BreathingStatus? _lastStatus;

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size.width * 0.55;
    final isDark = widget.isDark;
    final s = widget.state;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _scaleAnimation.value;
        return Container(
          width: maxSize * scale,
          height: maxSize * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.darkCircleInner.withValues(alpha: 0.9),
                      AppColors.darkCircle.withValues(alpha: 0.5),
                    ]
                  : [
                      AppColors.lightCircleInner,
                      AppColors.lightCircle.withValues(alpha: 0.6),
                    ],
            ),
          ),
          child: Center(
            child: s.isHoldPhase
                ? const SizedBox.shrink()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      '${s.displayCounter}',
                      key: ValueKey(s.displayCounter),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant _BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final s = widget.state;

    // Handle pause/resume
    if (_lastStatus != s.status) {
      if (s.status == BreathingStatus.paused) {
        _controller.stop();
      } else if (s.status == BreathingStatus.running &&
          _lastStatus == BreathingStatus.paused) {
        _controller.forward();
      }
      _lastStatus = s.status;
    }

    // Handle phase changes
    if (_lastPhase != s.currentPhaseType || _lastRound != s.currentRound) {
      _updateAnimation(s);
      _lastPhase = s.currentPhaseType;
      _lastRound = s.currentRound;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleAnimation = Tween<double>(
      begin: _minScale,
      end: _minScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _updateAnimation(widget.state);
  }

  void _updateAnimation(BreathingState s) {
    _controller.stop();

    switch (s.currentPhaseType) {
      case BreathingPhaseType.breatheIn:
        _controller.duration = Duration(seconds: s.phaseTotalSeconds);
        _scaleAnimation = Tween<double>(begin: _minScale, end: _maxScale)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            );
        _controller.forward(from: 0);
        break;
      case BreathingPhaseType.holdIn:
        _scaleAnimation = AlwaysStoppedAnimation(_maxScale);
        break;
      case BreathingPhaseType.breatheOut:
        _controller.duration = Duration(seconds: s.phaseTotalSeconds);
        _scaleAnimation = Tween<double>(begin: _maxScale, end: _minScale)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            );
        _controller.forward(from: 0);
        break;
      case BreathingPhaseType.holdOut:
        _scaleAnimation = AlwaysStoppedAnimation(_minScale);
        break;
    }

    _lastStatus = s.status;
    _lastPhase = s.currentPhaseType;
    _lastRound = s.currentRound;
  }
}

class _BreathingView extends StatelessWidget {
  const _BreathingView();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return BlocListener<BreathingBloc, BreathingState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == BreathingStatus.completed) {
          context.go('/result');
        }
      },
      child: BlocBuilder<BreathingBloc, BreathingState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 8),

              // Encouraging text
              Text(
                AppStrings.encouragingTexts[state.encouragingTextIndex %
                    AppStrings.encouragingTexts.length],
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Breathing circle
              Expanded(
                child: Center(
                  child: _BreathingCircle(state: state, isDark: isDark),
                ),
              ),

              // Phase name
              Text(
                state.phaseDisplayName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),

              // Sub-text
              Text(
                AppStrings.encouragingTexts[(state.encouragingTextIndex + 1) %
                    AppStrings.encouragingTexts.length],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Progress bar
              _ProgressSection(state: state, isDark: isDark),
              const SizedBox(height: 20),

              // Pause/Resume button
              _PauseResumeButton(state: state, isDark: isDark),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _PauseResumeButton extends StatelessWidget {
  final BreathingState state;
  final bool isDark;
  const _PauseResumeButton({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isPaused = state.status == BreathingStatus.paused;

    return GestureDetector(
      onTap: () {
        if (isPaused) {
          context.read<BreathingBloc>().add(const ResumeBreathing());
        } else {
          context.read<BreathingBloc>().add(const PauseBreathing());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    AppColors.darkPrimaryGradientStart,
                    AppColors.darkPrimaryGradientEnd,
                  ],
                )
              : null,
          color: isDark ? null : AppColors.lightPrimary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isPaused ? AppStrings.resume : AppStrings.pause,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final BreathingState state;
  final bool isDark;
  const _ProgressSection({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.progressFraction,
              minHeight: 6,
              backgroundColor: isDark
                  ? AppColors.darkProgressBg
                  : AppColors.lightProgressBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark
                    ? AppColors.darkProgressFill
                    : AppColors.lightProgressFill,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cycle ${state.currentRound} of ${state.totalRounds}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
