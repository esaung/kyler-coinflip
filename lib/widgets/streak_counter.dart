import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Animated streak counter display
class StreakCounter extends StatelessWidget {
  final int streak;
  final int sessionFlips;
  final String? lastResult;

  const StreakCounter({
    super.key,
    required this.streak,
    required this.sessionFlips,
    this.lastResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMedium.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStreakColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Session flips
          _buildStatItem(
            icon: Icons.refresh,
            label: 'SESSION',
            value: sessionFlips.toString(),
            color: AppTheme.textSecondary,
          ),

          const SizedBox(width: 24),

          // Streak indicator
          _buildStreakIndicator(),

          const SizedBox(width: 24),

          // Last result
          if (lastResult != null)
            _buildStatItem(
              icon: Icons.history,
              label: 'LAST',
              value: lastResult!,
              color: lastResult == 'Heads'
                  ? AppTheme.accentGold
                  : AppTheme.accentSilver,
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color.withOpacity(0.7)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakIndicator() {
    final color = _getStreakColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStreakIcon(),
            size: 24,
            color: color,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                streak.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'STREAK',
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStreakColor() {
    if (streak >= 10) return AppTheme.accentGold;
    if (streak >= 5) return AppTheme.primaryLight;
    if (streak >= 3) return AppTheme.success;
    return AppTheme.textSecondary;
  }

  IconData _getStreakIcon() {
    if (streak >= 10) return Icons.local_fire_department;
    if (streak >= 5) return Icons.whatshot;
    if (streak >= 3) return Icons.trending_up;
    return Icons.repeat;
  }
}
