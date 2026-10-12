import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ChartStyleMode { candles, lineChart, areaGlow }

class _CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const _CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;
  double get changePct => ((close - open) / open) * 100.0;
}

class ProCandlestickChartShowcase extends StatefulWidget {
  const ProCandlestickChartShowcase({super.key});

  @override
  State<ProCandlestickChartShowcase> createState() =>
      _ProCandlestickChartShowcaseState();
}

class _ProCandlestickChartShowcaseState
    extends State<ProCandlestickChartShowcase> {
  String _timeframe = '1H';
  ChartStyleMode _styleMode = ChartStyleMode.candles;
  bool _showMA20 = true;
  bool _showMA50 = true;
  bool _showVolume = true;

  int? _selectedIndex;
  bool _isInspecting = false;

  late List<_CandleData> _candles;
  late List<double?> _ma20Values;
  late List<double?> _ma50Values;

  @override
  void initState() {
    super.initState();
    _generateMarketData();
  }

  void _generateMarketData() {
    final List<_CandleData> data = [];
    final random = math.Random(108);
    double currentPrice = 3450.0; // ETH start price
    final now = DateTime.now();

    for (int i = 40; i >= 0; i--) {
      final time = now.subtract(Duration(hours: i));
      final volatility = currentPrice * 0.018;
      final change = (random.nextDouble() - 0.48) * volatility;
      final open = currentPrice;
      final close = open + change;
      final high =
          math.max(open, close) + random.nextDouble() * (volatility * 0.6);
      final low =
          math.min(open, close) - random.nextDouble() * (volatility * 0.6);
      final volume = 45.0 + random.nextDouble() * 280.0;

      data.add(
        _CandleData(
          time: time,
          open: open,
          high: high,
          low: low,
          close: close,
          volume: volume,
        ),
      );

      currentPrice = close;
    }

    _candles = data;
    _calculateMovingAverages();
  }

  void _calculateMovingAverages() {
    _ma20Values = [];
    _ma50Values = [];

    // Calculate MA 20
    for (int i = 0; i < _candles.length; i++) {
      if (i < 10) {
        _ma20Values.add(null);
      } else {
        double sum = 0;
        final start = math.max(0, i - 10 + 1);
        final count = i - start + 1;
        for (int k = start; k <= i; k++) {
          sum += _candles[k].close;
        }
        _ma20Values.add(sum / count);
      }
    }

    // Calculate MA 50
    for (int i = 0; i < _candles.length; i++) {
      if (i < 20) {
        _ma50Values.add(null);
      } else {
        double sum = 0;
        final start = math.max(0, i - 20 + 1);
        final count = i - start + 1;
        for (int k = start; k <= i; k++) {
          sum += _candles[k].close;
        }
        _ma50Values.add(sum / count);
      }
    }
  }

  void _onPanUpdate(Offset localPos, double chartWidth) {
    if (_candles.isEmpty) return;
    final candleWidth = chartWidth / _candles.length;
    final index = (localPos.dx / candleWidth).floor().clamp(
      0,
      _candles.length - 1,
    );

    if (_selectedIndex != index) {
      HapticFeedback.selectionClick();
      setState(() {
        _isInspecting = true;
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeCandle =
        (_isInspecting && _selectedIndex != null)
            ? _candles[_selectedIndex!]
            : _candles.last;

    final isBullish = activeCandle.isBullish;
    final trendColor =
        isBullish ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. INSTRUMENT & TICKER HEADER
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6366F1,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.currency_exchange_rounded,
                              color: Color(0xFF6366F1),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ETH / USDT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Ethereum Spot Index',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${activeCandle.close.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: trendColor,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isBullish
                                  ? Icons.arrow_drop_up_rounded
                                  : Icons.arrow_drop_down_rounded,
                              color: trendColor,
                              size: 18,
                            ),
                            Text(
                              '${activeCandle.changePct >= 0 ? '+' : ''}${activeCandle.changePct.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: trendColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // OHLCV Quick Stats Ribbon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOhlcStat(
                      'O',
                      activeCandle.open.toStringAsFixed(1),
                      isDark,
                    ),
                    _buildOhlcStat(
                      'H',
                      activeCandle.high.toStringAsFixed(1),
                      isDark,
                    ),
                    _buildOhlcStat(
                      'L',
                      activeCandle.low.toStringAsFixed(1),
                      isDark,
                    ),
                    _buildOhlcStat(
                      'C',
                      activeCandle.close.toStringAsFixed(1),
                      isDark,
                    ),
                    _buildOhlcStat(
                      'Vol',
                      '${activeCandle.volume.toInt()}k',
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. TIMEFRAME & INDICATOR CONTROLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Timeframe Chips
                ...['15M', '1H', '4H', '1D'].map((tf) {
                  final isSelected = _timeframe == tf;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(tf, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      onSelected: (val) {
                        if (val) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _timeframe = tf;
                            _generateMarketData();
                          });
                        }
                      },
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // Indicator Toggles
                FilterChip(
                  label: const Text(
                    'MA(20)',
                    style: TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
                  ),
                  selected: _showMA20,
                  onSelected: (val) => setState(() => _showMA20 = val),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text(
                    'MA(50)',
                    style: TextStyle(fontSize: 11, color: Color(0xFFF59E0B)),
                  ),
                  selected: _showMA50,
                  onSelected: (val) => setState(() => _showMA50 = val),
                ),
                const SizedBox(width: 6),
                FilterChip(
                  label: const Text('VOL', style: TextStyle(fontSize: 11)),
                  selected: _showVolume,
                  onSelected: (val) => setState(() => _showVolume = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. CANDLESTICK CHART CANVAS CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : Colors.white,
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
                // Top Indicator Legend
                Row(
                  children: [
                    if (_showMA20) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF38BDF8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'MA20: \$${_ma20Values[(_selectedIndex ?? _candles.length - 1)]?.toStringAsFixed(1) ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (_showMA50) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'MA50: \$${_ma50Values[(_selectedIndex ?? _candles.length - 1)]?.toStringAsFixed(1) ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const Spacer(),
                    // Chart Style Pop Menu
                    PopupMenuButton<ChartStyleMode>(
                      initialValue: _styleMode,
                      icon: Icon(
                        _styleMode == ChartStyleMode.candles
                            ? Icons.bar_chart_rounded
                            : _styleMode == ChartStyleMode.lineChart
                            ? Icons.show_chart_rounded
                            : Icons.area_chart_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onSelected: (mode) => setState(() => _styleMode = mode),
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: ChartStyleMode.candles,
                              child: Text('Candlesticks'),
                            ),
                            const PopupMenuItem(
                              value: ChartStyleMode.lineChart,
                              child: Text('Line Chart'),
                            ),
                            const PopupMenuItem(
                              value: ChartStyleMode.areaGlow,
                              child: Text('Area Glow'),
                            ),
                          ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Interactive Chart Canvas
                LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidth = constraints.maxWidth;
                    return GestureDetector(
                      onPanDown:
                          (d) => _onPanUpdate(d.localPosition, chartWidth),
                      onPanUpdate:
                          (d) => _onPanUpdate(d.localPosition, chartWidth),
                      onPanEnd: (_) => setState(() => _isInspecting = false),
                      onTapDown:
                          (d) => _onPanUpdate(d.localPosition, chartWidth),
                      child: SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _CandlestickPainter(
                            candles: _candles,
                            ma20: _showMA20 ? _ma20Values : null,
                            ma50: _showMA50 ? _ma50Values : null,
                            selectedIndex:
                                _isInspecting ? _selectedIndex : null,
                            styleMode: _styleMode,
                            showVolume: _showVolume,
                            isDark: isDark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOhlcStat(String label, String val, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Professional High-Performance Candlestick Engine
// -------------------------------------------------------------
class _CandlestickPainter extends CustomPainter {
  final List<_CandleData> candles;
  final List<double?>? ma20;
  final List<double?>? ma50;
  final int? selectedIndex;
  final ChartStyleMode styleMode;
  final bool showVolume;
  final bool isDark;

  _CandlestickPainter({
    required this.candles,
    required this.ma20,
    required this.ma50,
    required this.selectedIndex,
    required this.styleMode,
    required this.showVolume,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final volumeHeight = showVolume ? size.height * 0.22 : 0.0;
    final priceHeight = size.height - volumeHeight - 16;
    final w = size.width;
    final candleWidth = w / candles.length;

    // Find Price Min & Max
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    double maxVolume = 0.0;

    for (final c in candles) {
      if (c.low < minPrice) minPrice = c.low;
      if (c.high > maxPrice) maxPrice = c.high;
      if (c.volume > maxVolume) maxVolume = c.volume;
    }

    final priceRange = (maxPrice - minPrice).clamp(1.0, 999999.0);

    // 1. Draw Grid Lines
    final gridPaint =
        Paint()
          ..color = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          )
          ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = priceHeight * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // 2. Draw Volume Sub-chart Bars
    if (showVolume && maxVolume > 0) {
      final volumeBaseY = size.height;
      for (int i = 0; i < candles.length; i++) {
        final c = candles[i];
        final x = (i * candleWidth) + (candleWidth * 0.15);
        final barW = candleWidth * 0.7;
        final barH = (c.volume / maxVolume) * (volumeHeight - 8);
        final color =
            c.isBullish
                ? const Color(0xFF10B981).withValues(alpha: 0.35)
                : const Color(0xFFEF4444).withValues(alpha: 0.35);

        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, volumeBaseY - barH, barW, barH),
          const Radius.circular(2),
        );
        canvas.drawRRect(rrect, Paint()..color = color);
      }
    }

    // 3. Draw Candlesticks or Line Chart
    if (styleMode == ChartStyleMode.candles) {
      for (int i = 0; i < candles.length; i++) {
        final c = candles[i];
        final centerX = (i * candleWidth) + (candleWidth / 2);
        final color =
            c.isBullish ? const Color(0xFF10B981) : const Color(0xFFEF4444);

        final highY =
            priceHeight - ((c.high - minPrice) / priceRange) * priceHeight;
        final lowY =
            priceHeight - ((c.low - minPrice) / priceRange) * priceHeight;
        final openY =
            priceHeight - ((c.open - minPrice) / priceRange) * priceHeight;
        final closeY =
            priceHeight - ((c.close - minPrice) / priceRange) * priceHeight;

        // Draw Wick
        final wickPaint =
            Paint()
              ..color = color
              ..strokeWidth = 1.5;
        canvas.drawLine(
          Offset(centerX, highY),
          Offset(centerX, lowY),
          wickPaint,
        );

        // Draw Candle Body
        final bodyTop = math.min(openY, closeY);
        final bodyHeight = math.max((openY - closeY).abs(), 2.0);
        final bodyWidth = candleWidth * 0.65;

        final bodyRRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, bodyTop + (bodyHeight / 2)),
            width: bodyWidth,
            height: bodyHeight,
          ),
          const Radius.circular(2.5),
        );

        canvas.drawRRect(bodyRRect, Paint()..color = color);
      }
    } else {
      // Line or Area Chart
      final linePath = Path();
      final areaPath = Path();

      for (int i = 0; i < candles.length; i++) {
        final c = candles[i];
        final x = (i * candleWidth) + (candleWidth / 2);
        final y =
            priceHeight - ((c.close - minPrice) / priceRange) * priceHeight;

        if (i == 0) {
          linePath.moveTo(x, y);
          areaPath.moveTo(x, priceHeight);
          areaPath.lineTo(x, y);
        } else {
          linePath.lineTo(x, y);
          areaPath.lineTo(x, y);
        }
      }

      areaPath.lineTo(w, priceHeight);
      areaPath.close();

      if (styleMode == ChartStyleMode.areaGlow) {
        final fillPaint =
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.4),
                  const Color(0xFF6366F1).withValues(alpha: 0.0),
                ],
              ).createShader(Rect.fromLTWH(0, 0, w, priceHeight));
        canvas.drawPath(areaPath, fillPaint);
      }

      final linePaint =
          Paint()
            ..color = const Color(0xFF6366F1)
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke;
      canvas.drawPath(linePath, linePaint);
    }

    // 4. Draw Moving Averages (MA20 & MA50)
    _drawMovingAverage(
      canvas,
      ma20,
      const Color(0xFF38BDF8),
      candleWidth,
      priceHeight,
      minPrice,
      priceRange,
    );
    _drawMovingAverage(
      canvas,
      ma50,
      const Color(0xFFF59E0B),
      candleWidth,
      priceHeight,
      minPrice,
      priceRange,
    );

    // 5. Crosshair Line on Inspection
    if (selectedIndex != null && selectedIndex! < candles.length) {
      final sc = candles[selectedIndex!];
      final cx = (selectedIndex! * candleWidth) + (candleWidth / 2);
      final cy =
          priceHeight - ((sc.close - minPrice) / priceRange) * priceHeight;

      final crosshairPaint =
          Paint()
            ..color = const Color(0xFF94A3B8)
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;

      // Vertical line
      canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), crosshairPaint);
      // Horizontal line
      canvas.drawLine(Offset(0, cy), Offset(w, cy), crosshairPaint);

      // Intersection Dot
      canvas.drawCircle(
        Offset(cx, cy),
        5.0,
        Paint()..color = const Color(0xFF6366F1),
      );
      canvas.drawCircle(Offset(cx, cy), 3.0, Paint()..color = Colors.white);
    }
  }

  void _drawMovingAverage(
    Canvas canvas,
    List<double?>? ma,
    Color color,
    double candleWidth,
    double priceHeight,
    double minPrice,
    double priceRange,
  ) {
    if (ma == null) return;
    final path = Path();
    bool isStarted = false;

    for (int i = 0; i < ma.length; i++) {
      final val = ma[i];
      if (val == null) continue;

      final x = (i * candleWidth) + (candleWidth / 2);
      final y = priceHeight - ((val - minPrice) / priceRange) * priceHeight;

      if (!isStarted) {
        path.moveTo(x, y);
        isStarted = true;
      } else {
        path.lineTo(x, y);
      }
    }

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.6
          ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) => true;
}
