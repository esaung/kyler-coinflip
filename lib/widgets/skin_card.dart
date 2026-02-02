import 'package:flutter/material.dart';
import '../models/coin_skin.dart';
import '../constants/app_theme.dart';

/// Card widget for displaying a coin skin in the gallery
class SkinCard extends StatelessWidget {
  final CoinSkin skin;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback? onTap;

  const SkinCard({
    super.key,
    required this.skin,
    this.isSelected = false,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? skin.primaryColor.withOpacity(0.2)
              : AppTheme.backgroundMedium,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? skin.primaryColor
                : AppTheme.textMuted.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: skin.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mini coin preview
                _buildMiniCoin(),

                const SizedBox(height: 12),

                // Skin name
                Text(
                  skin.name,
                  style: TextStyle(
                    color: isLocked
                        ? AppTheme.textMuted
                        : AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // Skin description
                Text(
                  skin.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            // Premium badge
            if (skin.isPremium)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentGold,
                        AppTheme.accentGold.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        size: 12,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Lock overlay
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      size: 32,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ),

            // Selected checkmark
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCoin() {
    return Container(
      width: 60,
      height: 60,
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
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          skin.headsIcon,
          size: 28,
          color: skin.accentColor,
        ),
      ),
    );
  }
}
