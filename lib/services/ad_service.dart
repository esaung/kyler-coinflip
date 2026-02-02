import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';

/// Service for managing advertisements
///
/// Handles banner and interstitial ads with a freemium model.
/// Premium users have ads disabled.
class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isPremium = false;
  bool _isInitialized = false;
  int _flipsSinceLastAd = 0;

  // Show interstitial every N flips
  static const int _flipsPerInterstitial = 10;

  /// Initialize the ad service
  Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;

    // Load initial ads
    await _loadBannerAd();
    await _loadInterstitialAd();
  }

  /// Set premium status (disables all ads)
  void setPremiumStatus(bool isPremium) {
    _isPremium = isPremium;
    if (_isPremium) {
      _disposeBannerAd();
      _disposeInterstitialAd();
    }
  }

  /// Check if ads should be shown
  bool get shouldShowAds => !_isPremium && _isInitialized;

  // ============ Banner Ads ============

  /// Load a banner ad
  Future<void> _loadBannerAd() async {
    if (_isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: AppConstants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Banner loaded successfully
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    await _bannerAd?.load();
  }

  /// Get the current banner ad (if loaded)
  BannerAd? get bannerAd => _isPremium ? null : _bannerAd;

  /// Dispose banner ad
  void _disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // ============ Interstitial Ads ============

  /// Load an interstitial ad
  Future<void> _loadInterstitialAd() async {
    if (_isPremium) return;

    await InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Track a flip and possibly show interstitial
  Future<void> onFlip() async {
    if (_isPremium) return;

    _flipsSinceLastAd++;

    if (_flipsSinceLastAd >= _flipsPerInterstitial) {
      await showInterstitial();
      _flipsSinceLastAd = 0;
    }
  }

  /// Show interstitial ad
  Future<void> showInterstitial() async {
    if (_isPremium) return;

    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  /// Dispose interstitial ad
  void _disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  // ============ Lifecycle ============

  /// Dispose all ad resources
  void dispose() {
    _disposeBannerAd();
    _disposeInterstitialAd();
  }
}
