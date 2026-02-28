import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';
import 'injection_container.dart';
import 'presentation/blocs/logs/breathing_logs_cubit.dart';
import 'presentation/blocs/setup/setup_cubit.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/screens/breathing_screen.dart';
import 'presentation/screens/get_ready_screen.dart';
import 'presentation/screens/logs_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/setup_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(state: state, child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const SetupScreen()),
        ),
        GoRoute(
          path: '/get-ready',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const GetReadyScreen()),
        ),
        GoRoute(
          path: '/breathing',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const BreathingScreen()),
        ),
        GoRoute(
          path: '/result',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const ResultScreen()),
        ),
        GoRoute(
          path: '/logs',
          pageBuilder: (context, state) =>
              _fadeTransition(state, const LogsScreen()),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    opaque: false,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final fadeOut = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(fadeOut),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(fadeIn),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.03),
              end: Offset.zero,
            ).animate(fadeIn),
            child: child,
          ),
        ),
      );
    },
  );
}

class BreathingApp extends StatelessWidget {
  const BreathingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<SetupCubit>()),
        BlocProvider.value(value: sl<BreathingLogsCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp.router(
            title: 'NewU Breathing',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
