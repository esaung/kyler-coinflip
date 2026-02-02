import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_theme.dart';

/// 3D animated coin widget with realistic flip physics
class CoinWidget extends StatefulWidget {
  final CoinSkin skin;
  final CoinSide? result;
  final bool isFlipping;
  final VoidCallback? onTap;
  final double size;

  const CoinWidget({
    super.key,
    required this.skin,
    this.result,
    this.isFlipping = false,
    this.onTap,
    this.size = 200,
  });

  @override
  State<CoinWidget> createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _bounceController;
  late AnimationController _shineController;

  late Animation<double> _flipAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shineAnimation;

  bool _showingHeads = true;

  @override
  void initState() {
    super.initState();

    // Flip animation - multiple rotations
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _flipAnimation = TweenSequence<double>([
      // Initial acceleration
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 3 * math.pi)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      // Fast spinning
      TweenSequenceItem(
        tween: Tween<double>(begin: 3 * math.pi, end: 9 * math.pi)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40,
      ),
      // Deceleration and landing
      TweenSequenceItem(
        tween: Tween<double>(begin: 9 * math.pi, end: 12 * math.pi)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_flipController);

    // Bounce animation after landing
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.05),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Shine animation - continuous subtle effect
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shineAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Listen for flip animation completion
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.forward(from: 0);
      }
    });
  }

  @override
  void didUpdateWidget(CoinWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFlipping && !oldWidget.isFlipping) {
      // Start flip animation
      _flipController.forward(from: 0);
    } else if (!widget.isFlipping && oldWidget.isFlipping) {
      // Update displayed side based on result
      setState(() {
        _showingHeads = widget.result == CoinSide.heads;
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _bounceController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _flipAnimation,
          _bounceAnimation,
          _shineAnimation,
        ]),
        builder: (context, child) {
          final flipValue = _flipController.isAnimating
              ? _flipAnimation.value
              : (_showingHeads ? 0.0 : math.pi);

          final bounceScale = _bounceController.isAnimating
              ? _bounceAnimation.value
              : 1.0;

          // Determine which side to show
          final showHeads = (flipValue / math.pi).floor() % 2 == 0;

          return Transform.scale(
            scale: bounceScale,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(flipValue),
              child: _buildCoinFace(showHeads),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoinFace(bool isHeads) {
    final skin = widget.skin;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            skin.shineColor,
            skin.primaryColor,
            skin.secondaryColor,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: skin.primaryColor.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Coin rim
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: skin.secondaryColor.withOpacity(0.5),
                width: 4,
              ),
            ),
          ),

          // Inner coin face
          Center(
            child: Container(
              width: widget.size * 0.85,
              height: widget.size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    skin.primaryColor,
                    skin.secondaryColor,
                    skin.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isHeads ? skin.headsIcon : skin.tailsIcon,
                      size: widget.size * 0.3,
                      color: skin.accentColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isHeads ? skin.headsLabel : skin.tailsLabel,
                      style: TextStyle(
                        color: skin.accentColor,
                        fontSize: widget.size * 0.08,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Shine effect overlay
          AnimatedBuilder(
            animation: _shineAnimation,
            builder: (context, child) {
              return ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(_shineAnimation.value - 1, -1),
                      end: Alignment(_shineAnimation.value, 1),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Simplified animated builder that works with multiple listenables
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
