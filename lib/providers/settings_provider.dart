import 'package:flutter/foundation.dart';
import '../services/services.dart';

/// Provider managing app settings
class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  final HapticService _hapticService;
  final AudioService _audioService;
  final PurchaseService _purchaseService;
  final AdService _adService;

  SettingsProvider({
    required StorageService storageService,
    required HapticService hapticService,
    required AudioService audioService,
    required PurchaseService purchaseService,
    required AdService adService,
  })  : _storageService = storageService,
        _hapticService = hapticService,
        _audioService = audioService,
        _purchaseService = purchaseService,
        _adService = adService;

  // Settings state
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _isPremium = false;
  bool _adsRemoved = false;
  bool _isPurchasePending = false;

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;
  bool get isPremium => _isPremium;
  bool get adsRemoved => _adsRemoved || _isPremium;
  bool get isPurchasePending => _isPurchasePending;

  /// Initialize settings
  Future<void> initialize() async {
    _soundEnabled = _storageService.isSoundEnabled();
    _hapticEnabled = _storageService.isHapticEnabled();
    _isPremium = _storageService.isPremium();
    _adsRemoved = _storageService.areAdsRemoved();

    // Apply settings
    _audioService.enabled = _soundEnabled;
    _hapticService.enabled = _hapticEnabled;

    // Update ad service
    _adService.setPremiumStatus(_isPremium);

    // Set up purchase callbacks
    _purchaseService.onPurchaseComplete = _onPurchaseComplete;
    _purchaseService.onPurchaseError = _onPurchaseError;

    notifyListeners();
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    _audioService.enabled = _soundEnabled;
    await _storageService.setSoundEnabled(_soundEnabled);
    notifyListeners();
  }

  /// Toggle haptic feedback
  Future<void> toggleHaptic() async {
    _hapticEnabled = !_hapticEnabled;
    _hapticService.enabled = _hapticEnabled;
    await _storageService.setHapticEnabled(_hapticEnabled);

    // Give feedback on current state
    if (_hapticEnabled) {
      await _hapticService.lightImpact();
    }

    notifyListeners();
  }

  /// Purchase premium
  Future<void> purchasePremium() async {
    _isPurchasePending = true;
    notifyListeners();

    await _purchaseService.purchasePremium();
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    _isPurchasePending = true;
    notifyListeners();

    await _purchaseService.restorePurchases();
  }

  /// Handle successful purchase
  void _onPurchaseComplete(bool success) {
    _isPurchasePending = false;

    if (success) {
      _isPremium = true;
      _adsRemoved = true;
      _storageService.setPremium(true);
      _storageService.setAdsRemoved(true);
      _adService.setPremiumStatus(true);
    }

    notifyListeners();
  }

  /// Handle purchase error
  void _onPurchaseError(String error) {
    _isPurchasePending = false;
    // Error can be handled by UI through a callback or stream
    notifyListeners();
  }

  /// Manually set premium (for testing)
  Future<void> debugSetPremium(bool value) async {
    _isPremium = value;
    _adsRemoved = value;
    await _storageService.setPremium(value);
    await _storageService.setAdsRemoved(value);
    _adService.setPremiumStatus(value);
    notifyListeners();
  }
}
