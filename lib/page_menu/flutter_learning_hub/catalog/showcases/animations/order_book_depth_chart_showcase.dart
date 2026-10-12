import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OrderBookViewMode { depthChart, ladder, split }

class OrderBookDepthChartShowcase extends StatefulWidget {
  const OrderBookDepthChartShowcase({super.key});

  @override
  State<OrderBookDepthChartShowcase> createState() =>
      _OrderBookDepthChartShowcaseState();
}

class _OrderDepthPoint {
  final double price;
  final double amount;
  final double total;

  const _OrderDepthPoint({
    required this.price,
    required this.amount,
    required this.total,
  });
}

class _OrderBookDepthChartShowcaseState
    extends State<OrderBookDepthChartShowcase> {
  OrderBookViewMode _viewMode = OrderBookViewMode.split;
  double _granularity = 0.5;
  double _midPrice = 64280.0;
  double? _hoverPrice;
  double? _hoverVolume;
  bool _isHovering = false;

  Timer? _tickerTimer;
  final math.Random _random = math.Random(42);

  List<_OrderDepthPoint> _bids = [];
  List<_OrderDepthPoint> _asks = [];

  @override
  void initState() {
    super.initState();
    _generateOrderData();
    _startLiveSimulation();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _generateOrderData() {
    final List<_OrderDepthPoint> newBids = [];
    final List<_OrderDepthPoint> newAsks = [];

    // Bids (Buy orders below mid price)
    double cumBidTotal = 0;
    for (int i = 1; i <= 15; i++) {
      final price = _midPrice - (i * _granularity * 10);
      final amount = 0.15 + _random.nextDouble() * 1.8 + (i * 0.08);
      cumBidTotal += amount;
      newBids.add(
        _OrderDepthPoint(price: price, amount: amount, total: cumBidTotal),
      );
    }

    // Asks (Sell orders above mid price)
    double cumAskTotal = 0;
    for (int i = 1; i <= 15; i++) {
      final price = _midPrice + (i * _granularity * 10);
      final amount = 0.15 + _random.nextDouble() * 1.8 + (i * 0.08);
      cumAskTotal += amount;
      newAsks.add(
        _OrderDepthPoint(price: price, amount: amount, total: cumAskTotal),
      );
    }

    setState(() {
      _bids = newBids;
      _asks = newAsks;
    });
  }

  void _startLiveSimulation() {
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final delta = (_random.nextDouble() - 0.49) * 8.0;
      _midPrice = (_midPrice + delta).clamp(60000.0, 70000.0);
      _generateOrderData();
    });
  }

  String _formatPrice(double val) {
    return val.toStringAsFixed(1);
  }

  String _formatVolume(double val) {
    return val.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bestBid = _bids.isNotEmpty ? _bids.first.price : _midPrice - 1;
    final bestAsk = _asks.isNotEmpty ? _asks.first.price : _midPrice + 1;
    final spread = bestAsk - bestBid;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER INFO CARD
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
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.candlestick_chart_rounded,
                    color: Color(0xFF10B981),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'BTC / USDT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Perpetual',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '\$${_formatPrice(_midPrice)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '+2.45%',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Spread Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'SPREAD',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                      Text(
                        _formatPrice(spread),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // CONTROLS & MODE TOGGLES
          Row(
            children: [
              // View mode selector
              Expanded(
                child: SegmentedButton<OrderBookViewMode>(
                  segments: const [
                    ButtonSegment(
                      value: OrderBookViewMode.split,
                      label: Text('Split', style: TextStyle(fontSize: 10)),
                    ),
                    ButtonSegment(
                      value: OrderBookViewMode.depthChart,
                      label: Text('Depth', style: TextStyle(fontSize: 10)),
                    ),
                    ButtonSegment(
                      value: OrderBookViewMode.ladder,
                      label: Text('Ladder', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                  selected: {_viewMode},
                  showSelectedIcon: false,
                  onSelectionChanged: (modes) {
                    HapticFeedback.selectionClick();
                    setState(() => _viewMode = modes.first);
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Granularity Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    value: _granularity,
                    isDense: true,
                    dropdownColor:
                        isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    items:
                        const [0.1, 0.5, 1.0, 5.0].map((g) {
                          return DropdownMenuItem(value: g, child: Text('±$g'));
                        }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _granularity = val;
                          _generateOrderData();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MAIN VISUAL CANVAS
          if (_viewMode == OrderBookViewMode.depthChart ||
              _viewMode == OrderBookViewMode.split)
            _buildDepthChartCard(isDark),

          if (_viewMode == OrderBookViewMode.split) const SizedBox(height: 14),

          if (_viewMode == OrderBookViewMode.ladder ||
              _viewMode == OrderBookViewMode.split)
            _buildOrderLadderCard(isDark),
        ],
      ),
    );
  }

  // 1. DEPTH CHART CARD
  Widget _buildDepthChartCard(bool isDark) {
    final maxTotal = math.max(
      _bids.isNotEmpty ? _bids.last.total : 1.0,
      _asks.isNotEmpty ? _asks.last.total : 1.0,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Market Depth Graph',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (_isHovering && _hoverPrice != null)
                Text(
                  'Hover: \$${_formatPrice(_hoverPrice!)} (${_formatVolume(_hoverVolume ?? 0)} BTC)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38BDF8),
                  ),
                )
              else
                const Text(
                  'Bids (Buy) vs Asks (Sell)',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onPanDown: (details) => _updateHover(details.localPosition),
            onPanUpdate: (details) => _updateHover(details.localPosition),
            onPanEnd: (_) => setState(() => _isHovering = false),
            onTapDown: (details) => _updateHover(details.localPosition),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: _DepthChartPainter(
                  bids: _bids,
                  asks: _asks,
                  maxTotal: maxTotal,
                  midPrice: _midPrice,
                  hoverPrice: _isHovering ? _hoverPrice : null,
                  isDark: isDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_formatPrice(_bids.isNotEmpty ? _bids.last.price : _midPrice - 50)}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF10B981)),
              ),
              Text(
                'Mid \$${_formatPrice(_midPrice)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${_formatPrice(_asks.isNotEmpty ? _asks.last.price : _midPrice + 50)}',
                style: const TextStyle(fontSize: 10, color: Color(0xFFEF4444)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateHover(Offset localPos) {
    const width = 390.0;
    final ratio = (localPos.dx / width).clamp(0.0, 1.0);

    setState(() {
      _isHovering = true;
      if (ratio < 0.5) {
        // In Bids
        final bidRatio = (0.5 - ratio) / 0.5;
        final idx = (bidRatio * (_bids.length - 1)).round().clamp(
          0,
          _bids.length - 1,
        );
        _hoverPrice = _bids[idx].price;
        _hoverVolume = _bids[idx].total;
      } else {
        // In Asks
        final askRatio = (ratio - 0.5) / 0.5;
        final idx = (askRatio * (_asks.length - 1)).round().clamp(
          0,
          _asks.length - 1,
        );
        _hoverPrice = _asks[idx].price;
        _hoverVolume = _asks[idx].total;
      }
    });
  }

  // 2. ORDER LADDER CARD
  Widget _buildOrderLadderCard(bool isDark) {
    final maxBidTotal = _bids.isNotEmpty ? _bids.last.total : 1.0;
    final maxAskTotal = _asks.isNotEmpty ? _asks.last.total : 1.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1120) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price (USDT)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Size (BTC)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Total (BTC)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Divider(height: 16),

          // Asks (Sells) Top 5
          Column(
            children:
                _asks.take(5).toList().reversed.map((ask) {
                  final barRatio = (ask.total / maxAskTotal).clamp(0.0, 1.0);
                  return _buildOrderRow(
                    price: ask.price,
                    amount: ask.amount,
                    total: ask.total,
                    barRatio: barRatio,
                    isBuy: false,
                    isDark: isDark,
                  );
                }).toList(),
          ),

          // Mid Price Line
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: isDark ? Colors.white24 : Colors.black12,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '\$${_formatPrice(_midPrice)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDark ? Colors.white24 : Colors.black12,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),

          // Bids (Buys) Top 5
          Column(
            children:
                _bids.take(5).map((bid) {
                  final barRatio = (bid.total / maxBidTotal).clamp(0.0, 1.0);
                  return _buildOrderRow(
                    price: bid.price,
                    amount: bid.amount,
                    total: bid.total,
                    barRatio: barRatio,
                    isBuy: true,
                    isDark: isDark,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow({
    required double price,
    required double amount,
    required double total,
    required double barRatio,
    required bool isBuy,
    required bool isDark,
  }) {
    final color = isBuy ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      height: 24,
      child: Stack(
        children: [
          // Depth Volume Bar
          Positioned.fill(
            child: Align(
              alignment: isBuy ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: barRatio,
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Text Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatPrice(price),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  _formatVolume(amount),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  _formatVolume(total),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// CustomPainter: Visual Cumulative Depth Chart
// -------------------------------------------------------------
class _DepthChartPainter extends CustomPainter {
  final List<_OrderDepthPoint> bids;
  final List<_OrderDepthPoint> asks;
  final double maxTotal;
  final double midPrice;
  final double? hoverPrice;
  final bool isDark;

  _DepthChartPainter({
    required this.bids,
    required this.asks,
    required this.maxTotal,
    required this.midPrice,
    required this.hoverPrice,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bids.isEmpty || asks.isEmpty) return;

    final centerX = size.width / 2;
    final h = size.height;

    // Draw background grid lines
    final gridPaint =
        Paint()
          ..color = (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.05,
          )
          ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, h * 0.25),
      Offset(size.width, h * 0.25),
      gridPaint,
    );
    canvas.drawLine(Offset(0, h * 0.5), Offset(size.width, h * 0.5), gridPaint);
    canvas.drawLine(
      Offset(0, h * 0.75),
      Offset(size.width, h * 0.75),
      gridPaint,
    );
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, h), gridPaint);

    // 1. DRAW BIDS (Left - Green)
    final bidPath = Path();
    final bidFillPath = Path();

    bidPath.moveTo(centerX, h - (bids.first.total / maxTotal) * h * 0.85);
    bidFillPath.moveTo(centerX, h);
    bidFillPath.lineTo(centerX, h - (bids.first.total / maxTotal) * h * 0.85);

    for (int i = 0; i < bids.length; i++) {
      final ratio = (i + 1) / bids.length;
      final x = centerX - (ratio * centerX);
      final y = h - (bids[i].total / maxTotal) * h * 0.85;
      bidPath.lineTo(x, y);
      bidFillPath.lineTo(x, y);
    }

    bidFillPath.lineTo(0, h);
    bidFillPath.close();

    final bidFillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF10B981).withValues(alpha: 0.35),
              const Color(0xFF10B981).withValues(alpha: 0.02),
            ],
          ).createShader(Rect.fromLTWH(0, 0, centerX, h));

    final bidStrokePaint =
        Paint()
          ..color = const Color(0xFF10B981)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    canvas.drawPath(bidFillPath, bidFillPaint);
    canvas.drawPath(bidPath, bidStrokePaint);

    // 2. DRAW ASKS (Right - Red)
    final askPath = Path();
    final askFillPath = Path();

    askPath.moveTo(centerX, h - (asks.first.total / maxTotal) * h * 0.85);
    askFillPath.moveTo(centerX, h);
    askFillPath.lineTo(centerX, h - (asks.first.total / maxTotal) * h * 0.85);

    for (int i = 0; i < asks.length; i++) {
      final ratio = (i + 1) / asks.length;
      final x = centerX + (ratio * centerX);
      final y = h - (asks[i].total / maxTotal) * h * 0.85;
      askPath.lineTo(x, y);
      askFillPath.lineTo(x, y);
    }

    askFillPath.lineTo(size.width, h);
    askFillPath.close();

    final askFillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFEF4444).withValues(alpha: 0.35),
              const Color(0xFFEF4444).withValues(alpha: 0.02),
            ],
          ).createShader(Rect.fromLTWH(centerX, 0, centerX, h));

    final askStrokePaint =
        Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    canvas.drawPath(askFillPath, askFillPaint);
    canvas.drawPath(askPath, askStrokePaint);

    // 3. HOVER CROSSHAIR
    if (hoverPrice != null) {
      final hoverPaint =
          Paint()
            ..color = const Color(0xFF38BDF8)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke;

      // Draw dashed or solid vertical hover line
      final hoverX =
          hoverPrice! < midPrice
              ? centerX -
                  ((midPrice - hoverPrice!) /
                          (midPrice - bids.last.price).clamp(1.0, 9999.0)) *
                      centerX
              : centerX +
                  ((hoverPrice! - midPrice) /
                          (asks.last.price - midPrice).clamp(1.0, 9999.0)) *
                      centerX;

      canvas.drawLine(Offset(hoverX, 0), Offset(hoverX, h), hoverPaint);

      // Dot at hover location
      canvas.drawCircle(
        Offset(hoverX, h * 0.5),
        4.0,
        Paint()..color = const Color(0xFF38BDF8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DepthChartPainter oldDelegate) => true;
}
