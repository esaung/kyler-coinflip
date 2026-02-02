/// User statistics and session data
class UserStats {
  final int totalFlips;
  final int headsCount;
  final int tailsCount;
  final int currentStreak;
  final int longestStreak;
  final int sessionFlips;
  final DateTime? lastFlipTime;

  const UserStats({
    this.totalFlips = 0,
    this.headsCount = 0,
    this.tailsCount = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.sessionFlips = 0,
    this.lastFlipTime,
  });

  /// Calculate heads percentage
  double get headsPercentage {
    if (totalFlips == 0) return 50.0;
    return (headsCount / totalFlips) * 100;
  }

  /// Calculate tails percentage
  double get tailsPercentage {
    if (totalFlips == 0) return 50.0;
    return (tailsCount / totalFlips) * 100;
  }

  /// Check if stats are balanced (close to 50/50)
  bool get isBalanced {
    if (totalFlips < 10) return true;
    final diff = (headsPercentage - 50).abs();
    return diff <= 10; // Within 10% is considered balanced
  }

  /// Create a copy with updated values
  UserStats copyWith({
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
    int? currentStreak,
    int? longestStreak,
    int? sessionFlips,
    DateTime? lastFlipTime,
  }) {
    return UserStats(
      totalFlips: totalFlips ?? this.totalFlips,
      headsCount: headsCount ?? this.headsCount,
      tailsCount: tailsCount ?? this.tailsCount,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      sessionFlips: sessionFlips ?? this.sessionFlips,
      lastFlipTime: lastFlipTime ?? this.lastFlipTime,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalFlips': totalFlips,
      'headsCount': headsCount,
      'tailsCount': tailsCount,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'sessionFlips': sessionFlips,
      'lastFlipTime': lastFlipTime?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalFlips: json['totalFlips'] as int? ?? 0,
      headsCount: json['headsCount'] as int? ?? 0,
      tailsCount: json['tailsCount'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      sessionFlips: json['sessionFlips'] as int? ?? 0,
      lastFlipTime: json['lastFlipTime'] != null
          ? DateTime.parse(json['lastFlipTime'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserStats(total: $totalFlips, heads: $headsCount, tails: $tailsCount, streak: $currentStreak)';
  }
}
