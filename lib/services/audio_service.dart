import 'package:audioplayers/audioplayers.dart';

/// Service for handling sound effects
///
/// Provides audio feedback for coin flips, UI interactions,
/// and other events to enhance the user experience.
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;
  double _volume = 0.7;

  // Sound effect paths
  static const String _coinFlipSound = 'sounds/coin_flip.mp3';
  static const String _coinLandSound = 'sounds/coin_land.mp3';
  static const String _buttonClickSound = 'sounds/button_click.mp3';
  static const String _successSound = 'sounds/success.mp3';
  static const String _streakSound = 'sounds/streak.mp3';

  /// Initialize the audio service
  Future<void> initialize() async {
    await _player.setVolume(_volume);
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  /// Enable or disable sound
  set enabled(bool value) => _enabled = value;

  /// Get current enabled state
  bool get enabled => _enabled;

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
  }

  /// Get current volume
  double get volume => _volume;

  /// Play a sound effect from assets
  Future<void> _playSound(String soundPath) async {
    if (!_enabled) return;

    try {
      await _player.stop();
      await _player.play(AssetSource(soundPath));
    } catch (e) {
      // Silently fail if sound can't be played
      // This prevents crashes on devices without sound
    }
  }

  /// Play coin flip sound (whoosh/spin)
  Future<void> playCoinFlip() async {
    await _playSound(_coinFlipSound);
  }

  /// Play coin landing sound (metallic clink)
  Future<void> playCoinLand() async {
    await _playSound(_coinLandSound);
  }

  /// Play button click sound
  Future<void> playButtonClick() async {
    await _playSound(_buttonClickSound);
  }

  /// Play success/celebration sound
  Future<void> playSuccess() async {
    await _playSound(_successSound);
  }

  /// Play streak achievement sound
  Future<void> playStreak() async {
    await _playSound(_streakSound);
  }

  /// Stop any currently playing sound
  Future<void> stop() async {
    await _player.stop();
  }

  /// Dispose of audio resources
  Future<void> dispose() async {
    await _player.dispose();
  }
}
