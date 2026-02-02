import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

/// Service for persisting app data locally
class StorageService {
  static const String _historyBoxName = 'flip_history';
  static const String _statsKey = 'user_stats';
  static const String _selectedSkinKey = 'selected_skin';
  static const String _isPremiumKey = 'is_premium';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _hapticEnabledKey = 'haptic_enabled';
  static const String _adsRemovedKey = 'ads_removed';

  late Box<FlipResult> _historyBox;
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the storage service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FlipResultAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CoinSideAdapter());
    }

    // Open boxes
    _historyBox = await Hive.openBox<FlipResult>(_historyBoxName);

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    _initialized = true;
  }

  /// Ensure service is initialized before use
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
  }

  // ============ History Methods ============

  /// Save a flip result to history
  Future<void> saveFlipResult(FlipResult result) async {
    _ensureInitialized();

    await _historyBox.put(result.id, result);

    // Maintain max history size
    if (_historyBox.length > AppConstants.maxHistoryItems) {
      final keysToRemove = _historyBox.keys
          .take(_historyBox.length - AppConstants.maxHistoryItems)
          .toList();
      await _historyBox.deleteAll(keysToRemove);
    }
  }

  /// Get all flip history, sorted by timestamp (newest first)
  List<FlipResult> getHistory() {
    _ensureInitialized();

    final history = _historyBox.values.toList();
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return history;
  }

  /// Get the last N flip results
  List<FlipResult> getRecentHistory(int count) {
    final history = getHistory();
    return history.take(count).toList();
  }

  /// Clear all history
  Future<void> clearHistory() async {
    _ensureInitialized();
    await _historyBox.clear();
  }

  // ============ Stats Methods ============

  /// Save user statistics
  Future<void> saveStats(UserStats stats) async {
    _ensureInitialized();
    await _prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  /// Load user statistics
  UserStats loadStats() {
    _ensureInitialized();

    final statsJson = _prefs.getString(_statsKey);
    if (statsJson == null) {
      return const UserStats();
    }

    try {
      return UserStats.fromJson(jsonDecode(statsJson) as Map<String, dynamic>);
    } catch (e) {
      return const UserStats();
    }
  }

  /// Reset all statistics
  Future<void> resetStats() async {
    _ensureInitialized();
    await _prefs.remove(_statsKey);
  }

  // ============ Settings Methods ============

  /// Get selected skin ID
  String getSelectedSkinId() {
    _ensureInitialized();
    return _prefs.getString(_selectedSkinKey) ?? CoinSkinIds.classic;
  }

  /// Set selected skin ID
  Future<void> setSelectedSkinId(String skinId) async {
    _ensureInitialized();
    await _prefs.setString(_selectedSkinKey, skinId);
  }

  /// Check if user has premium
  bool isPremium() {
    _ensureInitialized();
    return _prefs.getBool(_isPremiumKey) ?? false;
  }

  /// Set premium status
  Future<void> setPremium(bool value) async {
    _ensureInitialized();
    await _prefs.setBool(_isPremiumKey, value);
  }

  /// Check if sound is enabled
  bool isSoundEnabled() {
    _ensureInitialized();
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  /// Set sound enabled
  Future<void> setSoundEnabled(bool value) async {
    _ensureInitialized();
    await _prefs.setBool(_soundEnabledKey, value);
  }

  /// Check if haptic feedback is enabled
  bool isHapticEnabled() {
    _ensureInitialized();
    return _prefs.getBool(_hapticEnabledKey) ?? true;
  }

  /// Set haptic feedback enabled
  Future<void> setHapticEnabled(bool value) async {
    _ensureInitialized();
    await _prefs.setBool(_hapticEnabledKey, value);
  }

  /// Check if ads are removed
  bool areAdsRemoved() {
    _ensureInitialized();
    return _prefs.getBool(_adsRemovedKey) ?? false;
  }

  /// Set ads removed status
  Future<void> setAdsRemoved(bool value) async {
    _ensureInitialized();
    await _prefs.setBool(_adsRemovedKey, value);
  }

  // ============ Reset Methods ============

  /// Reset all data (for debugging/testing)
  Future<void> resetAll() async {
    _ensureInitialized();
    await _historyBox.clear();
    await _prefs.clear();
  }
}
