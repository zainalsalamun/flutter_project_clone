import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppleWatchActivityRingsShowcase extends StatefulWidget {
  const AppleWatchActivityRingsShowcase({super.key});

  @override
  State<AppleWatchActivityRingsShowcase> createState() =>
      _AppleWatchActivityRingsShowcaseState();
}

class _AppleWatchActivityRingsShowcaseState
    extends State<AppleWatchActivityRingsShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  // Ring Values
  double _moveKcal = 420.0;
  final double _moveTarget = 500.0;

  double _exerciseMin = 22.0;
  final double _exerciseTarget = 30.0;

  double _standHours = 8.0;
  final double _standTarget = 12.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addMove(double val) {
    HapticFeedback.lightImpact();
    setState(() {
      _moveKcal = math.min(_moveKcal + val, 800.0);
    });
    _animController.forward(from: 0.0);
  }

  void _addExercise(double val) {
    HapticFeedback.lightImpact();
    setState(() {
      _exerciseMin = math.min(_exerciseMin + val, 60.0);
    });
    _animController.forward(from: 0.0);
  }

  void _addStand(double val) {
    HapticFeedback.lightImpact();
    setState(() {
      _standHours = math.min(_standHours + val, 16.0);
    });
    _animController.forward(from: 0.0);
  }

  void _closeAllRings() {
    HapticFeedback.heavyImpact();
    setState(() {
      _moveKcal = 560.0;
      _exerciseMin = 35.0;
      _standHours = 12.0;
    });
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final moveProgress = (_moveKcal / _moveTarget);
    final exerciseProgress = (_exerciseMin / _exerciseTarget);
    final standProgress = (_standHours / _standTarget);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ACTIVITY RINGS VIEWPORT (APPLE WATCH DIAL)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isDark ? const Color(0xFF000000) : const Color(0xFF0F172A),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ActivityRingsPainter(
                      moveProgress: moveProgress * _animation.value,
                      exerciseProgress: exerciseProgress * _animation.value,
                      standProgress: standProgress * _animation.value,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // RING STATS SUMMARY CARDS
          Row(
            children: [
              _buildStatCard(
                'GERAK',
                '${_moveKcal.toInt()} / ${_moveTarget.toInt()}',
                'KKAL',
                const Color(0xFFFA114F),
                Icons.arrow_forward_rounded,
                () => _addMove(50),
                isDark,
              ),
              const SizedBox(width: 8),
              _buildStatCard(
                'LATIHAN',
                '${_exerciseMin.toInt()} / ${_exerciseTarget.toInt()}',
                'MENIT',
                const Color(0xFFA1E703),
                Icons.double_arrow_rounded,
                () => _addExercise(10),
                isDark,
              ),
              const SizedBox(width: 8),
              _buildStatCard(
                'BERDIRI',
                '${_standHours.toInt()} / ${_standTarget.toInt()}',
                'JAM',
                const Color(0xFF00D1FF),
                Icons.arrow_upward_rounded,
                () => _addStand(1),
                isDark,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // QUICK CLOSE RINGS PRESET
          ElevatedButton.icon(
            onPressed: _closeAllRings,
            icon: const Icon(Icons.stars_rounded, size: 20),
            label: const Text(
              'Tutup Semua Cincin Hari Ini ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA114F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
    VoidCallback onAdd,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 16),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.2),
                    ),
                    child: Icon(Icons.add, color: color, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Apple Watch 3 Concentric Activity Rings
// -------------------------------------------------------------
class _ActivityRingsPainter extends CustomPainter {
  final double moveProgress;
  final double exerciseProgress;
  final double standProgress;

  _ActivityRingsPainter({
    required this.moveProgress,
    required this.exerciseProgress,
    required this.standProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 18.0;

    // 1. Outer Ring (Move - Merah)
    _drawRing(
      canvas,
      center,
      95,
      strokeWidth,
      moveProgress,
      const Color(0xFFFA114F),
      const Color(0xFF420516),
    );

    // 2. Middle Ring (Exercise - Hijau)
    _drawRing(
      canvas,
      center,
      72,
      strokeWidth,
      exerciseProgress,
      const Color(0xFFA1E703),
      const Color(0xFF293F00),
    );

    // 3. Inner Ring (Stand - Biru Cyan)
    _drawRing(
      canvas,
      center,
      49,
      strokeWidth,
      standProgress,
      const Color(0xFF00D1FF),
      const Color(0xFF003845),
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double progress,
    Color activeColor,
    Color trackColor,
  ) {
    // Background Dark Track
    final bgPaint =
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0.0) return;

    // Active Glowing Arc
    final sweepAngle = (progress * 2 * math.pi);
    final activePaint =
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      activePaint,
    );

    // Overlap drop-shadow tip if completed > 100%
    if (progress > 1.0) {
      final tipAngle = (-math.pi / 2) + sweepAngle;
      final tipCenter = Offset(
        center.dx + radius * math.cos(tipAngle),
        center.dy + radius * math.sin(tipAngle),
      );

      final shadowPaint =
          Paint()
            ..color = Colors.black.withValues(alpha: 0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(tipCenter, strokeWidth / 2, shadowPaint);

      final capPaint =
          Paint()
            ..color = activeColor
            ..style = PaintingStyle.fill;
      canvas.drawCircle(tipCenter, strokeWidth / 2, capPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) =>
      oldDelegate.moveProgress != moveProgress ||
      oldDelegate.exerciseProgress != exerciseProgress ||
      oldDelegate.standProgress != standProgress;
}
