import 'package:flutter/material.dart';
import 'core/localization/brewez_localization.dart';
import 'core/theme/brewez_theme.dart';
import 'core/utils/brewez_currency.dart';
import 'data/models/coffee_addon_model.dart';
import 'data/models/coffee_order_model.dart';
import 'presentation/widgets/animated_cup_visualizer.dart';
import 'presentation/widgets/temperature_toggle.dart';
import 'presentation/widgets/animated_size_selector.dart';
import 'presentation/widgets/custom_sweetness_slider.dart';
import 'presentation/widgets/interactive_addons_selector.dart';
import 'presentation/widgets/animated_brew_button.dart';
import 'presentation/widgets/brewing_modal.dart';
import 'presentation/widgets/payment_modal_sheet.dart';

class BrewezCoffeeDetailPage extends StatefulWidget {
  final Map<String, dynamic> coffee;

  const BrewezCoffeeDetailPage({super.key, required this.coffee});

  @override
  State<BrewezCoffeeDetailPage> createState() => _BrewezCoffeeDetailPageState();
}

class _BrewezCoffeeDetailPageState extends State<BrewezCoffeeDetailPage> {
  String _selectedSize = 'M';
  bool _isHot = true;
  int _sweetness = 70;
  bool _isFavorite = false;
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
    return ValueListenableBuilder<BrewezLanguage>(
      valueListenable: BrewezLocalization.currentLanguage,
      builder: (context, lang, child) {
        final totalPrice = _calculateTotalPrice();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          body: Stack(
            children: [
              // Main Layout: Split between Pinned Cup Visualizer (Top) and Scrollable Controls (Bottom)
              Column(
                children: [
                  // 1. PINNED UPPER CUP STAGE (Always visible while configuring)
                  Container(
                    height: 310,
                    width: double.infinity,
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 60),
                    child: AnimatedCupVisualizer(
                      size: _selectedSize,
                      isHot: _isHot,
                      coffeeName: widget.coffee['name'],
                      sweetness: _sweetness,
                      selectedAddons: _selectedAddons,
                    ),
                  ),

                  // 2. SCROLLABLE LOWER SHEET (Controls: Temp, Size, Sugar, Add-ons)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 110),
                        children: [
                          // Title, Subtitle, & Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.coffee['name'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: BrewezTheme.textDark,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.coffee['subtitle'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: BrewezTheme.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.coffee['rating']}',
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
                          ),

                          const SizedBox(height: 18),

                          // Temperature Switcher (Hot vs Iced)
                          TemperatureToggle(
                            isHot: _isHot,
                            onChanged: (val) {
                              setState(() {
                                _isHot = val;
                              });
                            },
                          ),

                          const SizedBox(height: 22),

                          // Animated Size Selector (S, M, L)
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

                          const SizedBox(height: 22),

                          // Custom Sweetness Slider (0%, 50%, 70%, 100%)
                          CustomSweetnessSlider(
                            sweetnessLevel: _sweetness,
                            onSweetnessChanged: (val) {
                              setState(() {
                                _sweetness = val;
                              });
                            },
                          ),

                          const SizedBox(height: 22),

                          // Interactive Add-ons Selector (Oat Milk, Caramel, Extra Shot, Extra Ice, Cinnamon)
                          InteractiveAddonsSelector(
                            selectedAddons: _selectedAddons,
                            onToggleAddon: _toggleAddon,
                          ),

                          const SizedBox(height: 22),

                          // Description
                          Text(
                            BrewezLocalization.tr('description_title'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: BrewezTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            BrewezLocalization.tr('coffee_desc'),
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Top Navigation Bar (Back and Favorite ONLY - ID/EN removed)
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _glassButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      _glassButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: _isFavorite ? Colors.redAccent : null,
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar with Dynamic Price & Animated Brew Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Price Preview
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BrewezLocalization.tr('total_price'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                BrewezCurrency.format(totalPrice),
                                key: ValueKey<double>(totalPrice),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: BrewezTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),

                        // Brew Button
                        Expanded(
                          child: AnimatedBrewButton(
                            price: totalPrice,
                            onPressed: () {
                              final orderItem = CoffeeOrderItem(
                                name: widget.coffee['name'],
                                subtitle: widget.coffee['subtitle'],
                                image: widget.coffee['image'],
                                size: _selectedSize,
                                isHot: _isHot,
                                sweetness: _sweetness,
                                selectedAddons:
                                    Set<AddonType>.from(_selectedAddons),
                                unitPrice: totalPrice,
                                quantity: 1,
                              );

                              PaymentModalSheet.show(
                                context,
                                items: [orderItem],
                                onPaymentSuccess: (order) {
                                  BrewingModal.show(
                                    context,
                                    order: order,
                                    onFinish: () {
                                      Navigator.pop(context); // return to home
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? BrewezTheme.textDark,
        ),
      ),
    );
  }
}
