import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/custom_page_routes.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/food_promo_repository.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../widgets/addon_chip.dart';
import '../widgets/animated_add_to_cart_button.dart';
import '../widgets/animated_price.dart';
import '../widgets/animated_quantity_stepper.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/food_image.dart';
import '../widgets/section_title.dart';
import '../widgets/selectable_pill.dart';
import 'cart_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key, required this.food});

  final FoodItem food;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen>
    with TickerProviderStateMixin {
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _cartKey = GlobalKey();
  late AnimationController _imageBounceController;
  late AnimationController _cartBounceController;
  late AnimationController _addedController;

  int _selectedSize = 0;
  final Set<String> _addons = {};
  int _quantity = 1;
  bool _loadingAdd = false;
  bool _added = false;

  late List<SizeOption> _sizes;
  late List<AddonOption> _addonOptions;

  int get _unitPrice {
    final addonTotal = _addonOptions
        .where((item) => _addons.contains(item.name))
        .fold(0, (sum, item) => sum + item.price);
    return widget.food.price + _sizes[_selectedSize].priceDelta + addonTotal;
  }

  int get _totalPrice => _unitPrice * _quantity;

  @override
  void initState() {
    super.initState();
    final repository = RepositoryProvider.of<FoodPromoRepository>(
      context,
      listen: false,
    );
    _sizes = repository.getSizeOptions();
    _addonOptions = repository.getAddonOptions();

    _imageBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      lowerBound: 0.94,
      upperBound: 1.06,
    )..value = 1;
    _cartBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      lowerBound: 0.86,
      upperBound: 1.2,
    )..value = 1;
    _addedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _imageBounceController.dispose();
    _cartBounceController.dispose();
    _addedController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    if (_loadingAdd) return;
    setState(() => _loadingAdd = true);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _imageBounceController.forward();
    await _imageBounceController.reverse();
    await _flyImageToCart();
    if (!mounted) return;

    context.read<CartBloc>().add(
      AddToCartEvent(
        food: widget.food,
        quantity: _quantity,
        unitPrice: _unitPrice,
        size: _sizes[_selectedSize].name,
        addons: _addons.toList(),
      ),
    );

    await _cartBounceController.forward();
    await _cartBounceController.reverse();
    if (!mounted) return;
    setState(() {
      _loadingAdd = false;
      _added = true;
    });
    _addedController.forward(from: 0);
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (mounted) setState(() => _added = false);
  }

  Future<void> _flyImageToCart() async {
    final overlay = Overlay.of(context);
    final imageContext = _imageKey.currentContext;
    final cartContext = _cartKey.currentContext;
    if (imageContext == null || cartContext == null) return;

    final imageBox = imageContext.findRenderObject() as RenderBox;
    final cartBox = cartContext.findRenderObject() as RenderBox;
    final start = imageBox.localToGlobal(Offset.zero);
    final end = cartBox.localToGlobal(Offset.zero);
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;
            final control = Offset(
              (start.dx + end.dx) / 2 + 42,
              math.min(start.dy, end.dy) - 120,
            );
            final p0 = start;
            final p1 = control;
            final p2 = end;
            final dx =
                math.pow(1 - t, 2) * p0.dx +
                2 * (1 - t) * t * p1.dx +
                math.pow(t, 2) * p2.dx;
            final dy =
                math.pow(1 - t, 2) * p0.dy +
                2 * (1 - t) * t * p1.dy +
                math.pow(t, 2) * p2.dy;
            final size = 108 - (t * 62);
            return Positioned(
              left: dx.toDouble(),
              top: dy.toDouble(),
              child: IgnorePointer(
                child: Opacity(
                  opacity: (1 - t * 0.15).clamp(0, 1),
                  child: Transform.rotate(
                    angle: t * 0.28,
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: FoodImage(
                        imageUrl: widget.food.imageUrl,
                        borderRadius: 28,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);
    await controller.forward();
    entry.remove();
    controller.dispose();
  }

  void _openCart() {
    Navigator.of(context).push(
      slideFadeRoute(const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return Scaffold(
      backgroundColor: FoodPromoTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 126),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: FoodPromoTheme.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const Spacer(),
                    ScaleTransition(
                      scale: _cartBounceController,
                      child: CartIconButton(key: _cartKey, onTap: _openCart),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ScaleTransition(
                  scale: _imageBounceController,
                  child: Hero(
                    tag: widget.food.heroTag,
                    child: Container(
                      key: _imageKey,
                      height: 255,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: widget.food.color.withValues(alpha: 0.22),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: FoodImage(
                        imageUrl: widget.food.imageUrl,
                        borderRadius: 34,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.food.name,
                            style: const TextStyle(
                              color: FoodPromoTheme.ink,
                              fontSize: 30,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: FoodPromoTheme.gold,
                                size: 19,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.food.rating}  |  ${widget.food.restaurant}',
                                style: const TextStyle(
                                  color: FoodPromoTheme.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedPrice(value: _totalPrice, fontSize: 22),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.food.description,
                  style: const TextStyle(
                    color: FoodPromoTheme.muted,
                    fontSize: 14,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(title: l.chooseSize),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(_sizes.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == _sizes.length - 1 ? 0 : 10,
                        ),
                        child: SelectablePill(
                          title: l.optionLabel(_sizes[index].name),
                          subtitle:
                              _sizes[index].priceDelta == 0
                                  ? l.base
                                  : '+${formatRupiah(_sizes[index].priceDelta)}',
                          selected: _selectedSize == index,
                          onTap: () => setState(() => _selectedSize = index),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SectionTitle(title: l.addOns),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      _addonOptions.map((addon) {
                        final selected = _addons.contains(addon.name);
                        return AddonChip(
                          addon: addon,
                          selected: selected,
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _addons.remove(addon.name);
                              } else {
                                _addons.add(addon.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SectionTitle(title: l.quantity),
                    const Spacer(),
                    AnimatedQuantityStepper(
                      value: _quantity,
                      onMinus: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      onPlus: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: AnimatedAddToCartButton(
                loading: _loadingAdd,
                added: _added,
                price: _totalPrice,
                copy: l,
                onTap: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
