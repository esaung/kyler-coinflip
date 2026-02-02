import 'dart:math';
import '../models/flip_result.dart';

/// Service responsible for generating true random coin flip results
///
/// Uses a cryptographically secure random number generator to ensure
/// fair 50/50 probability for each flip.
class RandomizationService {
  // Use secure random for better randomness
  final Random _random = Random.secure();

  // Track flip statistics for verification
  int _totalFlips = 0;
  int _headsCount = 0;
  int _tailsCount = 0;

  /// Performs a single coin flip with true 50/50 probability
  ///
  /// Returns [CoinSide.heads] or [CoinSide.tails] with equal probability.
  CoinSide flip() {
    // Generate a random boolean - true for heads, false for tails
    final bool isHeads = _random.nextBool();

    // Update tracking statistics
    _totalFlips++;
    if (isHeads) {
      _headsCount++;
    } else {
      _tailsCount++;
    }

    return isHeads ? CoinSide.heads : CoinSide.tails;
  }

  /// Performs multiple coin flips
  ///
  /// Returns a list of [CoinSide] results.
  List<CoinSide> flipMultiple(int count) {
    return List.generate(count, (_) => flip());
  }

  /// Get the current heads percentage (for verification/stats display)
  double get headsPercentage {
    if (_totalFlips == 0) return 50.0;
    return (_headsCount / _totalFlips) * 100;
  }

  /// Get the current tails percentage
  double get tailsPercentage {
    if (_totalFlips == 0) return 50.0;
    return (_tailsCount / _totalFlips) * 100;
  }

  /// Get total flips performed by this service instance
  int get totalFlips => _totalFlips;

  /// Get heads count
  int get headsCount => _headsCount;

  /// Get tails count
  int get tailsCount => _tailsCount;

  /// Reset internal statistics
  void resetStats() {
    _totalFlips = 0;
    _headsCount = 0;
    _tailsCount = 0;
  }

  /// Verify randomness by performing test flips
  ///
  /// Returns true if the distribution is within acceptable variance
  /// (typically within 5% of 50/50 for large sample sizes)
  Future<bool> verifyRandomness({int sampleSize = 1000}) async {
    int heads = 0;
    for (int i = 0; i < sampleSize; i++) {
      if (_random.nextBool()) heads++;
    }

    final percentage = (heads / sampleSize) * 100;
    // Should be between 45% and 55% for a fair distribution
    return percentage >= 45 && percentage <= 55;
  }

  /// Get a seeded random result (for testing/debugging only)
  ///
  /// This should NOT be used in production as it's not truly random.
  CoinSide flipWithSeed(int seed) {
    final seededRandom = Random(seed);
    return seededRandom.nextBool() ? CoinSide.heads : CoinSide.tails;
  }
}
