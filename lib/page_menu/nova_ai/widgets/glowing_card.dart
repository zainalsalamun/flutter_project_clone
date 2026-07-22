import 'package:flutter/material.dart';

class GlowingCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color glowColor;
  final double padding;

  const GlowingCard({
    super.key,
    required this.child,
    this.onTap,
    this.glowColor = const Color(0xFF6366F1), // Default Indigo
    this.padding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E).withOpacity(0.8), // Dark glassy inner
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: glowColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: -5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
