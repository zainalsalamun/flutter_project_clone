import 'package:flutter/material.dart';

class MiniSparklineChartShowcase extends StatefulWidget {
  const MiniSparklineChartShowcase({super.key});

  @override
  State<MiniSparklineChartShowcase> createState() =>
      _MiniSparklineChartShowcaseState();
}

class _MiniSparklineChartShowcaseState
    extends State<MiniSparklineChartShowcase> {
  final List<double> _cryptoData = [
    42.0,
    43.5,
    41.2,
    45.0,
    48.2,
    46.8,
    52.4,
    50.1,
    55.8,
    58.2,
    62.0,
  ];

  final List<double> _salesData = [
    85.0,
    82.1,
    79.4,
    75.0,
    78.2,
    72.5,
    68.0,
    65.4,
    62.0,
    59.5,
    54.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Positive Trend Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitcoin (BTC/USD)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$64,820.50',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_drop_up_rounded,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        Text(
                          '+14.8%',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: MiniSparklineChart(
                  data: _cryptoData,
                  lineColor: const Color(0xFF10B981),
                  gradientColor: const Color(
                    0xFF10B981,
                  ).withValues(alpha: 0.25),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Downward Trend Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Server Response Latency',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '54 ms (Faster)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                        Text(
                          '-31.2 ms',
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: MiniSparklineChart(
                  data: _salesData,
                  lineColor: const Color(0xFF6366F1),
                  gradientColor: const Color(
                    0xFF6366F1,
                  ).withValues(alpha: 0.25),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MiniSparklineChart extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final Color gradientColor;
  final double strokeWidth;

  const MiniSparklineChart({
    super.key,
    required this.data,
    required this.lineColor,
    required this.gradientColor,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(
        data: data,
        lineColor: lineColor,
        gradientColor: gradientColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color gradientColor;
  final double strokeWidth;

  _SparklinePainter({
    required this.data,
    required this.lineColor,
    required this.gradientColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final points = <Offset>[];
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      // Invert Y so higher value is at the top
      final normalizedY = (data[i] - minVal) / range;
      final y = size.height - (normalizedY * (size.height - 12)) - 6;
      points.add(Offset(x, y));
    }

    // Build smooth cubic bezier path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Gradient fill below line
    final fillPath =
        Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientColor, gradientColor.withValues(alpha: 0.0)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final linePaint =
        Paint()
          ..color = lineColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    // End point indicator dot
    final lastPoint = points.last;
    final dotOuterPaint =
        Paint()
          ..color = lineColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
    final dotInnerPaint =
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(lastPoint, 6, dotOuterPaint);
    canvas.drawCircle(lastPoint, 3.5, dotInnerPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}
