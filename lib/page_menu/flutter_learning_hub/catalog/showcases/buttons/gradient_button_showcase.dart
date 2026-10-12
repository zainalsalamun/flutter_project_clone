import 'package:flutter/material.dart';

class GradientButtonShowcase extends StatefulWidget {
  const GradientButtonShowcase({super.key});

  @override
  State<GradientButtonShowcase> createState() => _GradientButtonShowcaseState();
}

class _GradientButtonShowcaseState extends State<GradientButtonShowcase> {
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Clicked: $_clickCount times',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 20),
          CustomGradientButton(
            text: 'Explore Universe',
            icon: Icons.rocket_launch_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {
              setState(() => _clickCount++);
            },
          ),
          const SizedBox(height: 16),
          CustomGradientButton(
            text: 'Claim Reward',
            icon: Icons.stars_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: 30,
            onPressed: () {
              setState(() => _clickCount++);
            },
          ),
        ],
      ),
    );
  }
}

class CustomGradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const CustomGradientButton({
    super.key,
    required this.text,
    this.icon,
    required this.gradient,
    this.onPressed,
    this.height = 50,
    this.borderRadius = 14,
    this.textStyle,
  });

  @override
  State<CustomGradientButton> createState() => _CustomGradientButtonState();
}

class _CustomGradientButtonState extends State<CustomGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder:
          (context, child) =>
              Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: (widget.gradient.colors.first).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style:
                        widget.textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
