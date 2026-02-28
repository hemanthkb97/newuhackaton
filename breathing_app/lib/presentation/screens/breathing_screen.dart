import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/breathing_phase.dart';
import '../../domain/entities/breathing_session.dart';
import '../blocs/breathing/breathing_bloc.dart';
import '../blocs/breathing/breathing_event.dart';
import '../blocs/breathing/breathing_state.dart';
import '../blocs/logs/breathing_logs_cubit.dart';
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
  // Fixed pixel sizes
  static const double _maxSize = 196.0; // breathe in fully expanded
  static const double _minSize = 121.0; // breathe out fully shrunk
  static const double _holdSize = 90.0; // hold phases

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  BreathingPhaseType? _lastPhase;
  int? _lastRound;
  BreathingStatus? _lastStatus;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final s = widget.state;

    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        final size = _sizeAnimation.value;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? AppColors.darkCircleInner.withValues(alpha: 0.25)
                  : AppColors.lightCircleInner.withValues(alpha: 0.12),
            ),
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.darkCircleInner.withValues(alpha: 0.4),
                      AppColors.darkCircleInner.withValues(alpha: 0.1),
                    ]
                  : [
                      AppColors.lightCircleInner.withValues(alpha: 0.2),
                      AppColors.lightCircleInner.withValues(alpha: 0.05),
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
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
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
    _sizeAnimation = const AlwaysStoppedAnimation(_minSize);
    _updateAnimation(widget.state);
  }

  void _updateAnimation(BreathingState s) {
    _controller.stop();

    switch (s.currentPhaseType) {
      case BreathingPhaseType.breatheIn:
        _controller.duration = Duration(seconds: s.phaseTotalSeconds);
        _sizeAnimation = Tween<double>(begin: _minSize, end: _maxSize).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.forward(from: 0);
        break;
      case BreathingPhaseType.holdIn:
        _sizeAnimation = const AlwaysStoppedAnimation(_holdSize);
        break;
      case BreathingPhaseType.breatheOut:
        _controller.duration = Duration(seconds: s.phaseTotalSeconds);
        _sizeAnimation = Tween<double>(begin: _maxSize, end: _minSize).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.forward(from: 0);
        break;
      case BreathingPhaseType.holdOut:
        _sizeAnimation = const AlwaysStoppedAnimation(_holdSize);
        break;
    }

    _lastStatus = s.status;
    _lastPhase = s.currentPhaseType;
    _lastRound = s.currentRound;
  }
}

class _BreathingView extends StatefulWidget {
  const _BreathingView();

  @override
  State<_BreathingView> createState() => _BreathingViewState();
}

class _BreathingViewState extends State<_BreathingView> {
  @override
  void initState() {
    super.initState();
    context.read<BreathingLogsCubit>().startTrackingSession(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return MultiBlocListener(
      listeners: [
        BlocListener<BreathingBloc, BreathingState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == BreathingStatus.completed) {
              context.read<BreathingLogsCubit>().saveCompletedSession();
              context.go('/result');
            }
          },
        ),
        BlocListener<BreathingBloc, BreathingState>(
          listener: (context, state) {
            context.read<BreathingLogsCubit>().updateSessionSnapshot(state);
          },
        ),
      ],
      child: BlocBuilder<BreathingBloc, BreathingState>(
        builder: (context, state) {
          return Scrollbar(
            thumbVisibility: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  primary: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: SizedBox(
                        width: 336,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.encouragingTexts[state.encouragingTextIndex %
                                    AppStrings.encouragingTexts.length],
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 53),
                              SizedBox(
                                height: 200,
                                child: Center(
                                  child: _BreathingCircle(state: state, isDark: isDark),
                                ),
                              ),
                              const SizedBox(height: 53),
                              Text(
                                state.phaseDisplayName,
                                style: TextStyle(
                                  fontSize: 24,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppStrings.encouragingTexts[(state.encouragingTextIndex +
                                        1) %
                                    AppStrings.encouragingTexts.length],
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 36),
                              _ProgressSection(state: state, isDark: isDark),
                              const SizedBox(height: 24),
                              _PauseResumeButton(state: state, isDark: isDark),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  final double progress;
  final Color bgColor;

  _GradientProgressPainter({required this.progress, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = bgColor;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(bgRect, bgPaint);

    if (progress > 0) {
      final fillWidth = size.width * progress.clamp(0.0, 1.0);
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, fillWidth, size.height),
        const Radius.circular(4),
      );
      final fillPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF8A00), Color(0xFF6C0862)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRRect(fillRect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GradientProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.bgColor != bgColor;
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

          color: isDark ? AppColors.darkPrimary : AppColors.lightBGSubtle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isPaused ? AppAssets.playIcon : AppAssets.pauseIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightButtonPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isPaused ? AppStrings.resume : AppStrings.pause,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightButtonPrimary,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.bold,
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
    return SizedBox(
      width: 240,

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: CustomPaint(
                size: const Size(double.infinity, 8),
                painter: _GradientProgressPainter(
                  progress: state.progressFraction,
                  bgColor: isDark
                      ? AppColors.darkBGSubtle
                      : AppColors.lightBGSubtle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cycle ${state.currentRound} of ${state.totalRounds}',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
