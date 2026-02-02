/// Application-wide constants for Coin Flipper
library;

class AppConstants {
  // App Info
  static const String appName = 'Coin Flipper';
  static const String appVersion = '1.0.0';

  // History Settings
  static const int maxHistoryItems = 20;

  // Premium IAP
  static const String premiumProductId = 'coin_flipper_premium';
  static const double premiumPrice = 1.99;

  // Ad Unit IDs (Test IDs - Replace with real IDs for production)
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  // Animation Durations
  static const Duration flipAnimationDuration = Duration(milliseconds: 1500);
  static const Duration resultDisplayDuration = Duration(milliseconds: 500);

  // Haptic Patterns
  static const int hapticFlipDuration = 50;
  static const int hapticLandDuration = 100;
}

class CoinSkinIds {
  static const String classic = 'classic';
  static const String silver = 'silver';
  static const String bronze = 'bronze';
  static const String golden = 'golden';
  static const String cyberpunk = 'cyberpunk';
  static const String neon = 'neon';
}
