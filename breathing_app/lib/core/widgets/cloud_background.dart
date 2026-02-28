import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';

class CloudBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const CloudBackground({super.key, required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: isDark
              ? Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.4, 1.0],
                      colors: [
                        Color(0xFF1A1128),
                        Color(0xFF2D1B4E),
                        Color(0xFF3A2260),
                      ],
                    ),
                  ),
                )
              : Container(
                  color: const Color(0xFFFFFFFF),
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [0.3121, 0.6944],
                      colors: [
                        const Color(0xFF630068).withValues(alpha: 0.08),
                        const Color(0xFFFF8A00).withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
        ),

        if (isDark)
          ..._buildDarkClouds(context)
        else
          ..._buildLightClouds(context),

        Positioned.fill(child: child),

        if (isDark)
          Positioned.fill(
            child: IgnorePointer(
              child: SvgPicture.asset(AppAssets.stars, fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildDarkClouds(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 600;

    return [
      Positioned(
        top: -10,
        right: -20,
        child: SvgPicture.asset(AppAssets.darkModeMedium),
      ),
      Positioned(
        top: size.height * 0.1,
        left: -10,
        child: SvgPicture.asset(width: 200, AppAssets.darkSmallCloud1),
      ),
      Positioned(
        top: size.height * 0.45,
        left: -10,
        child: SvgPicture.asset(AppAssets.darkSmallCloud2),
      ),
      Positioned(
        top: size.height * 0.22,
        right: -10,
        child: SvgPicture.asset(AppAssets.darkSmallCloud2),
      ),
      Positioned(
        bottom: 100,
        right: -50,
        child: SvgPicture.asset(AppAssets.darkModeCloud),
      ),
      Positioned(
        bottom: 90,
        left: -20,
        child: SvgPicture.asset(AppAssets.darkModeMedium),
      ),
      Positioned(
        top: size.height * 0.22 + 15,
        right: -30,
        child: SvgPicture.asset(AppAssets.darkCloud2),
      ),
      Positioned(
        top: size.height * 0.45 + 10,
        left: -10,
        child: SvgPicture.asset(AppAssets.darkCloud1),
      ),

      if (isWide)
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.3,
          child: SvgPicture.asset(AppAssets.darkSmallCloud1, width: 160),
        ),
      if (isWide)
        Positioned(
          top: size.height * 0.55,
          left: size.width * 0.5,
          child: SvgPicture.asset(AppAssets.darkSmallCloud2, width: 140),
        ),
    ];
  }

  List<Widget> _buildLightClouds(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 600;

    return [
      Positioned(
        top: -10,
        right: -20,
        child: SvgPicture.asset(AppAssets.bigCloud, fit: BoxFit.fitWidth),
      ),

      Positioned(
        top: size.height * 0.1,
        left: -10,
        child: SvgPicture.asset(AppAssets.cloud1, width: 120),
      ),

      Positioned(
        top: size.height * 0.25,
        left: -20,
        child: SvgPicture.asset(AppAssets.cloud2, width: 160),
      ),

      Positioned(
        top: size.height * 0.22,
        right: -10,
        child: SvgPicture.asset(AppAssets.smallCloud, width: 100),
      ),

      Positioned(
        top: size.height * 0.45,
        left: -10,
        child: SvgPicture.asset(AppAssets.cloud3, width: 140),
      ),

      Positioned(
        top: size.height * 0.45 + 10,
        right: -30,
        child: SvgPicture.asset(AppAssets.cloud1Alt, width: 120),
      ),

      Positioned(
        bottom: 90,
        left: -20,
        child: SvgPicture.asset(AppAssets.mediumBottomCloud, width: 200),
      ),

      Positioned(
        bottom: 0,
        right: -50,
        child: SvgPicture.asset(AppAssets.bottomCloud),
      ),

      if (isWide)
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.3,
          child: SvgPicture.asset(AppAssets.cloud2, width: 150),
        ),
      if (isWide)
        Positioned(
          top: size.height * 0.55,
          left: size.width * 0.5,
          child: SvgPicture.asset(AppAssets.cloud3, width: 130),
        ),
    ];
  }
}
