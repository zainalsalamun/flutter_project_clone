import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmmLiquidityPoolCurveShowcase extends StatefulWidget {
  const AmmLiquidityPoolCurveShowcase({super.key});

  @override
  State<AmmLiquidityPoolCurveShowcase> createState() =>
      _AmmLiquidityPoolCurveShowcaseState();
}

class _AmmLiquidityPoolCurveShowcaseState
    extends State<AmmLiquidityPoolCurveShowcase> {
  // Pool Invariant Constant: x * y = k
  // Initial Reserves: 100 ETH & 350,000 USDC
  final double _initialX = 100.0; // ETH
  final double _initialY = 350000.0; // USDC
  double get _k => _initialX * _initialY; // 35,000,000

  double _inputDeltaX = 5.0; // User swaps 5 ETH for USDC

  double get _spotPrice => _initialY / _initialX; // 3,500 USDC per ETH

  // Swap calculations
  double get _newX => _initialX + _inputDeltaX;
  double get _newY => _k / _newX;
  double get _outputDeltaY => _initialY - _newY;
  double get _effectivePrice => _outputDeltaY / _inputDeltaX;
  double get _priceImpactPct =>
      ((_spotPrice - _effectivePrice) / _spotPrice) * 100.0;

  String _formatNumber(double val, {int decimals = 2}) {
    return val
        .toStringAsFixed(decimals)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Color get _priceImpactColor {
    if (_priceImpactPct < 1.0) return const Color(0xFF10B981); // Green
    if (_priceImpactPct < 3.5) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red
  }

  String get _priceImpactLabel {
    if (_priceImpactPct < 1.0) return 'Minimal (<1%)';
    if (_priceImpactPct < 3.5) return 'Moderat (1-3%)';
    return 'High Slippage (>3%)';
  }

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
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bubble_chart_rounded,
                    color: Color(0xFF6366F1),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AMM Liquidity Pool Curve (x · y = k)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Visualisasi kurva hiperbola Uniswap & kalkulator slippage.',
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
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Uniswap V2',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. HYPERBOLIC CURVE CANVAS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.timeline_rounded,
                      size: 16,
                      color: Color(0xFF38BDF8),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Curve: x · y = k',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'k = ${_formatNumber(_k, decimals: 0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Interactive CustomPainter Hyperbola Graph
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _AmmCurvePainter(
                      initialX: _initialX,
                      initialY: _initialY,
                      newX: _newX,
                      newY: _newY,
                      k: _k,
                      isDark: isDark,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Graph Axis Labels
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '↑ Token B (USDC)',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF2775CA),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Token A (ETH) →',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. SWAP SIMULATOR INPUT & SLIDER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Swap Token A (ETH):',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_inputDeltaX.toStringAsFixed(1)} ETH',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF6366F1),
                    thumbColor: const Color(0xFF6366F1),
                    overlayColor: const Color(
                      0xFF6366F1,
                    ).withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _inputDeltaX,
                    min: 0.5,
                    max: 40.0,
                    divisions: 79,
                    onChanged: (val) {
                      setState(() => _inputDeltaX = val);
                    },
                  ),
                ),

                // Quick Swap Presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      [1.0, 5.0, 10.0, 25.0].map((amt) {
                        final isSel = (_inputDeltaX.toInt() == amt.toInt());
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _inputDeltaX = amt);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSel
                                      ? const Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.2)
                                      : (isDark
                                          ? Colors.white10
                                          : Colors.black.withValues(
                                            alpha: 0.05,
                                          )),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSel
                                        ? const Color(0xFF6366F1)
                                        : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              '${amt.toInt()} ETH',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isSel ? FontWeight.bold : FontWeight.normal,
                                color:
                                    isSel
                                        ? const Color(0xFF6366F1)
                                        : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 4. SLIPPAGE & EXECUTION SUMMARY CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFF8FAFC), Colors.white],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _priceImpactColor.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Estimasi Output Diterima',
                  '${_formatNumber(_outputDeltaY)} USDC',
                  isHighlight: true,
                  highlightColor: const Color(0xFF10B981),
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Harga Spot Pool Awal',
                  '\$${_formatNumber(_spotPrice)} / ETH',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Harga Eksekusi Efektif',
                  '\$${_formatNumber(_effectivePrice)} / ETH',
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Price Impact (Slippage):',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _priceImpactColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _priceImpactColor),
                      ),
                      child: Text(
                        '${_priceImpactPct.toStringAsFixed(2)}% ($_priceImpactLabel)',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: _priceImpactColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String val, {
    bool isHighlight = false,
    Color? highlightColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 11.5, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          val,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 12.5,
            fontWeight: FontWeight.bold,
            color: isHighlight ? highlightColor : null,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Hyperbolic Constant Product Invariant Curve
// -------------------------------------------------------------
class _AmmCurvePainter extends CustomPainter {
  final double initialX;
  final double initialY;
  final double newX;
  final double newY;
  final double k;
  final bool isDark;

  _AmmCurvePainter({
    required this.initialX,
    required this.initialY,
    required this.newX,
    required this.newY,
    required this.k,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Scale Domain: X from 50 to 180 ETH, Y from 150k to 550k USDC
    const minX = 60.0;
    const maxX = 170.0;
    const minY = 180000.0;
    const maxY = 500000.0;

    double mapX(double x) => ((x - minX) / (maxX - minX)) * w;
    double mapY(double y) => h - (((y - minY) / (maxY - minY)) * h);

    // 1. Draw Axis & Grid
    final gridPaint =
        Paint()
          ..color = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          )
          ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset(0, h * (i / 4)),
        Offset(w, h * (i / 4)),
        gridPaint,
      );
      canvas.drawLine(
        Offset(w * (i / 4), 0),
        Offset(w * (i / 4), h),
        gridPaint,
      );
    }

    // 2. Draw Hyperbolic Invariant Curve y = k / x
    final curvePath = Path();
    final fillPath = Path();

    bool started = false;
    for (double x = minX; x <= maxX; x += 1.0) {
      final y = k / x;
      final px = mapX(x);
      final py = mapY(y);

      if (!started) {
        curvePath.moveTo(px, py);
        fillPath.moveTo(px, h);
        fillPath.lineTo(px, py);
        started = true;
      } else {
        curvePath.lineTo(px, py);
        fillPath.lineTo(px, py);
      }
    }

    fillPath.lineTo(w, h);
    fillPath.close();

    // Shaded Area under Curve
    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6366F1).withValues(alpha: 0.20),
              const Color(0xFF6366F1).withValues(alpha: 0.02),
            ],
          ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    final curvePaint =
        Paint()
          ..color = const Color(0xFF6366F1)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
    canvas.drawPath(curvePath, curvePaint);

    // 3. Draw Initial Point (x0, y0)
    final p0x = mapX(initialX);
    final p0y = mapY(initialY);

    final p1x = mapX(newX);
    final p1y = mapY(newY);

    // Draw Tangent/Secant line between P0 and P1
    final secantPaint =
        Paint()
          ..color = const Color(0xFFF59E0B).withValues(alpha: 0.6)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(p0x, p0y), Offset(p1x, p1y), secantPaint);

    // Initial Equilibrium Point (Blue)
    canvas.drawCircle(
      Offset(p0x, p0y),
      7,
      Paint()..color = const Color(0xFF38BDF8),
    );
    canvas.drawCircle(Offset(p0x, p0y), 3.5, Paint()..color = Colors.white);

    // Target Swap Point (Green/Red depending on slippage)
    canvas.drawCircle(
      Offset(p1x, p1y),
      7,
      Paint()..color = const Color(0xFF10B981),
    );
    canvas.drawCircle(Offset(p1x, p1y), 3.5, Paint()..color = Colors.white);

    // Point Label Text
    final tp0 = TextPainter(
      text: const TextSpan(
        text: 'P₀ (Awal)',
        style: TextStyle(
          fontSize: 10,
          color: Color(0xFF38BDF8),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp0.paint(canvas, Offset(p0x - 20, p0y - 20));

    final tp1 = TextPainter(
      text: const TextSpan(
        text: 'P₁ (Swap)',
        style: TextStyle(
          fontSize: 10,
          color: Color(0xFF10B981),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp1.paint(canvas, Offset(p1x + 8, p1y - 10));
  }

  @override
  bool shouldRepaint(covariant _AmmCurvePainter oldDelegate) => true;
}
