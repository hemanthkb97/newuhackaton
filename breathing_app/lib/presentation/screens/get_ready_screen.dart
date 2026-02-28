import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../blocs/countdown/countdown_cubit.dart';
import '../blocs/theme/theme_cubit.dart';

class GetReadyScreen extends StatelessWidget {
  const GetReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountdownCubit()..start(),
      child: const _GetReadyView(),
    );
  }
}

class _CountdownCircle extends StatelessWidget {
  final int count;
  final bool isDark;
  const _CountdownCircle({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.5;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isDark
              ? [
                  AppColors.darkCircleInner.withValues(alpha: 0.8),
                  AppColors.darkCircle.withValues(alpha: 0.5),
                ]
              : [
                  AppColors.lightCircleInner,
                  AppColors.lightCircle.withValues(alpha: 0.6),
                ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                count > 0 ? '$count' : '',
                key: ValueKey(count),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w300,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightPrimary,
                ),
              ),
            ),
            if (count > 0)
              Text(
                'sec',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GetReadyView extends StatelessWidget {
  const _GetReadyView();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return BlocListener<CountdownCubit, int>(
      listener: (context, count) {
        if (count == 0) {
          context.go('/breathing');
        }
      },
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Countdown circle
          BlocBuilder<CountdownCubit, int>(
            builder: (context, count) {
              return _CountdownCircle(
                count: count,
                isDark: isDark,
              );
            },
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            AppStrings.getReady,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.getReadySubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
