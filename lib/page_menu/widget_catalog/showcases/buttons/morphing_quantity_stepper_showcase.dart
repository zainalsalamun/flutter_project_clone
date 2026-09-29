import 'package:flutter/material.dart';

class MorphingQuantityStepperShowcase extends StatefulWidget {
  const MorphingQuantityStepperShowcase({super.key});

  @override
  State<MorphingQuantityStepperShowcase> createState() =>
      _MorphingQuantityStepperShowcaseState();
}

class _MorphingQuantityStepperShowcaseState
    extends State<MorphingQuantityStepperShowcase> {
  int _itemQuantity1 = 0;
  int _itemQuantity2 = 1;
  int _itemQuantity3 = 0;

  static const int _unitPrice1 = 28000;
  static const int _unitPrice2 = 45000;
  static const int _unitPrice3 = 18500;
  static const int _maxQty = 10;

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

  void _showMaxToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Maksimum pemesanan adalah 10 item.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF59E0B),
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalOrderPrice =
        (_itemQuantity1 * _unitPrice1) +
        (_itemQuantity2 * _unitPrice2) +
        (_itemQuantity3 * _unitPrice3);
    final totalItems = _itemQuantity1 + _itemQuantity2 + _itemQuantity3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. PRODUCT CARD WITH MORPHING STEPPER ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Daftar Menu Favorit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Item 1: Kopi Susu Creamy
              _buildProductItem(
                icon: Icons.coffee_rounded,
                iconColor: const Color(0xFF78350F),
                bgColor: const Color(0xFFFEF3C7),
                name: 'Kopi Susu Creamy Aren',
                description: 'Espresso blend, fresh milk, gula aren murni',
                price: _unitPrice1,
                quantity: _itemQuantity1,
                onAdd: () => setState(() => _itemQuantity1 = 1),
                onIncrement: () {
                  if (_itemQuantity1 < _maxQty) {
                    setState(() => _itemQuantity1++);
                  } else {
                    _showMaxToast();
                  }
                },
                onDecrement: () {
                  setState(() => _itemQuantity1--);
                },
              ),
              const Divider(height: 20, thickness: 0.8),

              // Item 2: Croissant Almond
              _buildProductItem(
                icon: Icons.bakery_dining_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                name: 'Croissant Almond Butter',
                description: 'Flaky pastry dengan taburan almond renyah',
                price: _unitPrice2,
                quantity: _itemQuantity2,
                onAdd: () => setState(() => _itemQuantity2 = 1),
                onIncrement: () {
                  if (_itemQuantity2 < _maxQty) {
                    setState(() => _itemQuantity2++);
                  } else {
                    _showMaxToast();
                  }
                },
                onDecrement: () {
                  setState(() => _itemQuantity2--);
                },
              ),
              const Divider(height: 20, thickness: 0.8),

              // Item 3: Matcha Latte Iced
              _buildProductItem(
                icon: Icons.emoji_food_beverage_rounded,
                iconColor: const Color(0xFF15803D),
                bgColor: const Color(0xFFDCFCE7),
                name: 'Matcha Latte Uji Kyoto',
                description: 'Matcha grade ceremonial dengan oat milk',
                price: _unitPrice3,
                quantity: _itemQuantity3,
                onAdd: () => setState(() => _itemQuantity3 = 1),
                onIncrement: () {
                  if (_itemQuantity3 < _maxQty) {
                    setState(() => _itemQuantity3++);
                  } else {
                    _showMaxToast();
                  }
                },
                onDecrement: () {
                  setState(() => _itemQuantity3--);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SUMMARY & LIVE CHECKOUT BAR ----------------
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                totalItems > 0 ? const Color(0xFF0F172A) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
            boxShadow:
                totalItems > 0
                    ? [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            children: [
              // Cart item count badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      totalItems > 0
                          ? const Color(0xFF6366F1)
                          : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: totalItems > 0 ? Colors.white : Colors.grey.shade600,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),

              // Total Calculation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalItems > 0
                          ? '$totalItems item terpilih'
                          : 'Keranjang masih kosong',
                      style: TextStyle(
                        fontSize: 10.5,
                        color:
                            totalItems > 0
                                ? Colors.white70
                                : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(totalOrderPrice),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color:
                            totalItems > 0
                                ? Colors.white
                                : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkout CTA
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      totalItems > 0
                          ? const Color(0xFF10B981)
                          : Colors.grey.shade300,
                  foregroundColor:
                      totalItems > 0 ? Colors.white : Colors.grey.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    totalItems > 0
                        ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Memproses pesanan $totalItems item (${_formatRupiah(totalOrderPrice)})...',
                              ),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        : null,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pesan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String name,
    required String description,
    required int price,
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Icon Container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),

        // Product Title & Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                _formatRupiah(price),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // ---------------- MORPHING STEPPER WIDGET ----------------
        _MorphingStepper(
          quantity: quantity,
          onAdd: onAdd,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ANIMATED MORPHING STEPPER BUTTON
// ---------------------------------------------------------------------------
class _MorphingStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _MorphingStepper({
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = quantity > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 4 : 0),
      decoration: BoxDecoration(
        color:
            isExpanded
                ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                : const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isExpanded
                  ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                  : Colors.transparent,
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder:
            (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            ),
        child:
            isExpanded
                ? Row(
                  key: const ValueKey('stepper_controls'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrement Button
                    _buildCircleButton(
                      icon: Icons.remove_rounded,
                      color: const Color(0xFF6366F1),
                      onTap: onDecrement,
                    ),
                    // Quantity Counter
                    Container(
                      constraints: const BoxConstraints(minWidth: 26),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder:
                            (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                        child: Text(
                          '$quantity',
                          key: ValueKey('qty_$quantity'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ),
                    // Increment Button
                    _buildCircleButton(
                      icon: Icons.add_rounded,
                      color: const Color(0xFF6366F1),
                      onTap: onIncrement,
                    ),
                  ],
                )
                : InkWell(
                  key: const ValueKey('add_button'),
                  borderRadius: BorderRadius.circular(20),
                  onTap: onAdd,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Tambah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
      ),
    );
  }
}
