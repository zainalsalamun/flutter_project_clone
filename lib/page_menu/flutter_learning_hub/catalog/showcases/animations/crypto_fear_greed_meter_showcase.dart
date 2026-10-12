import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptoFearGreedMeterShowcase extends StatefulWidget {
  const CryptoFearGreedMeterShowcase({super.key});

  @override
  State<CryptoFearGreedMeterShowcase> createState() =>
      _CryptoFearGreedMeterShowcaseState();
}

enum _SentimentTier {
  extremeFear,
  fear,
  neutral,
  greed,
  extremeGreed;

  String get label {
    switch (this) {
      case _SentimentTier.extremeFear:
        return 'EXTREME FEAR';
      case _SentimentTier.fear:
        return 'FEAR';
      case _SentimentTier.neutral:
        return 'NEUTRAL';
      case _SentimentTier.greed:
        return 'GREED';
      case _SentimentTier.extremeGreed:
        return 'EXTREME GREED';
    }
  }

  Color get color {
    switch (this) {
      case _SentimentTier.extremeFear:
        return const Color(0xFFDC2626); // Crimson Red
      case _SentimentTier.fear:
        return const Color(0xFFF97316); // Orange Amber
      case _SentimentTier.neutral:
        return const Color(0xFFEAB308); // Yellow Gold
      case _SentimentTier.greed:
        return const Color(0xFF84CC16); // Lime Green
      case _SentimentTier.extremeGreed:
        return const Color(0xFF10B981); // Emerald Green
    }
  }

  String get description {
    switch (this) {
      case _SentimentTier.extremeFear:
        return 'Investor terlalu cemas. Sering kali merupakan sinyal peluang beli potensial (Buying Opportunity).';
      case _SentimentTier.fear:
        return 'Sentimen pasar berada di area kekhawatiran. Likuiditas cenderung berhati-hati.';
      case _SentimentTier.neutral:
        return 'Pasar berada dalam fase konsolidasi seimbang antara aksi beli dan jual.';
      case _SentimentTier.greed:
        return 'Investor mulai optimis dan melakukan akumulasi aset agresif.';
      case _SentimentTier.extremeGreed:
        return 'Pasar sudah terlalu panas (Overheated). Waspada potensi koreksi harga jangka pendek.';
    }
  }
}

class _CryptoFearGreedMeterShowcaseState
    extends State<CryptoFearGreedMeterShowcase>
    with SingleTickerProviderStateMixin {
  double _currentScore = 74.0; // Current Live Score
  late AnimationController _needleController;
  late Animation<double> _needleAnimation;
  double _previousScore = 50.0;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _needleAnimation = Tween<double>(begin: 50.0, end: _currentScore).animate(
      CurvedAnimation(parent: _needleController, curve: Curves.easeOutBack),
    );

    _needleController.forward();
  }

  @override
  void dispose() {
    _needleController.dispose();
    super.dispose();
  }

  void _updateScore(double newScore) {
    HapticFeedback.selectionClick();
    _previousScore = _needleAnimation.value;
    _currentScore = newScore;

    _needleAnimation = Tween<double>(
      begin: _previousScore,
      end: _currentScore,
    ).animate(
      CurvedAnimation(parent: _needleController, curve: Curves.easeOutBack),
    );

    _needleController.forward(from: 0.0);
    setState(() {});
  }

  _SentimentTier _getTier(double score) {
    if (score < 25) return _SentimentTier.extremeFear;
    if (score < 45) return _SentimentTier.fear;
    if (score <= 55) return _SentimentTier.neutral;
    if (score <= 75) return _SentimentTier.greed;
    return _SentimentTier.extremeGreed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeTier = _getTier(_currentScore);

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HEADER INFO BANNER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [Colors.white, const Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(18),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: activeTier.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.speed_rounded,
                    color: activeTier.color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crypto Fear & Greed Index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Indeks sentimen agregat pasar Bitcoin & Altcoin real-time.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: activeTier.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: activeTier.color, width: 1.2),
                  ),
                  child: Text(
                    activeTier.label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: activeTier.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. MAIN RADIAL GAUGE CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: activeTier.color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: activeTier.color.withValues(
                    alpha: isDark ? 0.15 : 0.08,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Radial Arc Canvas
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _needleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _FearGreedDialPainter(
                          score: _needleAnimation.value,
                          tierColor: activeTier.color,
                          isDark: isDark,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Sentiment Status & Description
                Text(
                  activeTier.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: activeTier.color,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    activeTier.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.35,
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Interactive Score Simulator Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Simulator Skor Sentimen:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${_currentScore.toInt()} / 100',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: activeTier.color,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: activeTier.color,
                    inactiveTrackColor:
                        isDark ? Colors.white12 : Colors.black12,
                    thumbColor: activeTier.color,
                    overlayColor: activeTier.color.withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _currentScore,
                    min: 0,
                    max: 100,
                    onChanged: (val) => _updateScore(val),
                  ),
                ),

                // Quick Preset Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildPresetChip(
                      15,
                      'Extreme Fear (15)',
                      const Color(0xFFDC2626),
                    ),
                    _buildPresetChip(35, 'Fear (35)', const Color(0xFFF97316)),
                    _buildPresetChip(
                      50,
                      'Neutral (50)',
                      const Color(0xFFEAB308),
                    ),
                    _buildPresetChip(74, 'Greed (74)', const Color(0xFF84CC16)),
                    _buildPresetChip(
                      90,
                      'Extreme Greed (90)',
                      const Color(0xFF10B981),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. HISTORICAL HORIZON TIMELINE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historical Horizon Sentimen',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHistoryCard(
                      'Kemarin',
                      '70',
                      'Greed',
                      const Color(0xFF84CC16),
                      isDark,
                    ),
                    _buildHistoryCard(
                      '7 Hari Lalu',
                      '62',
                      'Greed',
                      const Color(0xFF84CC16),
                      isDark,
                    ),
                    _buildHistoryCard(
                      '30 Hari Lalu',
                      '24',
                      'Ex-Fear',
                      const Color(0xFFDC2626),
                      isDark,
                    ),
                    _buildHistoryCard(
                      'Rata-rata 1Y',
                      '53',
                      'Neutral',
                      const Color(0xFFEAB308),
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 4. DECOMPOSED MARKET DRIVER BARS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Faktor Pembentuk Indeks (Weights)',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildDriverBar(
                  'Volatilitas Pasar (30D vs 90D)',
                  0.85,
                  '25%',
                  const Color(0xFFEF4444),
                  isDark,
                ),
                _buildDriverBar(
                  'Volume & Momentum Pasar',
                  0.72,
                  '25%',
                  const Color(0xFF10B981),
                  isDark,
                ),
                _buildDriverBar(
                  'Social Media Sentiment (X/Reddit)',
                  0.64,
                  '15%',
                  const Color(0xFF38BDF8),
                  isDark,
                ),
                _buildDriverBar(
                  'Dominasi Pangsa Pasar Bitcoin',
                  0.54,
                  '10%',
                  const Color(0xFFF59E0B),
                  isDark,
                ),
                _buildDriverBar(
                  'Google Search Trends Keyword',
                  0.40,
                  '10%',
                  const Color(0xFF8B5CF6),
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(double score, String label, Color color) {
    final isSelected = (_currentScore.toInt() == score.toInt());
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor:
          isSelected ? color.withValues(alpha: 0.25) : Colors.transparent,
      side: BorderSide(
        color: isSelected ? color : Colors.grey.withValues(alpha: 0.4),
      ),
      onPressed: () => _updateScore(score),
    );
  }

  Widget _buildHistoryCard(
    String period,
    String score,
    String tag,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              period,
              style: const TextStyle(fontSize: 9.5, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              score,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tag,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverBar(
    String title,
    double progress,
    String weight,
    Color barColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Bobot: $weight',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: isDark ? Colors.white12 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Semicircular 180-degree Fear & Greed Radial Gauge
// -------------------------------------------------------------
class _FearGreedDialPainter extends CustomPainter {
  final double score; // 0 to 100
  final Color tierColor;
  final bool isDark;

  _FearGreedDialPainter({
    required this.score,
    required this.tierColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width * 0.40;
    const strokeW = 18.0;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw 5-Zone Background Segments
    final segmentColors = [
      const Color(0xFFDC2626), // 0-20
      const Color(0xFFF97316), // 20-40
      const Color(0xFFEAB308), // 40-60
      const Color(0xFF84CC16), // 60-80
      const Color(0xFF10B981), // 80-100
    ];

    const double sweepAnglePerSeg = math.pi / 5;
    for (int i = 0; i < 5; i++) {
      final startAngle = math.pi + (i * sweepAnglePerSeg);
      final segPaint =
          Paint()
            ..color = segmentColors[i].withValues(alpha: 0.35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeW
            ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        arcRect,
        startAngle,
        sweepAnglePerSeg - 0.04,
        false,
        segPaint,
      );
    }

    // 2. Active Progress Track Glow
    final activeAngle = math.pi * (score / 100.0);
    final activePaint =
        Paint()
          ..color = tierColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW + 2
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawArc(arcRect, math.pi, activeAngle, false, activePaint);

    final activeSolidPaint =
        Paint()
          ..color = tierColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, math.pi, activeAngle, false, activeSolidPaint);

    // 3. Draw Needle
    final needleAngle = math.pi + (math.pi * (score / 100.0));
    final needleLength = radius - 6;

    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint =
        Paint()
          ..color = isDark ? Colors.white : const Color(0xFF0F172A)
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center Hub Pivot Pin
    canvas.drawCircle(center, 12, Paint()..color = tierColor);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);

    // Draw Score in Center
    final textPainter = TextPainter(
      text: TextSpan(
        text: score.toInt().toString(),
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w900,
          color: tierColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - (textPainter.width / 2), center.dy - radius * 0.65),
    );
  }

  @override
  bool shouldRepaint(covariant _FearGreedDialPainter oldDelegate) => true;
}
