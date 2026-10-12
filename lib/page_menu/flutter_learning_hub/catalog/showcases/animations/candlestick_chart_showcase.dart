import 'dart:math' as math;
import 'package:flutter/material.dart';

class CandlestickChartShowcase extends StatefulWidget {
  const CandlestickChartShowcase({super.key});

  @override
  State<CandlestickChartShowcase> createState() =>
      _CandlestickChartShowcaseState();
}

class _CandlestickChartShowcaseState extends State<CandlestickChartShowcase> {
  int _selectedTimeframeIndex = 1; // 1D
  int? _hoveredCandleIndex;

  final List<String> _timeframes = ['1H', '1D', '1W', '1M'];

  final List<_CandleData> _candles1D = [
    _CandleData(
      open: 63200,
      high: 63900,
      low: 62800,
      close: 63750,
      volume: 140,
      time: '09:00',
    ),
    _CandleData(
      open: 63750,
      high: 64200,
      low: 63400,
      close: 63500,
      volume: 110,
      time: '10:00',
    ),
    _CandleData(
      open: 63500,
      high: 64600,
      low: 63300,
      close: 64400,
      volume: 220,
      time: '11:00',
    ),
    _CandleData(
      open: 64400,
      high: 65100,
      low: 64100,
      close: 64950,
      volume: 310,
      time: '12:00',
    ),
    _CandleData(
      open: 64950,
      high: 65400,
      low: 64600,
      close: 65200,
      volume: 280,
      time: '13:00',
    ),
    _CandleData(
      open: 65200,
      high: 65350,
      low: 64300,
      close: 64500,
      volume: 190,
      time: '14:00',
    ),
    _CandleData(
      open: 64500,
      high: 64800,
      low: 63900,
      close: 64150,
      volume: 160,
      time: '15:00',
    ),
    _CandleData(
      open: 64150,
      high: 65500,
      low: 64000,
      close: 65300,
      volume: 350,
      time: '16:00',
    ),
    _CandleData(
      open: 65300,
      high: 66200,
      low: 65100,
      close: 66050,
      volume: 420,
      time: '17:00',
    ),
    _CandleData(
      open: 66050,
      high: 66400,
      low: 65700,
      close: 65900,
      volume: 210,
      time: '18:00',
    ),
    _CandleData(
      open: 65900,
      high: 66800,
      low: 65800,
      close: 66650,
      volume: 380,
      time: '19:00',
    ),
    _CandleData(
      open: 66650,
      high: 67200,
      low: 66400,
      close: 67100,
      volume: 450,
      time: '20:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final candles = _candles1D;
    final activeCandle =
        _hoveredCandleIndex != null
            ? candles[_hoveredCandleIndex!]
            : candles.last;

    final isBullish = activeCandle.close >= activeCandle.open;
    final priceChange = activeCandle.close - activeCandle.open;
    final percentChange = (priceChange / activeCandle.open) * 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. CANDLESTICK TRADING CARD ----------------
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: Asset Info & Live OHLC Price Ticker
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF59E0B,
                                ).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.currency_bitcoin_rounded,
                                color: Color(0xFFF59E0B),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'BTC / USDT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Timeframe chips
                        Row(
                          children: List.generate(_timeframes.length, (idx) {
                            final isSel = _selectedTimeframeIndex == idx;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap:
                                    () => setState(
                                      () => _selectedTimeframeIndex = idx,
                                    ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSel
                                            ? const Color(0xFF6366F1)
                                            : Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _timeframes[idx],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSel ? Colors.white : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Big Current Price & Change Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${activeCandle.close.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isBullish
                                    ? const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.2)
                                    : const Color(
                                      0xFFEF4444,
                                    ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${isBullish ? '+' : ''}${percentChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color:
                                  isBullish
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Waktu: ${activeCandle.time}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // OHLC Subtitle
                    Text(
                      'O: \$${activeCandle.open} • H: \$${activeCandle.high} • L: \$${activeCandle.low} • C: \$${activeCandle.close}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white54,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              // Interactive Candlestick Canvas
              SizedBox(
                height: 160,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final widthPerCandle =
                            constraints.maxWidth / candles.length;
                        final index = (details.localPosition.dx /
                                widthPerCandle)
                            .floor()
                            .clamp(0, candles.length - 1);
                        setState(() => _hoveredCandleIndex = index);
                      },
                      onTapDown: (details) {
                        final widthPerCandle =
                            constraints.maxWidth / candles.length;
                        final index = (details.localPosition.dx /
                                widthPerCandle)
                            .floor()
                            .clamp(0, candles.length - 1);
                        setState(() => _hoveredCandleIndex = index);
                      },
                      onHorizontalDragEnd: (_) {
                        setState(() => _hoveredCandleIndex = null);
                      },
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, 160),
                        painter: _CandlestickPainter(
                          candles: candles,
                          hoveredIndex: _hoveredCandleIndex,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SUMMARY & INSTRUCTIONS ----------------
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.touch_app_rounded, size: 16, color: Color(0xFF6366F1)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sentuh / geser jari pada grafik untuk memunculkan garis crosshair & data OHLC.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DATA CLASS & CUSTOM PAINTER FOR CANDLESTICK
// ---------------------------------------------------------------------------
class _CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final String time;

  _CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.time,
  });
}

class _CandlestickPainter extends CustomPainter {
  final List<_CandleData> candles;
  final int? hoveredIndex;

  _CandlestickPainter({required this.candles, required this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final double minPrice = candles.map((c) => c.low).reduce(math.min) - 200;
    final double maxPrice = candles.map((c) => c.high).reduce(math.max) + 200;
    final double maxVol = candles.map((c) => c.volume).reduce(math.max);

    final double chartHeight = size.height * 0.75;
    final double volumeHeight = size.height * 0.20;
    final double candleSlotWidth = size.width / candles.length;
    final double candleBodyWidth = candleSlotWidth * 0.65;

    // 1. Draw Dashed Horizontal Price Grid Lines
    final gridPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.08)
          ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw Candlesticks & Volume Bars
    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final isBull = c.close >= c.open;
      final color = isBull ? const Color(0xFF10B981) : const Color(0xFFEF4444);

      final centerX = (i * candleSlotWidth) + (candleSlotWidth / 2);

      double priceToY(double p) {
        return chartHeight -
            ((p - minPrice) / (maxPrice - minPrice)) * chartHeight;
      }

      final highY = priceToY(c.high);
      final lowY = priceToY(c.low);
      final openY = priceToY(c.open);
      final closeY = priceToY(c.close);

      final topBodyY = math.min(openY, closeY);
      final bodyH = (openY - closeY).abs().clamp(2.0, chartHeight);

      // Draw Wick (Upper and Lower thin line)
      final wickPaint =
          Paint()
            ..color = color
            ..strokeWidth = 1.2;
      canvas.drawLine(Offset(centerX, highY), Offset(centerX, lowY), wickPaint);

      // Draw Candle Body
      final bodyPaint =
          Paint()
            ..color = color
            ..style = PaintingStyle.fill;

      final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - (candleBodyWidth / 2),
          topBodyY,
          candleBodyWidth,
          bodyH,
        ),
        const Radius.circular(2),
      );
      canvas.drawRRect(bodyRect, bodyPaint);

      // Draw Volume Sub-Bar
      final volH = (c.volume / maxVol) * volumeHeight;
      final volRect = Rect.fromLTWH(
        centerX - (candleBodyWidth / 2),
        size.height - volH,
        candleBodyWidth,
        volH,
      );
      final volPaint =
          Paint()
            ..color = color.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill;
      canvas.drawRect(volRect, volPaint);
    }

    // 3. Draw Touch Crosshair when hovered
    if (hoveredIndex != null && hoveredIndex! < candles.length) {
      final hoveredX =
          (hoveredIndex! * candleSlotWidth) + (candleSlotWidth / 2);
      final crosshairPaint =
          Paint()
            ..color = const Color(0xFF6366F1).withValues(alpha: 0.8)
            ..strokeWidth = 1.2;

      // Vertical line
      canvas.drawLine(
        Offset(hoveredX, 0),
        Offset(hoveredX, size.height),
        crosshairPaint,
      );

      // Indicator dot on selected candle close
      final activeC = candles[hoveredIndex!];
      final double closeY =
          chartHeight -
          ((activeC.close - minPrice) / (maxPrice - minPrice)) * chartHeight;

      final dotPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(hoveredX, closeY), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) =>
      oldDelegate.hoveredIndex != hoveredIndex;
}
