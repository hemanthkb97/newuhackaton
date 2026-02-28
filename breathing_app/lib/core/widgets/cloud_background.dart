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
              ?
                // Container(
                //     decoration: const BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Color(0xFF1A1128),
                //           Color(0xFF2D1B4E),
                //           Color(0xFF3A2260),
                //         ],
                //       ),
                //     ),
                //   )
                SvgPicture.asset(
                  AppAssets.darkModeBg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : SvgPicture.asset(
                  AppAssets.lightBackground,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),

        // Stars overlay for dark mode

        // Small scattered clouds on top (dark mode only)
        if (isDark) ..._buildDarkClouds(context) else ..._buildLightClouds(),

        // Content
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
    return [
      Positioned(
        top: -10,
        right: -20,
        child: SvgPicture.asset(AppAssets.darkModeMedium),
      ),
      Positioned(
        top: MediaQuery.sizeOf(context).height * 0.1,
        left: -10,
        child: SvgPicture.asset(width: 200, AppAssets.darkSmallCloud1),
      ),
      Positioned(
        top: MediaQuery.sizeOf(context).height * 0.45,
        left: -10,
        child: SvgPicture.asset(AppAssets.darkSmallCloud2),
      ),
      Positioned(
        top: MediaQuery.sizeOf(context).height * 0.22,
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
        top: MediaQuery.sizeOf(context).height * 0.22 + 15,
        right: -30,
        child: SvgPicture.asset(AppAssets.darkCloud2),
      ),
      Positioned(
        top: MediaQuery.sizeOf(context).height * 0.45 + 10,
        left: -10,
        child: SvgPicture.asset(AppAssets.darkCloud1),
      ),
    ];
  }

  List<Widget> _buildLightClouds() {
    return [
      Positioned(
        top: 11,
        right: -12,
        child: SvgPicture.asset(AppAssets.bigCloud, fit: BoxFit.fitWidth),
      ),
      Positioned(
        bottom: 0,
        right: -10,
        child: SvgPicture.asset(AppAssets.mediumBottomCloud, width: 200),
      ),
      Positioned(
        top: 60,
        right: -20,
        child: SvgPicture.asset(AppAssets.smallCloud, width: 100),
      ),
      Positioned(
        top: 120,
        left: -15,
        child: SvgPicture.asset(AppAssets.cloud1, width: 80),
      ),
    ];
  }
}
