import 'package:flutter/material.dart';
import '../../core/localization/brewez_localization.dart';
import '../../core/theme/brewez_theme.dart';
import '../../core/utils/brewez_currency.dart';
import '../../data/models/coffee_addon_model.dart';
import 'animated_cup_visualizer.dart';
import 'animated_size_selector.dart';
import 'custom_sweetness_slider.dart';
import 'interactive_addons_selector.dart';
import 'temperature_toggle.dart';

class QuickCustomizeSheet extends StatefulWidget {
  final Map<String, dynamic> coffee;
  final Function(Map<String, dynamic> customizedItem) onAddToCart;

  const QuickCustomizeSheet({
    super.key,
    required this.coffee,
    required this.onAddToCart,
  });

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> coffee,
    required Function(Map<String, dynamic> customizedItem) onAddToCart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickCustomizeSheet(
        coffee: coffee,
        onAddToCart: onAddToCart,
      ),
    );
  }

  @override
  State<QuickCustomizeSheet> createState() => _QuickCustomizeSheetState();
}

class _QuickCustomizeSheetState extends State<QuickCustomizeSheet> {
  String _selectedSize = 'M';
  bool _isHot = true;
  int _sweetness = 70;
  final Set<AddonType> _selectedAddons = {AddonType.freshMilk};

  void _toggleAddon(AddonType type) {
    setState(() {
      final model =
          CoffeeAddonModel.allAddons.firstWhere((a) => a.type == type);
      if (model.category == AddonCategory.milk) {
        // Milk is single-select: switch milk choice
        _selectedAddons.removeWhere((a) =>
            CoffeeAddonModel.allAddons
                .firstWhere((m) => m.type == a)
                .category ==
            AddonCategory.milk);
        _selectedAddons.add(type);
      } else {
        if (_selectedAddons.contains(type)) {
          _selectedAddons.remove(type);
        } else {
          _selectedAddons.add(type);
        }
      }
    });
  }

  double _calculateTotalPrice() {
    final basePrice = (widget.coffee['price'] as num).toDouble();
    double sizeExtra = 0.0;
    if (_selectedSize == 'M') sizeExtra = 4000.0;
    if (_selectedSize == 'L') sizeExtra = 8000.0;

    double addonsTotal = 0.0;
    for (final addonType in _selectedAddons) {
      final addon = CoffeeAddonModel.allAddons
          .firstWhere((a) => a.type == addonType);
      addonsTotal += addon.price;
    }

    return basePrice + sizeExtra + addonsTotal;
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotalPrice();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),

          // Header with Coffee Name & Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coffee['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      BrewezLocalization.tr('quick_customize'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200, height: 1),

          // 1. PINNED MINI CUP VISUALIZER (Always visible at the top of sheet)
          Container(
            height: 230,
            width: double.infinity,
            color: const Color(0xFFFAFAFC),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedCupVisualizer(
                size: _selectedSize,
                isHot: _isHot,
                coffeeName: widget.coffee['name'],
                sweetness: _sweetness,
                selectedAddons: _selectedAddons,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade200, height: 1),

          // 2. SCROLLABLE CONTROLS (Below Pinned Cup)
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Temperature Switcher (Hot / Iced)
                TemperatureToggle(
                  isHot: _isHot,
                  onChanged: (val) {
                    setState(() {
                      _isHot = val;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Size Selector (S, M, L)
                Text(
                  BrewezLocalization.tr('cup_size'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: BrewezTheme.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSizeSelector(
                  selectedSize: _selectedSize,
                  onSizeChanged: (newSize) {
                    setState(() {
                      _selectedSize = newSize;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Sweetness Slider (0%, 50%, 70%, 100%)
                CustomSweetnessSlider(
                  sweetnessLevel: _sweetness,
                  onSweetnessChanged: (val) {
                    setState(() {
                      _sweetness = val;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Add-ons Selector (Oat Milk, Caramel, Extra Shot, Extra Ice, Cinnamon)
                InteractiveAddonsSelector(
                  selectedAddons: _selectedAddons,
                  onToggleAddon: _toggleAddon,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onAddToCart({
                      'name': widget.coffee['name'],
                      'subtitle': widget.coffee['subtitle'],
                      'image': widget.coffee['image'],
                      'size': _selectedSize,
                      'isHot': _isHot,
                      'sweetness': _sweetness,
                      'selectedAddons': Set<AddonType>.from(_selectedAddons),
                      'price': totalPrice,
                      'quantity': 1,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrewezTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                BrewezLocalization.tr('add_to_cart_btn'),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        BrewezCurrency.format(totalPrice),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: BrewezTheme.milkFoam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
