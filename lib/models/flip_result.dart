import 'package:hive/hive.dart';

part 'flip_result.g.dart';

/// Represents the outcome of a coin flip
enum CoinSide {
  heads,
  tails,
}

/// Extension methods for CoinSide
extension CoinSideExtension on CoinSide {
  String get displayName {
    switch (this) {
      case CoinSide.heads:
        return 'Heads';
      case CoinSide.tails:
        return 'Tails';
    }
  }

  String get emoji {
    switch (this) {
      case CoinSide.heads:
        return '👑';
      case CoinSide.tails:
        return '🦅';
    }
  }
}

/// Model representing a single coin flip result
@HiveType(typeId: 0)
class FlipResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final CoinSide result;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String skinId;

  @HiveField(4)
  final int sessionFlipNumber;

  FlipResult({
    required this.id,
    required this.result,
    required this.timestamp,
    required this.skinId,
    required this.sessionFlipNumber,
  });

  /// Create a new FlipResult with generated ID
  factory FlipResult.create({
    required CoinSide result,
    required String skinId,
    required int sessionFlipNumber,
  }) {
    return FlipResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      result: result,
      timestamp: DateTime.now(),
      skinId: skinId,
      sessionFlipNumber: sessionFlipNumber,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result.index,
      'timestamp': timestamp.toIso8601String(),
      'skinId': skinId,
      'sessionFlipNumber': sessionFlipNumber,
    };
  }

  /// Create from JSON map
  factory FlipResult.fromJson(Map<String, dynamic> json) {
    return FlipResult(
      id: json['id'] as String,
      result: CoinSide.values[json['result'] as int],
      timestamp: DateTime.parse(json['timestamp'] as String),
      skinId: json['skinId'] as String,
      sessionFlipNumber: json['sessionFlipNumber'] as int,
    );
  }

  @override
  String toString() {
    return 'FlipResult(id: $id, result: ${result.displayName}, timestamp: $timestamp)';
  }
}
