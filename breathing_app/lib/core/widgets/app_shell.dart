import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/blocs/logs/breathing_logs_cubit.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import 'cloud_background.dart';

class AppShell extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const AppShell({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;
    final location = state.uri.path;
    final showClose = location == '/get-ready' || location == '/breathing';
    final showBack = location == '/logs';

    return Scaffold(
      body: CloudBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showClose)
                      GestureDetector(
                        onTap: () {
                          if (location == '/breathing') {
                            context
                                .read<BreathingLogsCubit>()
                                .saveCanceledSession();
                          }
                          context.go('/');
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkBGSubtle
                                : AppColors.lightBGSubtle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.iconSecondary,
                          ),
                        ),
                      )
                    else if (showBack)
                      GestureDetector(
                        onTap: () => context.go('/'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.darkBGSubtle
                                : AppColors.lightBGSubtle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: AppColors.iconSecondary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 42),

                    GestureDetector(
                      onTap: () => context.read<ThemeCubit>().toggle(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.04),
                        ),
                        child: SvgPicture.asset(
                          isDark ? AppAssets.sunIcon : AppAssets.moonIcon,
                          width: 20,
                          height: 20,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Screen content
              Expanded(child: child),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
