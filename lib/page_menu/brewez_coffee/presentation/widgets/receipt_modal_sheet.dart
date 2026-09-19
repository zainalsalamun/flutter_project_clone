import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_addon_model.dart';
import '../../data/models/coffee_order_model.dart';

class ReceiptModalSheet extends StatelessWidget {
  final CoffeeOrderModel order;
  final VoidCallback onDone;

  const ReceiptModalSheet({
    super.key,
    required this.order,
    required this.onDone,
  });

  static Future<void> show(
    BuildContext context, {
    required CoffeeOrderModel order,
    required VoidCallback onDone,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ReceiptModalSheet(
        order: order,
        onDone: onDone,
      ),
    );
  }

  String _formatPaymentMethodName(PaymentType type) {
    switch (type) {
      case PaymentType.qris:
        return 'QRIS (ShopeePay/GoPay/BCA)';
      case PaymentType.gopay:
        return 'GoPay';
      case PaymentType.ovo:
        return 'OVO';
      case PaymentType.dana:
        return 'DANA';
      case PaymentType.shopeepay:
        return 'ShopeePay';
      case PaymentType.bcaVa:
        return 'BCA Virtual Account';
      case PaymentType.mandiriVa:
        return 'Mandiri Virtual Account';
      case PaymentType.briVa:
        return 'BRI Virtual Account';
      case PaymentType.cash:
        return 'Tunai di Kasir';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${order.orderTime.day.toString().padLeft(2, '0')}/${order.orderTime.month.toString().padLeft(2, '0')}/${order.orderTime.year} • ${order.orderTime.hour.toString().padLeft(2, '0')}:${order.orderTime.minute.toString().padLeft(2, '0')}";

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F3F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BrewezLocalization.tr('receipt_title'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BrewezTheme.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onDone();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    // Paper Receipt Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Top Cafe Branding & Status Stamp
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: BrewezTheme.espresso,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: const Icon(
                                            Icons.coffee_rounded,
                                            color: BrewezTheme.milkFoam,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'BREWEZ COFFEE',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0.5,
                                                color: BrewezTheme.textDark,
                                              ),
                                            ),
                                            Text(
                                              'Artisanal Roast & Lounge',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // LUNAS / PAID Stamp Badge
                                    Transform.rotate(
                                      angle: -0.1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF2E7D32),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          BrewezLocalization.tr(
                                              'payment_status_paid'),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF2E7D32),
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Big Queue Number Banner
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        BrewezTheme.accentWarm,
                                        BrewezTheme.milkFoam,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: BrewezTheme.primary
                                            .withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        BrewezLocalization.tr(
                                            'pickup_queue_label'),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: BrewezTheme.espresso
                                              .withOpacity(0.7),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        order.queueNumber,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: BrewezTheme.espresso,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Perforated Separator Line
                          _buildPerforatedDivider(),

                          // Order Metadata
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      BrewezLocalization.tr('order_id_label'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order.orderId,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: BrewezTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      BrewezLocalization.tr('order_time_label'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: BrewezTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),

                          // Items List
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...order.items.map((item) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${item.quantity}x  ${item.name}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: BrewezTheme.textDark,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              BrewezCurrency.format(
                                                  item.totalPrice),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: BrewezTheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        // Item customization tags
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: [
                                            _receiptTag("Size ${item.size}"),
                                            _receiptTag(item.isHot
                                                ? BrewezLocalization.tr(
                                                    'hot_badge')
                                                : BrewezLocalization.tr(
                                                    'iced_badge')),
                                            _receiptTag(
                                                "${item.sweetness}% ${BrewezLocalization.tr('sugar_label')}"),
                                            ...item.selectedAddons.map((a) {
                                              final model = CoffeeAddonModel
                                                  .allAddons
                                                  .firstWhere(
                                                      (m) => m.type == a);
                                              return _receiptTag(
                                                "+${BrewezLocalization.tr(model.translationKeyName)}",
                                                isAddon: true,
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),

                                const SizedBox(height: 10),
                                const Divider(height: 1),
                                const SizedBox(height: 12),

                                // Subtotal & Price Breakdown
                                _priceRow(
                                  BrewezLocalization.tr('subtotal_label'),
                                  BrewezCurrency.format(order.subtotal),
                                ),
                                if (order.discount > 0) ...[
                                  const SizedBox(height: 6),
                                  _priceRow(
                                    "${BrewezLocalization.tr('discount_label')} (${order.promoCode ?? 'Promo'})",
                                    "- ${BrewezCurrency.format(order.discount)}",
                                    isGreen: true,
                                  ),
                                ],
                                if (order.serviceFee > 0) ...[
                                  const SizedBox(height: 6),
                                  _priceRow(
                                    BrewezLocalization.tr('service_fee'),
                                    BrewezCurrency.format(order.serviceFee),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                const Divider(height: 1),
                                const SizedBox(height: 8),

                                // Total Payment
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BrewezLocalization.tr('total_payment'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: BrewezTheme.textDark,
                                      ),
                                    ),
                                    Text(
                                      BrewezCurrency.format(order.totalAmount),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: BrewezTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Payment Method Used
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BrewezLocalization.tr('payment_via'),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: BrewezTheme.primary
                                            .withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _formatPaymentMethodName(
                                            order.paymentType),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: BrewezTheme.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Barcode / Scanner simulation box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBFBFC),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Simulated Barcode Lines
                                Container(
                                  height: 48,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(36, (i) {
                                      final isThick =
                                          i % 3 == 0 || i % 7 == 0 || i % 5 == 0;
                                      return Container(
                                        width: isThick ? 3.5 : 1.5,
                                        height: 40,
                                        color: Colors.black87,
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  order.paymentReference,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  BrewezLocalization.tr('pickup_barcode_hint'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons: Save Receipt & Order More
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(BrewezLocalization.tr(
                                          'receipt_saved_toast')),
                                    ],
                                  ),
                                  backgroundColor: BrewezTheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: Text(
                              BrewezLocalization.tr('download_receipt_btn'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: BrewezTheme.textDark,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              onDone();
                            },
                            icon: const Icon(Icons.coffee_rounded, size: 18),
                            label: Text(
                              BrewezLocalization.tr('order_more_btn'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BrewezTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerforatedDivider() {
    return Row(
      children: [
        Container(
          width: 14,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F3F7),
            borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(count, (_) {
                  return Container(
                    width: 5,
                    height: 1.5,
                    color: Colors.grey.shade300,
                  );
                }),
              );
            },
          ),
        ),
        Container(
          width: 14,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF4F3F7),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _receiptTag(String text, {bool isAddon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAddon
            ? BrewezTheme.primary.withOpacity(0.08)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAddon ? BrewezTheme.primaryDark : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isGreen ? Colors.green.shade700 : Colors.grey.shade600,
            fontWeight: isGreen ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen ? Colors.green.shade700 : BrewezTheme.textDark,
          ),
        ),
      ],
    );
  }
}
