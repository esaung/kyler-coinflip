import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../constants/app_theme.dart';

/// Screen displaying flip history and statistics
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Consumer<CoinFlipProvider>(
            builder: (context, provider, child) {
              if (provider.history.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showClearDialog(context),
                tooltip: 'Clear History',
              );
            },
          ),
        ],
      ),
      body: Consumer<CoinFlipProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // Statistics card
              SliverToBoxAdapter(
                child: StatsCard(stats: provider.stats),
              ),

              // History header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Recent Flips',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.history.length} flips',
                        style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // History list or empty state
              if (provider.history.isEmpty)
                SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final result = provider.history[index];
                      return HistoryTile(
                        result: result,
                        index: index,
                      );
                    },
                    childCount: provider.history.length,
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on_outlined,
            size: 80,
            color: AppTheme.textMuted.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No flips yet',
            style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start flipping to see your history!',
            style: TextStyle(
              color: AppTheme.textMuted.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear History',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to clear all flip history? This cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CoinFlipProvider>().clearHistory();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
