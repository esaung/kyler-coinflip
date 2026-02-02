import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';

/// Represents a coin skin/design
class CoinSkin {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final bool isPremium;
  final String headsLabel;
  final String tailsLabel;
  final IconData headsIcon;
  final IconData tailsIcon;

  const CoinSkin({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.isPremium = false,
    this.headsLabel = 'HEADS',
    this.tailsLabel = 'TAILS',
    this.headsIcon = Icons.star,
    this.tailsIcon = Icons.shield,
  });

  /// Get gradient colors for the coin
  List<Color> get gradientColors => [
        primaryColor,
        secondaryColor,
        primaryColor.withOpacity(0.8),
      ];

  /// Get the shine/highlight color
  Color get shineColor => accentColor.withOpacity(0.6);

  /// All available coin skins
  static List<CoinSkin> get allSkins => [
        classic,
        silver,
        bronze,
        golden,
        cyberpunk,
        neon,
      ];

  /// Free skins only
  static List<CoinSkin> get freeSkins =>
      allSkins.where((skin) => !skin.isPremium).toList();

  /// Premium skins only
  static List<CoinSkin> get premiumSkins =>
      allSkins.where((skin) => skin.isPremium).toList();

  /// Get skin by ID
  static CoinSkin getById(String id) {
    return allSkins.firstWhere(
      (skin) => skin.id == id,
      orElse: () => classic,
    );
  }

  // Predefined Skins
  static const CoinSkin classic = CoinSkin(
    id: CoinSkinIds.classic,
    name: 'Classic',
    description: 'The timeless copper penny design',
    primaryColor: Color(0xFFB87333),
    secondaryColor: Color(0xFF8B4513),
    accentColor: Color(0xFFFFE4B5),
    isPremium: false,
    headsIcon: Icons.account_circle,
    tailsIcon: Icons.account_balance,
  );

  static const CoinSkin silver = CoinSkin(
    id: CoinSkinIds.silver,
    name: 'Silver',
    description: 'Sleek and modern silver finish',
    primaryColor: AppTheme.accentSilver,
    secondaryColor: Color(0xFF808080),
    accentColor: Colors.white,
    isPremium: false,
    headsIcon: Icons.brightness_7,
    tailsIcon: Icons.brightness_3,
  );

  static const CoinSkin bronze = CoinSkin(
    id: CoinSkinIds.bronze,
    name: 'Bronze',
    description: 'Ancient bronze medallion style',
    primaryColor: AppTheme.accentBronze,
    secondaryColor: Color(0xFF8B4513),
    accentColor: Color(0xFFDEB887),
    isPremium: false,
    headsIcon: Icons.military_tech,
    tailsIcon: Icons.workspace_premium,
  );

  static const CoinSkin golden = CoinSkin(
    id: CoinSkinIds.golden,
    name: 'Golden',
    description: 'Premium 24-karat gold luxury coin',
    primaryColor: AppTheme.accentGold,
    secondaryColor: Color(0xFFDAA520),
    accentColor: Color(0xFFFFFACD),
    isPremium: true,
    headsIcon: Icons.diamond,
    tailsIcon: Icons.auto_awesome,
  );

  static const CoinSkin cyberpunk = CoinSkin(
    id: CoinSkinIds.cyberpunk,
    name: 'Cyberpunk',
    description: 'Futuristic neon-lit digital coin',
    primaryColor: AppTheme.accentCyberpunk,
    secondaryColor: Color(0xFF00CED1),
    accentColor: Color(0xFFE0FFFF),
    isPremium: true,
    headsLabel: 'YES',
    tailsLabel: 'NO',
    headsIcon: Icons.check_circle,
    tailsIcon: Icons.cancel,
  );

  static const CoinSkin neon = CoinSkin(
    id: CoinSkinIds.neon,
    name: 'Neon',
    description: 'Vibrant neon glow effect',
    primaryColor: AppTheme.accentNeon,
    secondaryColor: Color(0xFFFF1493),
    accentColor: Color(0xFFFFB6C1),
    isPremium: true,
    headsIcon: Icons.flash_on,
    tailsIcon: Icons.flash_off,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinSkin && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
