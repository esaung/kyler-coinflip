import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';

/// State for the coin flip animation
enum FlipState {
  idle,
  flipping,
  landed,
}

/// Provider managing coin flip state and logic
class CoinFlipProvider extends ChangeNotifier {
  final RandomizationService _randomService = RandomizationService();
  final StorageService _storageService;
  final HapticService _hapticService;
  final AudioService _audioService;
  final AdService _adService;

  CoinFlipProvider({
    required StorageService storageService,
    required HapticService hapticService,
    required AudioService audioService,
    required AdService adService,
  })  : _storageService = storageService,
        _hapticService = hapticService,
        _audioService = audioService,
        _adService = adService;

  // State
  FlipState _flipState = FlipState.idle;
  CoinSide? _lastResult;
  CoinSkin _currentSkin = CoinSkin.classic;
  UserStats _stats = const UserStats();
  List<FlipResult> _history = [];
  int _sessionFlips = 0;

  // Getters
  FlipState get flipState => _flipState;
  CoinSide? get lastResult => _lastResult;
  CoinSkin get currentSkin => _currentSkin;
  UserStats get stats => _stats;
  List<FlipResult> get history => _history;
  int get sessionFlips => _sessionFlips;
  bool get isFlipping => _flipState == FlipState.flipping;

  /// Calculate current streak (consecutive same results)
  int get currentStreak {
    if (_history.isEmpty) return 0;

    final lastSide = _history.first.result;
    int streak = 0;

    for (final flip in _history) {
      if (flip.result == lastSide) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Initialize the provider
  Future<void> initialize() async {
    // Load saved data
    _stats = _storageService.loadStats();
    _history = _storageService.getHistory();

    // Load selected skin
    final skinId = _storageService.getSelectedSkinId();
    _currentSkin = CoinSkin.getById(skinId);

    // Reset session flips
    _sessionFlips = 0;

    notifyListeners();
  }

  /// Perform a coin flip
  Future<CoinSide> flip() async {
    if (_flipState == FlipState.flipping) {
      return _lastResult ?? CoinSide.heads;
    }

    // Start flip
    _flipState = FlipState.flipping;
    notifyListeners();

    // Play flip sound and haptic
    await _audioService.playCoinFlip();
    await _hapticService.coinFlipPattern();

    // Generate random result
    final result = _randomService.flip();

    // Wait for animation duration
    await Future.delayed(AppConstants.flipAnimationDuration);

    // Land the coin
    _lastResult = result;
    _flipState = FlipState.landed;
    _sessionFlips++;

    // Play landing effects
    await _audioService.playCoinLand();
    await _hapticService.coinLandPattern();

    // Save result
    final flipResult = FlipResult.create(
      result: result,
      skinId: _currentSkin.id,
      sessionFlipNumber: _sessionFlips,
    );

    await _storageService.saveFlipResult(flipResult);
    _history = _storageService.getHistory();

    // Update stats
    _stats = _stats.copyWith(
      totalFlips: _stats.totalFlips + 1,
      headsCount: result == CoinSide.heads
          ? _stats.headsCount + 1
          : _stats.headsCount,
      tailsCount: result == CoinSide.tails
          ? _stats.tailsCount + 1
          : _stats.tailsCount,
      sessionFlips: _sessionFlips,
      currentStreak: currentStreak,
      longestStreak: currentStreak > _stats.longestStreak
          ? currentStreak
          : _stats.longestStreak,
      lastFlipTime: DateTime.now(),
    );
    await _storageService.saveStats(_stats);

    // Check for streak achievements
    if (currentStreak >= 5 && currentStreak % 5 == 0) {
      await _audioService.playStreak();
      await _hapticService.successFeedback();
    }

    // Track for ads
    await _adService.onFlip();

    notifyListeners();

    // Reset to idle after display duration
    await Future.delayed(AppConstants.resultDisplayDuration);
    _flipState = FlipState.idle;
    notifyListeners();

    return result;
  }

  /// Set the current coin skin
  Future<void> setSkin(CoinSkin skin) async {
    _currentSkin = skin;
    await _storageService.setSelectedSkinId(skin.id);
    notifyListeners();
  }

  /// Clear flip history
  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    _history = [];
    notifyListeners();
  }

  /// Reset session
  void resetSession() {
    _sessionFlips = 0;
    _lastResult = null;
    _flipState = FlipState.idle;
    notifyListeners();
  }

  /// Reset all stats
  Future<void> resetAllStats() async {
    await _storageService.resetStats();
    await _storageService.clearHistory();
    _stats = const UserStats();
    _history = [];
    _sessionFlips = 0;
    _lastResult = null;
    _randomService.resetStats();
    notifyListeners();
  }
}
