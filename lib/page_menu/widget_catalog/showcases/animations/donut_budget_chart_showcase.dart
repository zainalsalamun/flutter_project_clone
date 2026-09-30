import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutBudgetChartShowcase extends StatefulWidget {
  const DonutBudgetChartShowcase({super.key});

  @override
  State<DonutBudgetChartShowcase> createState() =>
      _DonutBudgetChartShowcaseState();
}

class _DonutBudgetChartShowcaseState extends State<DonutBudgetChartShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;
  late Animation<double> _sweepAnimation;

  int? _selectedSliceIndex;

  final List<Map<String, dynamic>> _budgetItems = [
    {
      'title': 'Makanan & Kuliner',
      'amount': 2750000,
      'percentage': 0.35,
      'color': const Color(0xFF6366F1),
      'icon': Icons.restaurant_rounded,
    },
    {
      'title': 'Belanja & Fashion',
      'amount': 1950000,
      'percentage': 0.25,
      'color': const Color(0xFF10B981),
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'title': 'Transportasi & BBM',
      'amount': 1550000,
      'percentage': 0.20,
      'color': const Color(0xFF06B6D4),
      'icon': Icons.directions_car_rounded,
    },
    {
      'title': 'Tagihan & Listrik',
      'amount': 950000,
      'percentage': 0.12,
      'color': const Color(0xFFF59E0B),
      'icon': Icons.bolt_rounded,
    },
    {
      'title': 'Hiburan & Hobi',
      'amount': 650000,
      'percentage': 0.08,
      'color': const Color(0xFFEF4444),
      'icon': Icons.sports_esports_rounded,
    },
  ];

  int get _totalBudget =>
      _budgetItems.fold(0, (sum, item) => sum + (item['amount'] as int));

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _sweepAnimation = CurvedAnimation(
      parent: _sweepController,
      curve: Curves.easeOutCubic,
    );

    _sweepController.forward();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  void _onChartTap(Offset localPos, Size chartSize) {
    final center = Offset(chartSize.width / 2, chartSize.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final outerRadius = chartSize.width / 2;
    const innerRadius = 55.0;

    if (distance < innerRadius || distance > outerRadius + 12) {
      // Tap outside donut or inside hole resets selection
      setState(() => _selectedSliceIndex = null);
      return;
    }

    // Angle from -pi to pi. Convert to 0 to 2*pi starting from top (-pi/2)
    var angle = math.atan2(dy, dx);
    angle += math.pi / 2;
    if (angle < 0) angle += math.pi * 2;

    double cumulativeAngle = 0.0;
    for (int i = 0; i < _budgetItems.length; i++) {
      final sweep = (_budgetItems[i]['percentage'] as double) * math.pi * 2;
      if (angle >= cumulativeAngle && angle <= cumulativeAngle + sweep) {
        setState(() {
          _selectedSliceIndex = (_selectedSliceIndex == i) ? null : i;
        });
        return;
      }
      cumulativeAngle += sweep;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem =
        _selectedSliceIndex != null ? _budgetItems[_selectedSliceIndex!] : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. DONUT CHART DISPLAY CARD ----------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.pie_chart_rounded,
                        size: 18,
                        color: Color(0xFF6366F1),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ringkasan Pengeluaran',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      _sweepController.forward(from: 0.0);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 14),
                    label: const Text('Replay', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Donut Chart Stage with Gesture Detector
              SizedBox(
                width: 200,
                height: 200,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final chartSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return GestureDetector(
                      onTapDown:
                          (details) =>
                              _onChartTap(details.localPosition, chartSize),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _sweepAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                size: chartSize,
                                painter: _DonutChartPainter(
                                  items: _budgetItems,
                                  sweepProgress: _sweepAnimation.value,
                                  selectedIndex: _selectedSliceIndex,
                                ),
                              );
                            },
                          ),

                          // Center Hub Info Text
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Column(
                              key: ValueKey(selectedItem?['title'] ?? 'total'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedItem != null
                                      ? (selectedItem['title'] as String)
                                      : 'TOTAL EXPENSE',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: selectedItem != null ? 9.5 : 8.5,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        selectedItem != null
                                            ? (selectedItem['color'] as Color)
                                            : Colors.grey.shade500,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedItem != null
                                      ? _formatRupiah(
                                        selectedItem['amount'] as int,
                                      )
                                      : _formatRupiah(_totalBudget),
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (selectedItem != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (selectedItem['color'] as Color)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${((selectedItem['percentage'] as double) * 100).toInt()}% dari total',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                        color: selectedItem['color'] as Color,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ---------------- 2. INTERACTIVE LEGEND LIST ----------------
              Column(
                children: List.generate(_budgetItems.length, (idx) {
                  final item = _budgetItems[idx];
                  final isSelected = _selectedSliceIndex == idx;
                  final percentage =
                      ((item['percentage'] as double) * 100).toInt();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          _selectedSliceIndex =
                              (_selectedSliceIndex == idx) ? null : idx;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? (item['color'] as Color).withValues(
                                    alpha: 0.1,
                                  )
                                  : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isSelected
                                    ? (item['color'] as Color)
                                    : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    '$percentage% dari alokasi bulanan',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _formatRupiah(item['amount'] as int),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CUSTOM PAINTER FOR DONUT BUDGET CHART WITH SLICE POP-OUT
// ---------------------------------------------------------------------------
class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> items;
  final double sweepProgress;
  final int? selectedIndex;

  _DonutChartPainter({
    required this.items,
    required this.sweepProgress,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const strokeWidth = 24.0;
    const gapAngle = 0.035; // Gap between slices in radians

    double startAngle = -math.pi / 2; // Start from 12 o'clock

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final itemFraction = item['percentage'] as double;
      final fullSweep = itemFraction * math.pi * 2;
      final actualSweep = (fullSweep * sweepProgress - gapAngle).clamp(
        0.0,
        math.pi * 2,
      );

      final isSelected = selectedIndex == i;
      final midAngle = startAngle + (actualSweep / 2);

      // Pop out selected slice along its radial direction
      final offsetDistance = isSelected ? 8.0 : 0.0;
      final sliceCenter =
          center +
          Offset(
            math.cos(midAngle) * offsetDistance,
            math.sin(midAngle) * offsetDistance,
          );

      final paint =
          Paint()
            ..color = item['color'] as Color
            ..style = PaintingStyle.stroke
            ..strokeWidth = isSelected ? strokeWidth + 4 : strokeWidth
            ..strokeCap = StrokeCap.round;

      if (actualSweep > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: sliceCenter, radius: radius),
          startAngle + (gapAngle / 2),
          actualSweep,
          false,
          paint,
        );
      }

      startAngle += fullSweep * sweepProgress;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.sweepProgress != sweepProgress ||
      oldDelegate.selectedIndex != selectedIndex;
}
