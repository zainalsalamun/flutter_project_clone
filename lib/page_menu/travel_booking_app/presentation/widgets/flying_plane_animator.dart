import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';

class FlyingPlaneAnimator {
  static Future<void> flyAirplane({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    Widget? customFlyer,
    Duration duration = const Duration(milliseconds: 850),
    VoidCallback? onArrival,
  }) async {
    final overlay = Overlay.of(context);
    final sourceContext = sourceKey.currentContext;
    final targetContext = targetKey.currentContext;

    if (sourceContext == null || targetContext == null) {
      onArrival?.call();
      return;
    }

    final sourceBox = sourceContext.findRenderObject() as RenderBox?;
    final targetBox = targetContext.findRenderObject() as RenderBox?;

    if (sourceBox == null || targetBox == null || !sourceBox.attached || !targetBox.attached) {
      onArrival?.call();
      return;
    }

    final start = sourceBox.localToGlobal(
      Offset(sourceBox.size.width / 2, sourceBox.size.height / 2),
    );
    final end = targetBox.localToGlobal(
      Offset(targetBox.size.width / 2, targetBox.size.height / 2),
    );

    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: duration,
    );

    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    late OverlayEntry entry;

    final midX = (start.dx + end.dx) / 2 + (start.dx > end.dx ? -60 : 60);
    final midY = math.min(start.dy, end.dy) - 140;
    final control = Offset(midX, midY);

    entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;

            final dx = math.pow(1 - t, 2) * start.dx +
                2 * (1 - t) * t * control.dx +
                math.pow(t, 2) * end.dx;
            final dy = math.pow(1 - t, 2) * start.dy +
                2 * (1 - t) * t * control.dy +
                math.pow(t, 2) * end.dy;

            final tangentX = 2 * (1 - t) * (control.dx - start.dx) + 2 * t * (end.dx - control.dx);
            final tangentY = 2 * (1 - t) * (control.dy - start.dy) + 2 * t * (end.dy - control.dy);
            final headingAngle = math.atan2(tangentY, tangentX);

            final scaleFactor = (1.0 + math.sin(t * math.pi) * 0.4 - (t * 0.6)).clamp(0.3, 1.4);

            return Positioned(
              left: dx - 24,
              top: dy - 24,
              child: IgnorePointer(
                child: Opacity(
                  opacity: (1.0 - math.pow(t, 5)).clamp(0.0, 1.0),
                  child: Transform.rotate(
                    angle: headingAngle,
                    child: Transform.scale(
                      scale: scaleFactor,
                      child: customFlyer ??
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: TravelTheme.coralGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: TravelTheme.accent.withValues(alpha: 0.6),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.flight_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);
    await controller.forward();
    entry.remove();
    controller.dispose();

    onArrival?.call();
  }

  // Fast Train glide animation with speed-lines
  static Future<void> flyTrain({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    Duration duration = const Duration(milliseconds: 750),
    VoidCallback? onArrival,
  }) async {
    await flyAirplane(
      context: context,
      sourceKey: sourceKey,
      targetKey: targetKey,
      duration: duration,
      customFlyer: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.6),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.train_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      onArrival: onArrival,
    );
  }

  // Adventure Experience ticket pass glide
  static Future<void> flyExperience({
    required BuildContext context,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    Duration duration = const Duration(milliseconds: 750),
    VoidCallback? onArrival,
  }) async {
    await flyAirplane(
      context: context,
      sourceKey: sourceKey,
      targetKey: targetKey,
      duration: duration,
      customFlyer: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.6),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.explore_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      onArrival: onArrival,
    );
  }
}
