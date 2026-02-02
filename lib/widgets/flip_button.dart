import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Animated flip button with pulsing effect
class FlipButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isFlipping;
  final String label;

  const FlipButton({
    super.key,
    this.onPressed,
    this.isFlipping = false,
    this.label = 'FLIP',
  });

  @override
  State<FlipButton> createState() => _FlipButtonState();
}

class _FlipButtonState extends State<FlipButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isFlipping ? 0.95 : _pulseAnimation.value,
          child: _buildButton(),
        );
      },
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: widget.isFlipping ? null : widget.onPressed,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isFlipping
                ? [
                    AppTheme.primaryDark.withOpacity(0.5),
                    AppTheme.primaryColor.withOpacity(0.5),
                  ]
                : [
                    AppTheme.primaryLight,
                    AppTheme.primaryColor,
                    AppTheme.primaryDark,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
            if (!widget.isFlipping)
              BoxShadow(
                color: AppTheme.primaryLight.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 5,
              ),
          ],
        ),
        child: Center(
          child: widget.isFlipping
              ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 36,
                      color: AppTheme.textPrimary.withOpacity(0.9),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Reusable animated builder widget
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
