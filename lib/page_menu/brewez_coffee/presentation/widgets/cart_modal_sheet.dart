import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_addon_model.dart';

class CartModalSheet extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int index) onIncrement;
  final Function(int index) onDecrement;
  final VoidCallback onCheckout;

  const CartModalSheet({
    super.key,
    required this.cartItems,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCheckout,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> cartItems,
    required Function(int index) onIncrement,
    required Function(int index) onDecrement,
    required VoidCallback onCheckout,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return CartModalSheet(
            cartItems: cartItems,
            onIncrement: (index) {
              onIncrement(index);
              setState(() {});
            },
            onDecrement: (index) {
              onDecrement(index);
              setState(() {});
            },
            onCheckout: () {
              Navigator.pop(context);
              onCheckout();
            },
          );
        },
      ),
    );
  }

  num get _totalPrice {
    num total = 0;
    for (final item in cartItems) {
      final price = (item['price'] as num);
      final qty = (item['quantity'] as int? ?? 1);
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
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

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BrewezTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: BrewezTheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      BrewezLocalization.tr('my_cart'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.textDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: BrewezTheme.accentWarm,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int? ?? 1))} ${BrewezLocalization.tr('items_count')}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: BrewezTheme.espresso,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 12),

            // Cart Items List
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: BrewezTheme.primary.withOpacity(0.08),
                            ),
                            child: const Icon(
                              Icons.coffee_rounded,
                              size: 48,
                              color: BrewezTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            BrewezLocalization.tr('cart_empty'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: BrewezTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            BrewezLocalization.tr('cart_empty_sub'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final qty = item['quantity'] as int? ?? 1;
                        final price = item['price'] as num;
                        final size = item['size'] as String? ?? 'M';
                        final isHot = item['isHot'] as bool? ?? true;
                        final sweetness = item['sweetness'] as int? ?? 70;
                        final addons =
                            item['selectedAddons'] as Set<AddonType>? ?? {};

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9FB),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  item['image'] as String,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 65,
                                    height: 65,
                                    color: BrewezTheme.primaryLight,
                                    child: const Icon(Icons.coffee_rounded),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: BrewezTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      BrewezCurrency.format(price),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: BrewezTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Tags: Size, Temp, Sweetness, Addons
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: [
                                        _tag("Size $size"),
                                        _tag(isHot
                                            ? BrewezLocalization.tr('hot_badge')
                                            : BrewezLocalization.tr('iced_badge')),
                                        _tag(
                                            "$sweetness% ${BrewezLocalization.tr('sugar_label')}"),
                                        ...addons.map((a) {
                                          final model = CoffeeAddonModel
                                              .allAddons
                                              .firstWhere(
                                                  (item) => item.type == a);
                                          return _tag(
                                            "+${BrewezLocalization.tr(model.translationKeyName)}",
                                            isHighlight: true,
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Controls
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    _qtyBtn(
                                      icon: Icons.remove,
                                      onTap: () => onDecrement(index),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        "$qty",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _qtyBtn(
                                      icon: Icons.add,
                                      onTap: () => onIncrement(index),
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

            if (cartItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrewezTheme.accentWarm.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      BrewezLocalization.tr('total_price'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      BrewezCurrency.format(_totalPrice),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: BrewezTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrewezTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.coffee_maker_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        BrewezLocalization.tr('checkout_btn'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHighlight
            ? BrewezTheme.primary.withOpacity(0.12)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isHighlight ? BrewezTheme.primaryDark : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, size: 14, color: BrewezTheme.textDark),
      ),
    );
  }
}
