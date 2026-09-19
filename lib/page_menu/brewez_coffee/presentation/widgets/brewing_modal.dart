import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_order_model.dart';
import 'receipt_modal_sheet.dart';

class BrewingModal extends StatefulWidget {
  final CoffeeOrderModel order;
  final VoidCallback onFinish;

  const BrewingModal({super.key, required this.order, required this.onFinish});

  static Future<void> show(
    BuildContext context, {
    required CoffeeOrderModel order,
    required VoidCallback onFinish,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => BrewingModal(order: order, onFinish: onFinish),
    );
  }

  @override
  State<BrewingModal> createState() => _BrewingModalState();
}

class _BrewingModalState extends State<BrewingModal>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _startBrewingSimulation();
  }

  void _startBrewingSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getSteps() {
    return [
      {
        'title': BrewezLocalization.tr('step_1_title'),
        'desc': BrewezLocalization.tr('step_1_desc'),
        'icon': Icons.grain_rounded,
      },
      {
        'title': BrewezLocalization.tr('step_2_title'),
        'desc': BrewezLocalization.tr('step_2_desc'),
        'icon': Icons.coffee_maker_rounded,
      },
      {
        'title': BrewezLocalization.tr('step_3_title'),
        'desc': BrewezLocalization.tr('step_3_desc'),
        'icon': Icons.water_drop_rounded,
      },
      {
        'title': BrewezLocalization.tr('step_4_title'),
        'desc': BrewezLocalization.tr('step_4_desc'),
        'icon': Icons.check_circle_rounded,
      },
    ];
  }

  void _openReceipt() {
    Navigator.pop(context); // Close Brewing Modal
    ReceiptModalSheet.show(
      context,
      order: widget.order,
      onDone: widget.onFinish,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _currentStep == 3;
    final steps = _getSteps();
    final firstItem =
        widget.order.items.isNotEmpty ? widget.order.items.first : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            // Animated Header Circle Icon with Pulse
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale =
                    isFinished ? 1.0 : 1.0 + (_pulseController.value * 0.05);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          isFinished
                              ? const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                              )
                              : BrewezTheme.warmCoffeeGradient,
                      boxShadow: [
                        BoxShadow(
                          color: (isFinished
                                  ? const Color(0xFF4CAF50)
                                  : BrewezTheme.primary)
                              .withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        steps[_currentStep]['icon'] as IconData,
                        key: ValueKey<int>(_currentStep),
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Step Title & Description
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey<int>(_currentStep),
                children: [
                  Text(
                    steps[_currentStep]['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: BrewezTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[_currentStep]['desc'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Step Progress Bars (4 Steps)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isActive = index <= _currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 36 : 12,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? (isFinished
                                ? const Color(0xFF2E7D32)
                                : BrewezTheme.primary)
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Order Quick Card Info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrewezTheme.accentWarm.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: BrewezTheme.primaryLight.withOpacity(0.4),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: BrewezTheme.espresso,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.order.queueNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.order.orderId,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: BrewezTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        BrewezCurrency.format(widget.order.totalAmount),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: BrewezTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (firstItem != null) ...[
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade300, height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.order.totalItemsCount}x Minuman (${firstItem.name}${widget.order.items.length > 1 ? ' dll.' : ''})",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          firstItem.isHot
                              ? BrewezLocalization.tr('hot_badge')
                              : BrewezLocalization.tr('iced_badge'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                                firstItem.isHot
                                    ? Colors.deepOrange
                                    : Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons: View Receipt OR Progress Loading
            if (isFinished) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _openReceipt,
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: Text(
                    BrewezLocalization.tr('view_receipt_btn'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrewezTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onFinish();
                  },
                  child: Text(
                    BrewezLocalization.tr('enjoy_drink'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: BrewezTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      BrewezLocalization.tr('brewing_progress'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
