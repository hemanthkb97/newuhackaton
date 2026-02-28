import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                        Text(
                          isDark
                              ? AppStrings.youDidIt
                              : AppStrings.youDidItEmoji,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.resultSubtitle,

                          style: TextStyle(
                            fontSize: 14,

                            height: 1.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 56,
                          width: 271,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),

                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.startAgain,
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
                        ),
                        const SizedBox(height: 24),
                        if (!kIsWeb)
                          Container(
                            height: 56,
                            width: 197,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),

                              color: isDark
                                  ? AppColors.chipNaturalBg
                                  : AppColors.lightBorderSubtle,
                            ),
                            child: ElevatedButton(
                              onPressed: () => context.go('/'),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Text(
                                AppStrings.backToSetUp,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                          ),
                        if (kIsWeb)
                          GestureDetector(
                            onTap: () => context.go('/'),
                            child: Text(
                              AppStrings.backHome,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightPrimary,
                              ),
                            ),
                          ),
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
  }
}
