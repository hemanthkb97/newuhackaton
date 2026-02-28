import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/breathing_log.dart';
import '../blocs/logs/breathing_logs_cubit.dart';
import '../blocs/logs/breathing_logs_state.dart';
import '../blocs/theme/theme_cubit.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BreathingLogsCubit>().loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;

    return BlocBuilder<BreathingLogsCubit, BreathingLogsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.breathingLogs,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.yourSessionHistory,
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
                  if (state.logs.isNotEmpty)
                    TextButton(
                      onPressed: () => _showClearAllDialog(context, isDark),
                      child: Text(
                        AppStrings.clearAll,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.logs.isEmpty
                  ? _EmptyState(isDark: isDark)
                  : _LogsList(logs: state.logs, isDark: isDark),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(AppStrings.clearAllLogs),
          content: const Text(AppStrings.clearAllConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<BreathingLogsCubit>().clearAllLogs();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppStrings.clearAll,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkSecondary
                      : AppColors.lightSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.air_outlined,
            size: 64,
            color: AppColors.iconSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noSessionsRecorded,
            style: TextStyle(
              fontSize: 16,
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

class _LogsList extends StatelessWidget {
  final List<BreathingLog> logs;
  final bool isDark;
  const _LogsList({required this.logs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        primary: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _LogCard(log: logs[index], isDark: isDark);
        },
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  final BreathingLog log;
  final bool isDark;
  const _LogCard({required this.log, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<BreathingLogsCubit>().deleteLog(log.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            // Row 1: Date + Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(log.sessionDateTime),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                _StatusBadge(
                  status: log.completionStatus,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 2: Duration
            Text(
              '${_formatDuration(log.totalActiveSeconds)} active / ${_formatDuration(log.totalPlannedSeconds)} planned',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            // Row 3: Rounds
            Text(
              _roundsText(log),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            // Row 4: Pauses
            Text(
              _pauseText(log),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 10),
            // Row 5: Config
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBGPage : AppColors.lightBGPage,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorderSubtle
                      : AppColors.lightBorderSubtle,
                ),
              ),
              child: Text(
                'In: ${log.breatheInDuration}s \u00b7 Hold: ${log.holdInDuration}s \u00b7 Out: ${log.breatheOutDuration}s \u00b7 Hold: ${log.holdOutDuration}s',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} \u00b7 $hour:$minute $amPm';
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0 && seconds > 0) return '${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m';
    return '${seconds}s';
  }

  String _pauseText(BreathingLog log) {
    if (log.pauseCount == 0) return AppStrings.noPauses;
    return '${log.pauseCount} ${log.pauseCount == 1 ? 'pause' : 'pauses'} (${_formatDuration(log.totalPauseDurationSeconds)} total)';
  }

  String _roundsText(BreathingLog log) {
    if (log.completionStatus == SessionCompletionStatus.completed) {
      return 'Completed ${log.totalRounds}/${log.totalRounds} rounds';
    }
    final phase = log.canceledAtPhase ?? 'Unknown';
    final round = log.canceledAtRound ?? 0;
    return 'Canceled at Round $round \u00b7 $phase';
  }
}

class _StatusBadge extends StatelessWidget {
  final SessionCompletionStatus status;
  final bool isDark;
  const _StatusBadge({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == SessionCompletionStatus.completed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isCompleted
            ? AppColors.successGreen.withValues(alpha: 0.15)
            : (isDark
                ? AppColors.darkBGAccentSubtle
                : AppColors.lightBGAccentSubtle),
      ),
      child: Text(
        isCompleted ? AppStrings.completed : AppStrings.canceled,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isCompleted
              ? AppColors.successGreen
              : (isDark ? AppColors.darkSecondary : AppColors.lightSecondary),
        ),
      ),
    );
  }
}
