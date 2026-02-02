import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../constants/app_theme.dart';
import 'history_screen.dart';
import 'skins_screen.dart';
import 'settings_screen.dart';

/// Main home screen with coin flip functionality
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundDark,
              AppTheme.backgroundMedium,
              AppTheme.backgroundDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<CoinFlipProvider>(
            builder: (context, flipProvider, child) {
              return Column(
                children: [
                  // App bar
                  _buildAppBar(context),

                  // Streak counter
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: StreakCounter(
                      streak: flipProvider.currentStreak,
                      sessionFlips: flipProvider.sessionFlips,
                      lastResult: flipProvider.lastResult?.displayName,
                    ),
                  ),

                  // Main coin area
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Result display (shows above coin when landed)
                          ResultDisplay(
                            result: flipProvider.lastResult,
                            show: flipProvider.flipState == FlipState.landed,
                          ),

                          const SizedBox(height: 24),

                          // Animated coin
                          CoinWidget(
                            skin: flipProvider.currentSkin,
                            result: flipProvider.lastResult,
                            isFlipping: flipProvider.isFlipping,
                            onTap: flipProvider.isFlipping
                                ? null
                                : () => _handleFlip(context),
                            size: MediaQuery.of(context).size.width * 0.55,
                          ),

                          const SizedBox(height: 40),

                          // Flip instructions
                          AnimatedOpacity(
                            opacity: flipProvider.isFlipping ? 0 : 1,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              'Tap the coin to flip',
                              style: TextStyle(
                                color: AppTheme.textSecondary.withOpacity(0.6),
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Flip button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: FlipButton(
                      isFlipping: flipProvider.isFlipping,
                      onPressed: () => _handleFlip(context),
                    ),
                  ),

                  // Ad banner (if not premium)
                  Consumer<SettingsProvider>(
                    builder: (context, settings, child) {
                      if (settings.adsRemoved) {
                        return const SizedBox(height: 16);
                      }
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: AdPlaceholder(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // History button
          _buildNavButton(
            icon: Icons.history_rounded,
            onTap: () => _navigateToHistory(context),
          ),

          // App title
          const Text(
            'COIN FLIPPER',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),

          // Menu with skins and settings
          Row(
            children: [
              _buildNavButton(
                icon: Icons.palette_rounded,
                onTap: () => _navigateToSkins(context),
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                icon: Icons.settings_rounded,
                onTap: () => _navigateToSettings(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<void> _handleFlip(BuildContext context) async {
    final provider = context.read<CoinFlipProvider>();
    await provider.flip();
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  void _navigateToSkins(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SkinsScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }
}
