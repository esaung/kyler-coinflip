import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coin_skin.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

/// Screen for selecting and previewing coin skins
class SkinsScreen extends StatelessWidget {
  const SkinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Coin Skins',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Consumer2<CoinFlipProvider, SettingsProvider>(
        builder: (context, flipProvider, settingsProvider, child) {
          final isPremium = settingsProvider.isPremium;
          final selectedSkin = flipProvider.currentSkin;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview section
                _buildPreviewSection(selectedSkin),

                const SizedBox(height: 32),

                // Free skins section
                _buildSectionHeader(
                  title: 'Free Skins',
                  icon: Icons.star_outline,
                ),
                const SizedBox(height: 16),
                _buildSkinsGrid(
                  skins: CoinSkin.freeSkins,
                  selectedSkin: selectedSkin,
                  isPremium: true, // Free skins are always unlocked
                  onSelect: (skin) => _selectSkin(context, skin),
                ),

                const SizedBox(height: 32),

                // Premium skins section
                _buildSectionHeader(
                  title: 'Premium Skins',
                  icon: Icons.workspace_premium,
                  isPremium: true,
                ),
                const SizedBox(height: 8),

                // Premium unlock prompt
                if (!isPremium) _buildPremiumPrompt(context),

                const SizedBox(height: 16),
                _buildSkinsGrid(
                  skins: CoinSkin.premiumSkins,
                  selectedSkin: selectedSkin,
                  isPremium: isPremium,
                  onSelect: (skin) {
                    if (isPremium) {
                      _selectSkin(context, skin);
                    } else {
                      _showPremiumDialog(context);
                    }
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewSection(CoinSkin skin) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            skin.primaryColor.withOpacity(0.2),
            skin.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: skin.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'PREVIEW',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          // Mini coin preview
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.2,
                colors: [
                  skin.shineColor,
                  skin.primaryColor,
                  skin.secondaryColor,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: skin.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                skin.headsIcon,
                size: 48,
                color: skin.accentColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            skin.name,
            style: TextStyle(
              color: skin.primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            skin.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    bool isPremium = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isPremium ? AppTheme.accentGold : AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isPremium ? AppTheme.accentGold : AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentGold.withOpacity(0.2),
            AppTheme.accentGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_open,
            color: AppTheme.accentGold,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unlock Premium Skins',
                  style: TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Remove ads + unlock all premium skins',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showPremiumDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGold,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('\$${AppConstants.premiumPrice.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkinsGrid({
    required List<CoinSkin> skins,
    required CoinSkin selectedSkin,
    required bool isPremium,
    required Function(CoinSkin) onSelect,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: skins.length,
      itemBuilder: (context, index) {
        final skin = skins[index];
        final isLocked = skin.isPremium && !isPremium;

        return SkinCard(
          skin: skin,
          isSelected: skin.id == selectedSkin.id,
          isLocked: isLocked,
          onTap: () => onSelect(skin),
        );
      },
    );
  }

  void _selectSkin(BuildContext context, CoinSkin skin) {
    context.read<CoinFlipProvider>().setSkin(skin);
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: AppTheme.accentGold,
            ),
            const SizedBox(width: 8),
            const Text(
              'Go Premium',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock everything with a one-time purchase:',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildFeatureRow(Icons.block, 'Remove all advertisements'),
            _buildFeatureRow(Icons.palette, 'Unlock Golden skin'),
            _buildFeatureRow(Icons.flash_on, 'Unlock Cyberpunk skin'),
            _buildFeatureRow(Icons.auto_awesome, 'Unlock Neon skin'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Maybe Later',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsProvider>().purchasePremium();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGold,
              foregroundColor: Colors.black87,
            ),
            child: Text('Buy \$${AppConstants.premiumPrice.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.success, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
