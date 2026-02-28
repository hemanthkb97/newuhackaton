import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../blocs/theme/theme_cubit.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Lottie animation
          SizedBox(
            width: 150,
            height: 150,
            child: DotLottieLoader.fromAsset(
              AppAssets.successLottie,
              frameBuilder: (context, dotlottie) {
                if (dotlottie != null) {
                  return Lottie.memory(
                    dotlottie.animations.values.single,
                    repeat: false,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            isDark ? AppStrings.youDidIt : AppStrings.youDidItEmoji,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            AppStrings.resultSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),

          // Start again button
          Container(
            width: double.infinity,
            height: 56,
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
            child: ElevatedButton(
              onPressed: () => context.go('/get-ready'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                AppStrings.startAgain,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Back to setup button
          OutlinedButton(
            onPressed: () => context.go('/'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(
                color: isDark
                    ? AppColors.darkChipBorder
                    : AppColors.lightChipBorder,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              AppStrings.backToSetUp,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightPrimary,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
