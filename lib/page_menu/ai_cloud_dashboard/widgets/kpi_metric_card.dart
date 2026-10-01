import 'package:flutter/material.dart';
import '../theme/ai_dashboard_theme.dart';

class KpiMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String changePercentage;
  final bool isPositive;
  final String subtext;
  final IconData icon;
  final Color accentColor;
  final List<double> sparklinePoints;

  const KpiMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.changePercentage,
    required this.isPositive,
    required this.subtext,
    required this.icon,
    required this.accentColor,
    required this.sparklinePoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: AiDashboardTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Title + Glowing Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AiDashboardTheme.textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: accentColor.withOpacity(0.3),
                    width: 0.8,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Middle Value + Sparkline Mini Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: AiDashboardTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isPositive
                                    ? AiDashboardTheme.success.withOpacity(0.15)
                                    : AiDashboardTheme.danger.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: 11,
                                color:
                                    isPositive
                                        ? AiDashboardTheme.success
                                        : AiDashboardTheme.danger,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                changePercentage,
                                style: TextStyle(
                                  color:
                                      isPositive
                                          ? AiDashboardTheme.success
                                          : AiDashboardTheme.danger,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            subtext,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AiDashboardTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Sparkline visual
              SizedBox(
                width: 50,
                height: 26,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    points: sparklinePoints,
                    lineColor: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;

  _SparklinePainter({required this.points, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    final path = Path();
    final fillPath = Path();

    final double minVal = points.reduce(
      (curr, next) => curr < next ? curr : next,
    );
    final double maxVal = points.reduce(
      (curr, next) => curr > next ? curr : next,
    );
    final double range = maxVal == minVal ? 1.0 : maxVal - minVal;

    final double stepX = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double normalized = (points[i] - minVal) / range;
      final double y = size.height - (normalized * (size.height - 4)) - 2;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == points.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [lineColor.withOpacity(0.35), lineColor.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => false;
}
