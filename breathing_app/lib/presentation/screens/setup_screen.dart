import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/core/constants/app_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../blocs/setup/setup_cubit.dart';
import '../blocs/setup/setup_state.dart';
import '../blocs/theme/theme_cubit.dart';

void _unlockWebAudio() async {
  try {
    final player = AudioPlayer();
    await player.setVolume(0);
    await player.play(AssetSource('audio/chime.mp3'));
    await Future.delayed(const Duration(milliseconds: 100));
    await player.stop();
    player.dispose();
  } catch (_) {}
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return BlocBuilder<SetupCubit, SetupState>(
      builder: (context, state) {
        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            primary: true,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: 18,
                    right: 53,
                    left: 53,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          AppStrings.setYourPace,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          AppStrings.customiseSubtitle,
                          style: TextStyle(
                            fontSize: 14,

                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 400, minWidth: 320),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 27,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                    ),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(
                        isDark: isDark,
                        title: AppStrings.breathDuration,
                        subtitle: AppStrings.secondsPerPhase,
                      ),
                      const SizedBox(height: 10),
                      _DurationChips(
                        options: const [3, 4, 5, 6],
                        labels: const ['3s', '4s', '5s', '6s'],
                        selected: state.breathDuration,
                        isDark: isDark,
                        onSelected: (val) =>
                            context.read<SetupCubit>().setBreathDuration(val),
                      ),
                      const SizedBox(height: 12),

                      // Rounds
                      _SectionLabel(
                        isDark: isDark,
                        title: AppStrings.rounds,
                        subtitle: AppStrings.fullBreathingCycles,
                      ),
                      const SizedBox(height: 10),
                      _DurationChips(
                        options: const [2, 4, 6, 8],
                        labels: const ['2 quick', '4 calm', '6 deep', '8 zen'],
                        selected: state.rounds,
                        isDark: isDark,
                        onSelected: (val) =>
                            context.read<SetupCubit>().setRounds(val),
                      ),
                      const SizedBox(height: 12),
                      _AdvancedTimingSection(state: state, isDark: isDark),
                      const SizedBox(height: 12),
                      _SoundToggle(enabled: state.soundEnabled, isDark: isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _StartButton(isDark: isDark),
                const SizedBox(height: 12),
                _ViewLogsButton(isDark: isDark),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AdvancedTimingSection extends StatelessWidget {
  final SetupState state;
  final bool isDark;
  const _AdvancedTimingSection({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.read<SetupCubit>().toggleAdvanced(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _SectionLabel(
                  title: AppStrings.advancedTiming,
                  subtitle: AppStrings.advancedTimingSubtitle,
                  isDark: isDark,
                ),
              ),
              AnimatedRotation(
                turns: state.advancedOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                  color: AppColors.iconSecondary,
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                _PhaseStepper(
                  label: AppStrings.breatheIn,
                  value: state.breatheInSeconds,
                  isDark: isDark,
                  onChanged: (v) => context.read<SetupCubit>().setBreatheIn(v),
                ),
                const SizedBox(height: 8),
                _PhaseStepper(
                  label: AppStrings.holdIn,
                  value: state.holdInSeconds,
                  isDark: isDark,
                  onChanged: (v) => context.read<SetupCubit>().setHoldIn(v),
                ),
                const SizedBox(height: 8),
                _PhaseStepper(
                  label: AppStrings.breatheOut,
                  value: state.breatheOutSeconds,
                  isDark: isDark,
                  onChanged: (v) => context.read<SetupCubit>().setBreatheOut(v),
                ),
                const SizedBox(height: 8),
                _PhaseStepper(
                  label: AppStrings.holdOut,
                  value: state.holdOutSeconds,
                  isDark: isDark,
                  onChanged: (v) => context.read<SetupCubit>().setHoldOut(v),
                ),
              ],
            ),
          ),
          crossFadeState: state.advancedOpen
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}

class _DurationChips extends StatelessWidget {
  final List<int> options;
  final List<String> labels;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onSelected;

  const _DurationChips({
    required this.options,
    required this.labels,
    required this.selected,
    required this.isDark,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = options[i] == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < options.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelected(options[i]),
              child: Container(
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected
                      ? (isDark
                            ? AppColors.darkBGAccentSubtle.withValues()
                            : AppColors.lightBGAccentSubtle.withValues())
                      : (isDark ? AppColors.darkBGPage : AppColors.lightBGPage),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                              ? AppColors.darkBGAccentSolid
                              : AppColors.lightBGAccentSolid)
                        : (isDark
                              ? AppColors.darkBorderSubtle
                              : AppColors.lightBorderSubtle),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? (isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PhaseStepper extends StatelessWidget {
  final String label;
  final int value;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _PhaseStepper({
    required this.label,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBGPage : AppColors.lightBGPage,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderSubtle
              : AppColors.lightBGAccentSubtle,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Row(
            children: [
              _StepperButton(
                icon: Icons.remove,
                isDark: isDark,
                onTap: () => onChanged(value - 1),
              ),
              const SizedBox(width: 12),
              Text(
                '${value}s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 12),
              _StepperButton(
                icon: Icons.add,
                isDark: isDark,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  const _SectionLabel({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SoundToggle extends StatefulWidget {
  final bool enabled;
  final bool isDark;
  const _SoundToggle({required this.enabled, required this.isDark});

  @override
  State<_SoundToggle> createState() => _SoundToggleState();
}

class _SoundToggleState extends State<_SoundToggle> {
  final _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _SectionLabel(
            title: AppStrings.sound,
            subtitle: AppStrings.soundSubtitle,
            isDark: widget.isDark,
          ),
        ),
        const SizedBox(width: 10),
        Switch(
          value: widget.enabled,
          onChanged: (_) => _onToggle(),
          activeTrackColor: widget.isDark
              ? AppColors.darkPrimary
              : AppColors.lightPrimary,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _onToggle() async {
    final wasEnabled = widget.enabled;
    context.read<SetupCubit>().toggleSound();
    if (!wasEnabled) {
      try {
        await _player.stop();
        await _player.play(AssetSource('audio/chime.mp3'));
      } catch (_) {
        // Web browsers may block audio playback
      }
    }
  }
}

class _StartButton extends StatelessWidget {
  final bool isDark;
  const _StartButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 271,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      ),
      child: ElevatedButton(
        onPressed: () {
          // Unlock web audio context during this user gesture
          if (kIsWeb) {
            _unlockWebAudio();
          }
          context.go('/get-ready');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppStrings.startBreathing,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AppAssets.fastWind,
              fit: BoxFit.cover,
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _StepperButton({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.chipNaturalBg : Colors.white,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : AppColors.lightIconNatural,

          size: 14,
        ),
      ),
    );
  }
}

class _ViewLogsButton extends StatelessWidget {
  final bool isDark;
  const _ViewLogsButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 197,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        color: isDark ? AppColors.chipNaturalBg : AppColors.lightBorderSubtle,
      ),
      child: ElevatedButton(
        onPressed: () => context.go('/logs'),

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          AppStrings.viewLogs,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}
