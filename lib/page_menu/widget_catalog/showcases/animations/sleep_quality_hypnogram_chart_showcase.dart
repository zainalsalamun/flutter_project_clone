import 'package:flutter/material.dart';

class SleepQualityHypnogramChartShowcase extends StatefulWidget {
  const SleepQualityHypnogramChartShowcase({super.key});

  @override
  State<SleepQualityHypnogramChartShowcase> createState() =>
      _SleepQualityHypnogramChartShowcaseState();
}

enum _SleepStage { awake, rem, light, deep }

class _SleepDataPoint {
  final double timeFraction; // 0.0 to 1.0 (22:30 to 06:45)
  final _SleepStage stage;
  final String timeLabel;

  _SleepDataPoint({
    required this.timeFraction,
    required this.stage,
    required this.timeLabel,
  });
}

class _SleepQualityHypnogramChartShowcaseState
    extends State<SleepQualityHypnogramChartShowcase> {
  final List<_SleepDataPoint> _hypnogramPoints = [
    _SleepDataPoint(
      timeFraction: 0.00,
      stage: _SleepStage.awake,
      timeLabel: '22:30',
    ),
    _SleepDataPoint(
      timeFraction: 0.05,
      stage: _SleepStage.light,
      timeLabel: '22:50',
    ),
    _SleepDataPoint(
      timeFraction: 0.15,
      stage: _SleepStage.deep,
      timeLabel: '23:30',
    ),
    _SleepDataPoint(
      timeFraction: 0.28,
      stage: _SleepStage.light,
      timeLabel: '00:30',
    ),
    _SleepDataPoint(
      timeFraction: 0.35,
      stage: _SleepStage.rem,
      timeLabel: '01:05',
    ),
    _SleepDataPoint(
      timeFraction: 0.45,
      stage: _SleepStage.light,
      timeLabel: '01:50',
    ),
    _SleepDataPoint(
      timeFraction: 0.55,
      stage: _SleepStage.deep,
      timeLabel: '02:40',
    ),
    _SleepDataPoint(
      timeFraction: 0.68,
      stage: _SleepStage.light,
      timeLabel: '03:45',
    ),
    _SleepDataPoint(
      timeFraction: 0.75,
      stage: _SleepStage.rem,
      timeLabel: '04:20',
    ),
    _SleepDataPoint(
      timeFraction: 0.85,
      stage: _SleepStage.light,
      timeLabel: '05:10',
    ),
    _SleepDataPoint(
      timeFraction: 0.92,
      stage: _SleepStage.rem,
      timeLabel: '05:45',
    ),
    _SleepDataPoint(
      timeFraction: 0.96,
      stage: _SleepStage.light,
      timeLabel: '06:15',
    ),
    _SleepDataPoint(
      timeFraction: 1.00,
      stage: _SleepStage.awake,
      timeLabel: '06:45',
    ),
  ];

  double? _scrubFraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SLEEP SCORE & STATS HEADER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skor Kualitas Tidur',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Text(
                          '88',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Optimal',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Durasi',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '8j 15m',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // HYPNOGRAM STEP WAVE CHART CANVAS (WITH GESTURE SCRUBBER)
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localPos = details.localPosition.dx;
                setState(() {
                  _scrubFraction = (localPos / box.size.width).clamp(0.0, 1.0);
                });
              }
            },
            onHorizontalDragEnd: (_) => setState(() => _scrubFraction = null),
            child: Container(
              width: double.infinity,
              height: 210,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _HypnogramChartPainter(
                        points: _hypnogramPoints,
                        scrubFraction: _scrubFraction,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Time axis labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '22:30',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '01:00',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '03:30',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '06:00',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '06:45',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // SLEEP STAGES BREAKDOWN GRID
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              children: [
                _buildStageRow(
                  ' Deep Sleep (Nyenyak)',
                  '1j 30m (18%)',
                  const Color(0xFF4F46E5),
                  isDark,
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 14,
                ),
                _buildStageRow(
                  ' REM Sleep',
                  '2j 10m (26%)',
                  const Color(0xFFA855F7),
                  isDark,
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 14,
                ),
                _buildStageRow(
                  ' Light Sleep (Ringan)',
                  '4j 20m (52%)',
                  const Color(0xFF38BDF8),
                  isDark,
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 14,
                ),
                _buildStageRow(
                  ' Terjaga (Awake)',
                  '15m (4%)',
                  const Color(0xFFFB923C),
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageRow(
    String label,
    String duration,
    Color color,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          duration,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Hypnogram Step Waveform
// -------------------------------------------------------------
class _HypnogramChartPainter extends CustomPainter {
  final List<_SleepDataPoint> points;
  final double? scrubFraction;
  final bool isDark;

  _HypnogramChartPainter({
    required this.points,
    required this.scrubFraction,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Grid Guidelines for 4 Stages
    final stageLabels = ['Awake', 'REM', 'Light', 'Deep'];
    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.15 + (i * 0.25));

      final linePaint =
          Paint()
            ..color =
                isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)
            ..strokeWidth = 1.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: stageLabels[i],
          style: TextStyle(
            color: isDark ? Colors.white24 : Colors.black26,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(4, y - 12));
    }

    // 2. Build Step Wave Path
    final strokePath = Path();
    final fillPath = Path();

    fillPath.moveTo(0, size.height);

    for (int i = 0; i < points.length; i++) {
      final x = points[i].timeFraction * size.width;
      final y = _getYForStage(points[i].stage, size.height);

      if (i == 0) {
        strokePath.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        final prevY = _getYForStage(points[i - 1].stage, size.height);
        strokePath.lineTo(x, prevY);
        strokePath.lineTo(x, y);

        fillPath.lineTo(x, prevY);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // 3. Fill Gradient
    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF818CF8).withValues(alpha: 0.35),
              const Color(0xFF4F46E5).withValues(alpha: 0.05),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // 4. Stroke Step Line
    final strokePaint =
        Paint()
          ..color = const Color(0xFF818CF8)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    canvas.drawPath(strokePath, strokePaint);

    // 5. Interactive Scrubber Line & Dot
    if (scrubFraction != null) {
      final scrubX = scrubFraction! * size.width;

      final scrubLinePaint =
          Paint()
            ..color = const Color(0xFF38BDF8)
            ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(scrubX, 0),
        Offset(scrubX, size.height),
        scrubLinePaint,
      );

      canvas.drawCircle(
        Offset(scrubX, size.height / 2),
        4,
        Paint()..color = const Color(0xFF38BDF8),
      );
    }
  }

  double _getYForStage(_SleepStage stage, double height) {
    switch (stage) {
      case _SleepStage.awake:
        return height * 0.15;
      case _SleepStage.rem:
        return height * 0.40;
      case _SleepStage.light:
        return height * 0.65;
      case _SleepStage.deep:
        return height * 0.90;
    }
  }

  @override
  bool shouldRepaint(covariant _HypnogramChartPainter oldDelegate) =>
      oldDelegate.scrubFraction != scrubFraction ||
      oldDelegate.isDark != isDark;
}
