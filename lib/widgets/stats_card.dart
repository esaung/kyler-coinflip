import 'package:flutter/material.dart';
import '../models/user_stats.dart';
import '../constants/app_theme.dart';

/// Card displaying user statistics
class StatsCard extends StatelessWidget {
  final UserStats stats;

  const StatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundMedium,
            AppTheme.backgroundLight.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: AppTheme.primaryLight,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Statistics',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Total flips
          _buildStatRow(
            icon: Icons.repeat,
            label: 'Total Flips',
            value: stats.totalFlips.toString(),
            color: AppTheme.primaryLight,
          ),

          const SizedBox(height: 16),

          // Distribution bar
          _buildDistributionBar(),

          const SizedBox(height: 16),

          // Heads vs Tails
          Row(
            children: [
              Expanded(
                child: _buildResultStat(
                  label: 'Heads',
                  count: stats.headsCount,
                  percentage: stats.headsPercentage,
                  color: AppTheme.accentGold,
                  emoji: '👑',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildResultStat(
                  label: 'Tails',
                  count: stats.tailsCount,
                  percentage: stats.tailsPercentage,
                  color: AppTheme.accentSilver,
                  emoji: '🦅',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Streaks
          Row(
            children: [
              Expanded(
                child: _buildStreakStat(
                  label: 'Current Streak',
                  value: stats.currentStreak,
                  icon: Icons.local_fire_department,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStreakStat(
                  label: 'Best Streak',
                  value: stats.longestStreak,
                  icon: Icons.emoji_events,
                  isGold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionBar() {
    final headsWidth = stats.totalFlips > 0
        ? stats.headsPercentage / 100
        : 0.5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${stats.headsPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: AppTheme.accentGold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${stats.tailsPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: AppTheme.accentSilver,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppTheme.accentSilver.withOpacity(0.3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: headsWidth,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [AppTheme.accentGold, Color(0xFFDAA520)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultStat({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required String emoji,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStat({
    required String label,
    required int value,
    required IconData icon,
    bool isGold = false,
  }) {
    final color = isGold ? AppTheme.accentGold : AppTheme.primaryLight;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
