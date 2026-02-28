import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/blocs/theme/theme_cubit.dart';
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
                        onTap: () => context.go('/'),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightPrimary,
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
                        child: Icon(
                          isDark
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_outlined,
                          color: isDark ? Colors.white : Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Screen content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
