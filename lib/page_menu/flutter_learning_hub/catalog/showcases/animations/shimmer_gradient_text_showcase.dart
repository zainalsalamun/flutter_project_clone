import 'package:flutter/material.dart';

class ShimmerGradientTextShowcase extends StatefulWidget {
  const ShimmerGradientTextShowcase({super.key});

  @override
  State<ShimmerGradientTextShowcase> createState() =>
      _ShimmerGradientTextShowcaseState();
}

class _ShimmerGradientTextShowcaseState
    extends State<ShimmerGradientTextShowcase> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'GOLDEN LUXURY SHIMMER',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 12),
                ShimmerGradientText(
                  text: 'FLUTTER TITAN',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  colors: [
                    Color(0xFFFDE047),
                    Color(0xFFFFFBEB),
                    Color(0xFFF59E0B),
                    Color(0xFFFFFBEB),
                    Color(0xFFD97706),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'CYBERPUNK NEON GLOW',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 12),
                ShimmerGradientText(
                  text: 'NEXT-GEN UI / UX',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFFEC4899),
                    Color(0xFF38BDF8),
                    Color(0xFF6366F1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerGradientText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final List<Color> colors;
  final Duration duration;

  const ShimmerGradientText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    required this.colors,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ShimmerGradientText> createState() => _ShimmerGradientTextState();
}

class _ShimmerGradientTextState extends State<ShimmerGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              begin: Alignment(-2.5 + (_controller.value * 5.0), -0.3),
              end: Alignment(0.5 + (_controller.value * 5.0), 0.3),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              letterSpacing: 1.5,
            ),
          ),
        );
      },
    );
  }
}
