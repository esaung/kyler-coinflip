import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Consumer2<SettingsProvider, CoinFlipProvider>(
        builder: (context, settings, flipProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium status card
                if (settings.isPremium) _buildPremiumCard(),
                if (!settings.isPremium) _buildUpgradeCard(context),

                const SizedBox(height: 24),

                // Feedback settings
                _buildSectionHeader('Feedback'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.volume_up_rounded,
                  title: 'Sound Effects',
                  subtitle: 'Play sounds during coin flips',
                  trailing: Switch(
                    value: settings.soundEnabled,
                    onChanged: (_) => settings.toggleSound(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),
                _buildSettingTile(
                  icon: Icons.vibration,
                  title: 'Haptic Feedback',
                  subtitle: 'Vibrate on coin flip and landing',
                  trailing: Switch(
                    value: settings.hapticEnabled,
                    onChanged: (_) => settings.toggleHaptic(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 24),

                // Data settings
                _buildSectionHeader('Data'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.refresh,
                  title: 'Reset Session',
                  subtitle: 'Clear current session flip count',
                  onTap: () {
                    flipProvider.resetSession();
                    _showSnackBar(context, 'Session reset');
                  },
                ),
                _buildSettingTile(
                  icon: Icons.delete_forever,
                  title: 'Reset All Stats',
                  subtitle: 'Clear all history and statistics',
                  titleColor: AppTheme.error,
                  onTap: () => _showResetDialog(context),
                ),

                const SizedBox(height: 24),

                // Purchase settings
                if (!settings.isPremium) ...[
                  _buildSectionHeader('Purchases'),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    icon: Icons.restore,
                    title: 'Restore Purchases',
                    subtitle: 'Restore previously bought items',
                    onTap: () {
                      settings.restorePurchases();
                      _showSnackBar(context, 'Restoring purchases...');
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // About section
                _buildSectionHeader('About'),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: AppConstants.appVersion,
                ),
                _buildSettingTile(
                  icon: Icons.verified,
                  title: 'Fair Coin Flip',
                  subtitle: 'Powered by cryptographic randomization',
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => _showPrivacyPolicy(context),
                ),
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () => _showTermsOfService(context),
                ),

                const SizedBox(height: 32),

                // Footer
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Made with ❤️',
                        style: TextStyle(
                          color: AppTheme.textMuted.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentGold.withOpacity(0.3),
            AppTheme.accentGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentGold.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: AppTheme.accentGold,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enjoy ad-free experience & all skins!',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.2),
            AppTheme.primaryDark.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: AppTheme.primaryLight,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Remove ads & unlock all skins',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  context.read<SettingsProvider>().purchasePremium(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Get Premium - \$${AppConstants.premiumPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: AppTheme.textSecondary.withOpacity(0.7),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMedium,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: titleColor ?? AppTheme.textSecondary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.textSecondary.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? Icon(
                    Icons.chevron_right,
                    color: AppTheme.textMuted.withOpacity(0.5),
                  )
                : null),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            SizedBox(width: 8),
            Text(
              'Reset All Data',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: const Text(
          'This will permanently delete all your flip history and statistics. This action cannot be undone.',
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
              context.read<CoinFlipProvider>().resetAllStats();
              Navigator.pop(context);
              _showSnackBar(context, 'All data has been reset');
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showInfoDialog(
      context,
      'Privacy Policy',
      'Coin Flipper respects your privacy. We do not collect or share any personal information. All flip history is stored locally on your device.',
    );
  }

  void _showTermsOfService(BuildContext context) {
    _showInfoDialog(
      context,
      'Terms of Service',
      'By using Coin Flipper, you agree to use it for entertainment purposes only. The app provides a fair 50/50 random outcome but should not be used for important decisions or gambling.',
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          content,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.backgroundLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
