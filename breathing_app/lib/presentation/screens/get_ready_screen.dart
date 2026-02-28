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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: 196,
      height: 196,
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
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : Colors.black,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CountdownCubit, int>(
            builder: (context, count) {
              return _CountdownCircle(count: count, isDark: isDark);
            },
          ),
          const SizedBox(height: 53),
          Text(
            AppStrings.getReady,
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
            AppStrings.getReadySubtitle,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
