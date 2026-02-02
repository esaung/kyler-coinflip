import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Service for handling haptic feedback
///
/// Provides tactile feedback synchronized with coin animations
/// to enhance the physical feel of the app.
class HapticService {
  bool _enabled = true;
  bool? _hasVibrator;

  /// Check if device has vibration capability
  Future<bool> get hasVibrator async {
    _hasVibrator ??= await Vibration.hasVibrator() ?? false;
    return _hasVibrator!;
  }

  /// Enable or disable haptic feedback
  set enabled(bool value) => _enabled = value;

  /// Get current enabled state
  bool get enabled => _enabled;

  /// Light haptic feedback - for UI interactions
  Future<void> lightImpact() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium haptic feedback - for coin flip initiation
  Future<void> mediumImpact() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Heavy haptic feedback - for coin landing
  Future<void> heavyImpact() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Selection click - for button presses
  Future<void> selectionClick() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      HapticFeedback.selectionClick();
    }
  }

  /// Custom vibration pattern for coin flip
  ///
  /// Creates a sequence of vibrations that simulate
  /// the coin spinning and landing.
  Future<void> coinFlipPattern() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      // Quick pulses during flip
      await Vibration.vibrate(duration: 30);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 30);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 30);
    }
  }

  /// Vibration for coin landing - satisfying thud
  Future<void> coinLandPattern() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      // Strong initial impact
      await Vibration.vibrate(duration: 80);
      await Future.delayed(const Duration(milliseconds: 50));
      // Smaller bounce
      await Vibration.vibrate(duration: 40);
      await Future.delayed(const Duration(milliseconds: 30));
      // Final settle
      await Vibration.vibrate(duration: 20);
    }
  }

  /// Custom vibration pattern with specified durations
  Future<void> customPattern(List<int> pattern) async {
    if (!_enabled) return;

    if (await hasVibrator) {
      await Vibration.vibrate(pattern: pattern);
    }
  }

  /// Success feedback - for achievements or streaks
  Future<void> successFeedback() async {
    if (!_enabled) return;

    if (await hasVibrator) {
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 100);
    }
  }

  /// Cancel ongoing vibration
  Future<void> cancel() async {
    await Vibration.cancel();
  }
}
