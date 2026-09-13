import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDeliveryPromoPage extends StatelessWidget {
  const FoodDeliveryPromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InteractiveCartCubit()),
        BlocProvider(create: (_) => InteractiveLanguageCubit()),
      ],
      child: const _InteractiveFoodOrderingApp(),
    );
  }
}

class _InteractiveFoodOrderingApp extends StatefulWidget {
  const _InteractiveFoodOrderingApp();

  @override
  State<_InteractiveFoodOrderingApp> createState() =>
      _InteractiveFoodOrderingAppState();
}

class _InteractiveFoodOrderingAppState
    extends State<_InteractiveFoodOrderingApp> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);
    final tabs = [
      const _HomeScreen(),
      _SimpleTabScreen(
        title: l.explore,
        icon: Icons.explore_rounded,
        subtitle: l.exploreSubtitle,
      ),
      _OrdersTab(copy: l),
      _FavoritesTab(copy: l),
      _SimpleTabScreen(
        title: l.profile,
        icon: Icons.person_rounded,
        subtitle: l.profileSubtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedTab),
          child: tabs[_selectedTab],
        ),
      ),
      bottomNavigationBar: _AnimatedBottomNav(
        selectedIndex: _selectedTab,
        onChanged: (index) => setState(() => _selectedTab = index),
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  int _selectedCategory = 0;
  String _query = '';
  bool _searchActive = false;
  double _scrollOffset = 0;

  List<String> get _categories => const [
    'All',
    'Burger',
    'Pizza',
    'Chicken',
    'Noodles',
    'Drinks',
    'Dessert',
  ];

  List<FoodItem> get _filteredFoods {
    final selected = _categories[_selectedCategory];
    return _foodItems.where((food) {
      final matchCategory = selected == 'All' || food.category == selected;
      final matchSearch =
          _query.isEmpty ||
          food.name.toLowerCase().contains(_query.toLowerCase()) ||
          food.restaurant.toLowerCase().contains(_query.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
    _searchFocus.addListener(() {
      setState(() => _searchActive = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 260), () {
      if (mounted) setState(() => _query = value);
    });
  }

  void _openDetail(FoodItem food) {
    Navigator.of(context).push(
      _fadeScaleRoute(_withCartCubit(context, _FoodDetailScreen(food: food))),
    );
  }

  void _openCart() {
    Navigator.of(
      context,
    ).push(_slideFadeRoute(_withCartCubit(context, const _CartScreen())));
  }

  @override
  Widget build(BuildContext context) {
    final foods = _filteredFoods;
    final l = _FoodCopy.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _FoodTheme.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.goodEvening,
                            style: const TextStyle(
                              color: _FoodTheme.ink,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.home_rounded,
                                color: _FoodTheme.orange,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                l.deliverToHome,
                                style: const TextStyle(
                                  color: _FoodTheme.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _CartIconButton(onTap: _openCart),
                    const SizedBox(width: 10),
                    const _LanguageToggle(),
                  ],
                ),
                const SizedBox(height: 18),
                _AnimatedSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  active: _searchActive || _query.isNotEmpty,
                  onChanged: _onSearchChanged,
                  hintText: l.searchFood,
                ),
              ],
            ),
          ),
          _AnimatedCategoryBar(
            categories: _categories,
            selectedIndex: _selectedCategory,
            onChanged: (index) => setState(() => _selectedCategory = index),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: ListView.builder(
                key: ValueKey('$_selectedCategory-$_query-${foods.length}'),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  final cardCenter = index * 202.0 + 101.0;
                  final viewportCenter =
                      _scrollOffset + MediaQuery.of(context).size.height * 0.42;
                  final distance = (cardCenter - viewportCenter).abs();
                  final scale = (1 - (distance / 1900)).clamp(0.91, 1.0);
                  final parallax = ((viewportCenter - cardCenter) / 26).clamp(
                    -12.0,
                    12.0,
                  );

                  return _AnimatedFoodCard(
                    food: food,
                    scale: scale.toDouble(),
                    parallax: parallax.toDouble(),
                    onTap: () => _openDetail(food),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodDetailScreen extends StatefulWidget {
  const _FoodDetailScreen({required this.food});

  final FoodItem food;

  @override
  State<_FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<_FoodDetailScreen>
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

  final List<_SizeOption> _sizes = const [
    _SizeOption('Regular', 0),
    _SizeOption('Large', 5000),
    _SizeOption('Extra Large', 9000),
  ];

  final List<_AddonOption> _addonOptions = const [
    _AddonOption('Extra Cheese', 6000),
    _AddonOption('Egg', 5000),
    _AddonOption('Beef', 10000),
    _AddonOption('Sauce', 3000),
  ];

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
    context.read<InteractiveCartCubit>().addItem(
      food: widget.food,
      quantity: _quantity,
      unitPrice: _unitPrice,
      size: _sizes[_selectedSize].name,
      addons: _addons.toList(),
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
                      child: _FoodImage(
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
    Navigator.of(
      context,
    ).push(_slideFadeRoute(_withCartCubit(context, const _CartScreen())));
  }

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
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
                        foregroundColor: _FoodTheme.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const Spacer(),
                    ScaleTransition(
                      scale: _cartBounceController,
                      child: _CartIconButton(key: _cartKey, onTap: _openCart),
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
                      child: _FoodImage(
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
                              color: _FoodTheme.ink,
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
                                color: _FoodTheme.gold,
                                size: 19,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.food.rating}  |  ${widget.food.restaurant}',
                                style: const TextStyle(
                                  color: _FoodTheme.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _AnimatedPrice(value: _totalPrice, fontSize: 22),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.food.description,
                  style: const TextStyle(
                    color: _FoodTheme.muted,
                    fontSize: 14,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: l.chooseSize),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(_sizes.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == _sizes.length - 1 ? 0 : 10,
                        ),
                        child: _SelectablePill(
                          title: l.optionLabel(_sizes[index].name),
                          subtitle:
                              _sizes[index].priceDelta == 0
                                  ? l.base
                                  : '+${_formatRupiah(_sizes[index].priceDelta)}',
                          selected: _selectedSize == index,
                          onTap: () => setState(() => _selectedSize = index),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: l.addOns),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      _addonOptions.map((addon) {
                        final selected = _addons.contains(addon.name);
                        return _AddonChip(
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
                    _SectionTitle(title: l.quantity),
                    const Spacer(),
                    _AnimatedQuantityStepper(
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
              child: _AnimatedAddToCartButton(
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

class _CartScreen extends StatelessWidget {
  const _CartScreen();

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _FoodTheme.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l.cart,
                    style: TextStyle(
                      color: _FoodTheme.ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<InteractiveCartCubit, InteractiveCartState>(
                builder: (context, state) {
                  if (state.items.isEmpty) {
                    return const _EmptyCart();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _AnimatedCartItem(
                        key: ValueKey(item.key),
                        item: item,
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<InteractiveCartCubit, InteractiveCartState>(
              builder: (context, state) {
                if (state.items.isEmpty) return const SizedBox.shrink();
                return _CartSummary(
                  state: state,
                  copy: l,
                  onCheckout: () {
                    Navigator.of(context).push(
                      _rightSlideRoute(
                        _withCartCubit(context, const _CheckoutScreen()),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutScreen extends StatefulWidget {
  const _CheckoutScreen();

  @override
  State<_CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<_CheckoutScreen> {
  bool _placingOrder = false;
  bool _success = false;

  Future<void> _placeOrder() async {
    if (_placingOrder) return;
    setState(() => _placingOrder = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _success = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      _fadeScaleRoute(_withCartCubit(context, const _SuccessScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 134),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _FoodTheme.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l.checkout,
                      style: TextStyle(
                        color: _FoodTheme.ink,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _CheckoutTile(
                  icon: Icons.location_on_rounded,
                  title: l.deliveryAddress,
                  subtitle: l.addressValue,
                ),
                _CheckoutTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: l.paymentMethod,
                  subtitle: l.paymentValue,
                ),
                _CheckoutTile(
                  icon: Icons.local_offer_rounded,
                  title: l.promo,
                  subtitle: l.promoValue,
                ),
                const SizedBox(height: 12),
                BlocBuilder<InteractiveCartCubit, InteractiveCartState>(
                  builder: (context, state) {
                    return _CartSummaryCard(state: state, copy: l);
                  },
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: BlocBuilder<InteractiveCartCubit, InteractiveCartState>(
                builder: (context, state) {
                  return _AnimatedCheckoutButton(
                    placingOrder: _placingOrder,
                    success: _success,
                    total: state.total,
                    copy: l,
                    onTap: _placeOrder,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessScreen extends StatefulWidget {
  const _SuccessScreen();

  @override
  State<_SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<_SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut,
                ),
                child: CustomPaint(
                  size: const Size(126, 126),
                  painter: _CheckmarkPainter(progress: _controller),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _controller,
                child: Column(
                  children: [
                    Text(
                      l.orderConfirmed,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _FoodTheme.ink,
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.foodPrepared,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _FoodTheme.muted,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '#ORD-102938',
                      style: TextStyle(
                        color: _FoodTheme.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      _fadeScaleRoute(
                        _withCartCubit(context, const _TrackingScreen()),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _FoodTheme.ink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(
                    l.trackOrder,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.read<InteractiveCartCubit>().clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(l.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackingScreen extends StatefulWidget {
  const _TrackingScreen();

  @override
  State<_TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<_TrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Scaffold(
      backgroundColor: _FoodTheme.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _FoodTheme.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(height: 24),
              Text(
                l.orderTracking,
                style: TextStyle(
                  color: _FoodTheme.ink,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.trackingSubtitle,
                style: TextStyle(
                  color: _FoodTheme.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _OrderProgressPainter(
                        progress: _controller.value,
                        steps: l.trackingSteps,
                      ),
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedFoodCard extends StatefulWidget {
  const _AnimatedFoodCard({
    required this.food,
    required this.scale,
    required this.parallax,
    required this.onTap,
  });

  final FoodItem food;
  final double scale;
  final double parallax;
  final VoidCallback onTap;

  @override
  State<_AnimatedFoodCard> createState() => _AnimatedFoodCardState();
}

class _AnimatedFoodCardState extends State<_AnimatedFoodCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _favorite = false;
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() => _favorite = !_favorite);
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale * (_pressed ? 0.96 : 1.0);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Future<void>.delayed(const Duration(milliseconds: 80), widget.onTap);
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 190),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 186,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.food.color.withValues(alpha: 0.11),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.food.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.food.category,
                            style: TextStyle(
                              color: widget.food.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _AnimatedFavorite(
                          selected: _favorite,
                          controller: _heartController,
                          onTap: _toggleFavorite,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _FoodTheme.ink,
                        fontSize: 21,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      widget.food.restaurant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _FoodTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: _FoodTheme.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.food.rating}',
                          style: const TextStyle(
                            color: _FoodTheme.ink,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatRupiah(widget.food.price),
                          style: const TextStyle(
                            color: _FoodTheme.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(0, widget.parallax),
                        child: Hero(
                          tag: widget.food.heroTag,
                          child: _FoodImage(
                            imageUrl: widget.food.imageUrl,
                            borderRadius: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _FoodTheme.ink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedSearchBar extends StatelessWidget {
  const _AnimatedSearchBar({
    required this.controller,
    required this.focusNode,
    required this.active,
    required this.onChanged,
    required this.hintText,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool active;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: 56,
      padding: EdgeInsets.only(left: active ? 18 : 16, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(active ? 21 : 18),
        border: Border.all(
          color: active ? _FoodTheme.orange : Colors.transparent,
          width: active ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: active ? 0.1 : 0.045),
            blurRadius: active ? 24 : 12,
            offset: Offset(0, active ? 13 : 6),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Icon(
              active ? Icons.search_rounded : Icons.search_outlined,
              key: ValueKey(active),
              color: active ? _FoodTheme.orange : _FoodTheme.muted,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: _FoodTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: active ? 38 : 34,
            height: active ? 38 : 34,
            decoration: BoxDecoration(
              color: active ? _FoodTheme.orange : _FoodTheme.softOrange,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: active ? Colors.white : _FoodTheme.orange,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCategoryBar extends StatelessWidget {
  const _AnimatedCategoryBar({
    required this.categories,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: selected ? 22 : 15,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: selected ? _FoodTheme.ink : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? _FoodTheme.ink : const Color(0xFFFFD9B7),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  color: selected ? Colors.white : _FoodTheme.muted,
                  fontSize: selected ? 14 : 13,
                  fontWeight: FontWeight.w900,
                ),
                child: Text(l.category(categories[index])),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }
}

class _CartIconButton extends StatelessWidget {
  const _CartIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_bag_rounded, color: _FoodTheme.ink),
            Positioned(
              top: 7,
              right: 7,
              child: BlocBuilder<InteractiveCartCubit, InteractiveCartState>(
                buildWhen:
                    (previous, current) =>
                        previous.totalQuantity != current.totalQuantity,
                builder: (context, state) {
                  return _AnimatedCartBadge(value: state.totalQuantity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InteractiveLanguageCubit, FoodLanguage>(
      builder: (context, language) {
        final isIndonesian = language == FoodLanguage.id;
        return GestureDetector(
          onTap: () => context.read<InteractiveLanguageCubit>().toggle(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: 58,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isIndonesian ? _FoodTheme.ink : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isIndonesian ? _FoodTheme.ink : const Color(0xFFFFD9B7),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                isIndonesian ? 'ID' : 'EN',
                key: ValueKey(language),
                style: TextStyle(
                  color: isIndonesian ? Colors.white : _FoodTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedCartBadge extends StatelessWidget {
  const _AnimatedCartBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 330),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 70),
            TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
          ]).animate(animation),
          child: child,
        );
      },
      child:
          value == 0
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : Container(
                key: ValueKey(value),
                width: 19,
                height: 19,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _FoodTheme.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
    );
  }
}

class _AnimatedFavorite extends StatelessWidget {
  const _AnimatedFavorite({
    required this.selected,
    required this.controller,
    required this.onTap,
  });

  final bool selected;
  final AnimationController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final burst = math.sin(controller.value * math.pi);
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ...List.generate(5, (index) {
                final angle = (index / 5) * math.pi * 2;
                return Positioned(
                  left: math.cos(angle) * burst * 17 + 15,
                  top: math.sin(angle) * burst * 17 + 15,
                  child: Opacity(
                    opacity: selected ? (1 - controller.value) : 0,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: _FoodTheme.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
              Transform.scale(
                scale: 1 + burst * 0.28,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 210),
                  child: Icon(
                    selected ? Icons.favorite_rounded : Icons.favorite_border,
                    key: ValueKey(selected),
                    color: selected ? _FoodTheme.orange : _FoodTheme.muted,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.04 : 1,
        duration: const Duration(milliseconds: 210),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected ? _FoodTheme.ink : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _FoodTheme.ink : const Color(0xFFFFD9B7),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : _FoodTheme.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: selected ? Colors.white70 : _FoodTheme.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddonChip extends StatelessWidget {
  const _AddonChip({
    required this.addon,
    required this.selected,
    required this.onTap,
  });

  final _AddonOption addon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1,
        duration: const Duration(milliseconds: 210),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _FoodTheme.softOrange : Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? _FoodTheme.orange : const Color(0xFFFFD9B7),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.add_circle_outline,
                  key: ValueKey(selected),
                  color: selected ? _FoodTheme.orange : _FoodTheme.muted,
                  size: 18,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '${l.optionLabel(addon.name)}  +${_formatRupiah(addon.price)}',
                style: const TextStyle(
                  color: _FoodTheme.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedQuantityStepper extends StatelessWidget {
  const _AnimatedQuantityStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundIconButton(icon: Icons.remove_rounded, onTap: onMinus),
          SizedBox(
            width: 48,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: TweenSequence<double>([
                    TweenSequenceItem(
                      tween: Tween(begin: 0.8, end: 1.3),
                      weight: 60,
                    ),
                    TweenSequenceItem(
                      tween: Tween(begin: 1.3, end: 1.0),
                      weight: 40,
                    ),
                  ]).animate(animation),
                  child: child,
                );
              },
              child: Text(
                '$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _FoodTheme.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _RoundIconButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: _FoodTheme.ink,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _AnimatedPrice extends StatelessWidget {
  const _AnimatedPrice({required this.value, this.fontSize = 17});

  final int value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween(begin: value.toDouble() * 0.94, end: value.toDouble()),
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Text(
          _formatRupiah(animatedValue.round()),
          style: TextStyle(
            color: _FoodTheme.orange,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        );
      },
    );
  }
}

class _AnimatedAddToCartButton extends StatelessWidget {
  const _AnimatedAddToCartButton({
    required this.loading,
    required this.added,
    required this.price,
    required this.copy,
    required this.onTap,
  });

  final bool loading;
  final bool added;
  final int price;
  final _FoodCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        loading ? copy.loading : (added ? copy.addedToCart : copy.addToCart);
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: added ? _FoodTheme.green : _FoodTheme.ink,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (added ? _FoodTheme.green : _FoodTheme.ink).withValues(
                alpha: 0.22,
              ),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 230),
              child: Icon(
                loading
                    ? Icons.hourglass_top_rounded
                    : added
                    ? Icons.check_circle_rounded
                    : Icons.shopping_bag_rounded,
                key: ValueKey(label),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            _AnimatedPrice(value: price, fontSize: 16),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCartItem extends StatelessWidget {
  const _AnimatedCartItem({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Transform.scale(scale: 0.95 + value * 0.05, child: child),
          ),
        );
      },
      child: Dismissible(
        key: ValueKey('dismiss-${item.key}'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        onDismissed: (_) {
          context.read<InteractiveCartCubit>().removeItem(item.key);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: _FoodImage(
                  imageUrl: item.food.imageUrl,
                  borderRadius: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _FoodTheme.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l.optionLabel(item.size)}  ${item.addons.isEmpty ? '' : '+ ${item.addons.length} ${l.addOnsLower}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _FoodTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AnimatedPrice(value: item.total, fontSize: 14),
                  ],
                ),
              ),
              _AnimatedQuantityStepper(
                value: item.quantity,
                onMinus:
                    () =>
                        context.read<InteractiveCartCubit>().decrease(item.key),
                onPlus:
                    () =>
                        context.read<InteractiveCartCubit>().increase(item.key),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.state,
    required this.copy,
    required this.onCheckout,
  });

  final InteractiveCartState state;
  final _FoodCopy copy;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRow(label: copy.subtotal, value: state.subtotal),
          _SummaryRow(label: copy.delivery, value: state.deliveryFee),
          _SummaryRow(label: copy.serviceFee, value: state.serviceFee),
          _SummaryRow(label: copy.discount, value: -state.discount),
          const Divider(height: 22),
          _SummaryRow(label: copy.total, value: state.total, strong: true),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onCheckout,
              style: FilledButton.styleFrom(
                backgroundColor: _FoodTheme.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                copy.checkout,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({required this.state, required this.copy});

  final InteractiveCartState state;
  final _FoodCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ...state.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.food.name} x${item.quantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _FoodTheme.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _AnimatedPrice(value: item.total, fontSize: 13),
                ],
              ),
            ),
          ),
          const Divider(height: 22),
          _SummaryRow(label: copy.total, value: state.total, strong: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final int value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: strong ? _FoodTheme.ink : _FoodTheme.muted,
              fontSize: strong ? 16 : 13,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const Spacer(),
          _AnimatedPrice(value: value, fontSize: strong ? 18 : 13),
        ],
      ),
    );
  }
}

class _CheckoutTile extends StatelessWidget {
  const _CheckoutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _FoodTheme.softOrange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _FoodTheme.orange),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _FoodTheme.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _FoodTheme.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _FoodTheme.muted),
        ],
      ),
    );
  }
}

class _AnimatedCheckoutButton extends StatelessWidget {
  const _AnimatedCheckoutButton({
    required this.placingOrder,
    required this.success,
    required this.total,
    required this.copy,
    required this.onTap,
  });

  final bool placingOrder;
  final bool success;
  final int total;
  final _FoodCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        placingOrder
            ? (success ? copy.success : copy.loading)
            : copy.placeOrder;
    return GestureDetector(
      onTap: placingOrder ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: success ? _FoodTheme.green : _FoodTheme.ink,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Icon(
                success
                    ? Icons.check_circle_rounded
                    : placingOrder
                    ? Icons.hourglass_bottom_rounded
                    : Icons.receipt_long_rounded,
                key: ValueKey(label),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            _AnimatedPrice(value: total, fontSize: 16),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBottomNav extends StatelessWidget {
  const _AnimatedBottomNav({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);
    final items = [
      (Icons.home_rounded, l.home),
      (Icons.explore_rounded, l.explore),
      (Icons.receipt_long_rounded, l.orders),
      (Icons.favorite_rounded, l.favorites),
      (Icons.person_rounded, l.profile),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      height: 72,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _FoodTheme.ink,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _FoodTheme.ink.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = selectedIndex == index;
          final item = items[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.12 : 0.9,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        item.$1,
                        color: selected ? _FoodTheme.orange : Colors.white54,
                        size: 23,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          selected
                              ? Text(
                                item.$2,
                                key: ValueKey(item.$2),
                                style: const TextStyle(
                                  color: _FoodTheme.ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                              : const SizedBox(
                                height: 0,
                                key: ValueKey('empty'),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  const _FoodImage({required this.imageUrl, required this.borderRadius});

  final String imageUrl;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              color: _FoodTheme.softOrange,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _FoodTheme.orange,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: _FoodTheme.softOrange,
              child: const Icon(
                Icons.fastfood_rounded,
                color: _FoodTheme.orange,
              ),
            ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _FoodTheme.ink,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final l = _FoodCopy.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: _FoodTheme.softOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: _FoodTheme.orange,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l.cartEmpty,
              style: TextStyle(
                color: _FoodTheme.ink,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.cartEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _FoodTheme.muted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleTabScreen extends StatelessWidget {
  const _SimpleTabScreen({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  final String title;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: _FoodTheme.softOrange,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _FoodTheme.orange, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: _FoodTheme.ink,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _FoodTheme.muted,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.copy});

  final _FoodCopy copy;

  @override
  Widget build(BuildContext context) {
    return _SimpleTabScreen(
      title: copy.orders,
      icon: Icons.receipt_long_rounded,
      subtitle: copy.ordersSubtitle,
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab({required this.copy});

  final _FoodCopy copy;

  @override
  Widget build(BuildContext context) {
    return _SimpleTabScreen(
      title: copy.favorites,
      icon: Icons.favorite_rounded,
      subtitle: copy.favoritesSubtitle,
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({required this.progress}) : super(repaint: progress);

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = _FoodTheme.green
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8;
    final fill =
        Paint()
          ..color = _FoodTheme.green.withValues(alpha: 0.12)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, fill);
    final path =
        Path()
          ..moveTo(size.width * 0.28, size.height * 0.53)
          ..lineTo(size.width * 0.44, size.height * 0.68)
          ..lineTo(size.width * 0.74, size.height * 0.36);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress.value),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) => true;
}

class _OrderProgressPainter extends CustomPainter {
  _OrderProgressPainter({required this.progress, required this.steps});

  final double progress;
  final List<String> steps;

  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * 0.18;
    final top = 34.0;
    final bottom = size.height - 52;
    final gap = (bottom - top) / (steps.length - 1);
    final linePaint =
        Paint()
          ..color = const Color(0xFFFFD9B7)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
    final activePaint =
        Paint()
          ..color = _FoodTheme.orange
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, top), Offset(left, bottom), linePaint);
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + (bottom - top) * progress),
      activePaint,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < steps.length; i++) {
      final y = top + gap * i;
      final stepProgress = (progress * (steps.length - 1));
      final active = stepProgress >= i;
      final pulse =
          active && (stepProgress - i).abs() < 0.7
              ? math.sin(progress * math.pi * 16).abs()
              : 0.0;
      canvas.drawCircle(
        Offset(left, y),
        17 + pulse * 4,
        Paint()..color = active ? _FoodTheme.orange : Colors.white,
      );
      canvas.drawCircle(
        Offset(left, y),
        17,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = active ? _FoodTheme.orange : const Color(0xFFFFD9B7),
      );
      textPainter.text = TextSpan(
        text: steps[i],
        style: TextStyle(
          color: active ? _FoodTheme.ink : _FoodTheme.muted,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      );
      textPainter.layout(maxWidth: size.width - left - 56);
      textPainter.paint(canvas, Offset(left + 42, y - 12));
    }

    final driverY = top + (bottom - top) * progress;
    final driverRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(left - 4, driverY), width: 44, height: 44),
      const Radius.circular(16),
    );
    canvas.drawRRect(driverRect, Paint()..color = _FoodTheme.ink);
    const icon = Icons.delivery_dining_rounded;
    final builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(fontFamily: icon.fontFamily, fontSize: 24),
    )..addText(String.fromCharCode(icon.codePoint));
    final paragraph =
        builder.build()..layout(const ui.ParagraphConstraints(width: 30));
    canvas.drawParagraph(paragraph, Offset(left - 17, driverY - 15));
  }

  @override
  bool shouldRepaint(covariant _OrderProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

Route<T> _fadeScaleRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

Route<T> _slideFadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 380),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

Route<T> _rightSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 420),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}

Widget _withCartCubit(BuildContext context, Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider.value(value: context.read<InteractiveCartCubit>()),
      BlocProvider.value(value: context.read<InteractiveLanguageCubit>()),
    ],
    child: child,
  );
}

String _formatRupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${negative ? '-' : ''}Rp ${buffer.toString()}';
}

enum FoodLanguage { id, en }

class InteractiveLanguageCubit extends Cubit<FoodLanguage> {
  InteractiveLanguageCubit() : super(FoodLanguage.id);

  void toggle() {
    emit(state == FoodLanguage.id ? FoodLanguage.en : FoodLanguage.id);
  }
}

class _FoodCopy {
  const _FoodCopy._(this.language);

  final FoodLanguage language;

  static _FoodCopy of(BuildContext context) {
    return _FoodCopy._(context.watch<InteractiveLanguageCubit>().state);
  }

  bool get _id => language == FoodLanguage.id;

  String get goodEvening => _id ? 'Selamat malam' : 'Good evening';
  String get deliverToHome => _id ? 'Antar ke Rumah' : 'Deliver to Home';
  String get searchFood => _id ? 'Cari makanan...' : 'Search food...';
  String get explore => _id ? 'Jelajahi' : 'Explore';
  String get exploreSubtitle =>
      _id
          ? 'Temukan restoran populer dan makanan pilihan.'
          : 'Discover trending restaurants and curated meals.';
  String get profile => _id ? 'Profil' : 'Profile';
  String get profileSubtitle =>
      _id
          ? 'Kelola alamat, pembayaran, voucher, dan preferensi.'
          : 'Manage address, payment, vouchers, and preferences.';
  String get home => _id ? 'Beranda' : 'Home';
  String get orders => _id ? 'Pesanan' : 'Orders';
  String get ordersSubtitle =>
      _id
          ? 'Pesanan aktif dan riwayat food delivery tampil di sini.'
          : 'Your active and past food delivery orders appear here.';
  String get favorites => _id ? 'Favorit' : 'Favorites';
  String get favoritesSubtitle =>
      _id
          ? 'Makanan yang kamu sukai akan terkumpul di tab ini.'
          : 'Food items you love will be collected in this tab.';
  String get chooseSize => _id ? 'Pilih ukuran' : 'Choose size';
  String get base => _id ? 'Dasar' : 'Base';
  String get addOns => _id ? 'Tambahan' : 'Add-ons';
  String get addOnsLower => _id ? 'tambahan' : 'add-ons';
  String get quantity => _id ? 'Jumlah' : 'Quantity';
  String get addToCart => _id ? 'Tambah ke Keranjang' : 'Add to Cart';
  String get addedToCart => _id ? 'Masuk keranjang' : 'Added to cart';
  String get loading => _id ? 'Memproses' : 'Loading';
  String get cart => _id ? 'Keranjang' : 'Cart';
  String get checkout => _id ? 'Checkout' : 'Checkout';
  String get deliveryAddress => _id ? 'Alamat Pengiriman' : 'Delivery Address';
  String get addressValue =>
      _id
          ? 'Rumah - Jl. Jendral Sudirman No. 45'
          : 'Home - Jl. Jendral Sudirman No. 45';
  String get paymentMethod => _id ? 'Metode Pembayaran' : 'Payment Method';
  String get paymentValue =>
      _id ? 'Saldo QRIS FoodPay' : 'QRIS FoodPay balance';
  String get promo => _id ? 'Promo' : 'Promo';
  String get promoValue =>
      _id ? 'WEEKENDMEAL digunakan' : 'WEEKENDMEAL applied';
  String get subtotal => _id ? 'Subtotal' : 'Subtotal';
  String get delivery => _id ? 'Ongkir' : 'Delivery';
  String get serviceFee => _id ? 'Biaya Layanan' : 'Service Fee';
  String get discount => _id ? 'Diskon' : 'Discount';
  String get total => _id ? 'Total' : 'Total';
  String get placeOrder => _id ? 'Buat Pesanan' : 'Place Order';
  String get success => _id ? 'Berhasil' : 'Success';
  String get orderConfirmed => _id ? 'Pesanan Dikonfirmasi' : 'Order Confirmed';
  String get foodPrepared =>
      _id ? 'Makananmu sedang disiapkan.' : 'Your food is being prepared.';
  String get trackOrder => _id ? 'Lacak Pesanan' : 'Track Order';
  String get backToHome => _id ? 'Kembali ke beranda' : 'Back to home';
  String get orderTracking => _id ? 'Lacak Pesanan' : 'Order Tracking';
  String get trackingSubtitle =>
      _id
          ? 'Driver bergerak mengikuti setiap tahap persiapan.'
          : 'Driver is moving through each preparation step.';
  List<String> get trackingSteps =>
      _id
          ? ['Dikonfirmasi', 'Disiapkan', 'Siap', 'Diantar', 'Terkirim']
          : ['Confirmed', 'Preparing', 'Ready', 'On The Way', 'Delivered'];
  String get cartEmpty => _id ? 'Keranjang kosong' : 'Cart is empty';
  String get cartEmptySubtitle =>
      _id
          ? 'Tap kartu makanan, atur pesanan, lalu lihat makanan terbang ke keranjang.'
          : 'Tap a food card, customize it, and watch it fly into your cart.';

  String category(String value) {
    if (!_id) return value;
    return switch (value) {
      'All' => 'Semua',
      'Burger' => 'Burger',
      'Pizza' => 'Pizza',
      'Chicken' => 'Ayam',
      'Noodles' => 'Mie',
      'Drinks' => 'Minuman',
      'Dessert' => 'Dessert',
      _ => value,
    };
  }

  String optionLabel(String value) {
    if (!_id) return value;
    return switch (value) {
      'Regular' => 'Reguler',
      'Large' => 'Besar',
      'Extra Large' => 'Ekstra Besar',
      'Extra Cheese' => 'Keju Ekstra',
      'Egg' => 'Telur',
      'Beef' => 'Daging',
      'Sauce' => 'Saus',
      _ => value,
    };
  }
}

class InteractiveCartCubit extends Cubit<InteractiveCartState> {
  InteractiveCartCubit() : super(const InteractiveCartState(items: []));

  void addItem({
    required FoodItem food,
    required int quantity,
    required int unitPrice,
    required String size,
    required List<String> addons,
  }) {
    final key = '${food.id}-$size-${addons.join(',')}';
    final items = [...state.items];
    final index = items.indexWhere((item) => item.key == key);
    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      items.add(
        CartItem(
          key: key,
          food: food,
          quantity: quantity,
          unitPrice: unitPrice,
          size: size,
          addons: addons,
        ),
      );
    }
    emit(InteractiveCartState(items: items));
  }

  void increase(String key) {
    emit(
      InteractiveCartState(
        items:
            state.items
                .map(
                  (item) =>
                      item.key == key
                          ? item.copyWith(quantity: item.quantity + 1)
                          : item,
                )
                .toList(),
      ),
    );
  }

  void decrease(String key) {
    final items =
        state.items
            .map(
              (item) =>
                  item.key == key
                      ? item.copyWith(quantity: item.quantity - 1)
                      : item,
            )
            .where((item) => item.quantity > 0)
            .toList();
    emit(InteractiveCartState(items: items));
  }

  void removeItem(String key) {
    emit(
      InteractiveCartState(
        items: state.items.where((item) => item.key != key).toList(),
      ),
    );
  }

  void clear() => emit(const InteractiveCartState(items: []));
}

class InteractiveCartState {
  const InteractiveCartState({required this.items});

  final List<CartItem> items;

  int get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get deliveryFee => items.isEmpty ? 0 : 12000;
  int get serviceFee => items.isEmpty ? 0 : 5000;
  int get discount => items.isEmpty ? 0 : 10000;
  int get total => subtotal + deliveryFee + serviceFee - discount;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartItem {
  const CartItem({
    required this.key,
    required this.food,
    required this.quantity,
    required this.unitPrice,
    required this.size,
    required this.addons,
  });

  final String key;
  final FoodItem food;
  final int quantity;
  final int unitPrice;
  final String size;
  final List<String> addons;

  int get total => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      key: key,
      food: food,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
      size: size,
      addons: addons,
    );
  }
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.category,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.color,
  });

  final String id;
  final String name;
  final String restaurant;
  final String category;
  final double rating;
  final int price;
  final String imageUrl;
  final String description;
  final Color color;

  String get heroTag => 'food-image-$id';
}

class _SizeOption {
  const _SizeOption(this.name, this.priceDelta);

  final String name;
  final int priceDelta;
}

class _AddonOption {
  const _AddonOption(this.name, this.price);

  final String name;
  final int price;
}

class _FoodTheme {
  static const Color cream = Color(0xFFFFF7ED);
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color orange = Color(0xFFFF7A1A);
  static const Color softOrange = Color(0xFFFFE6CF);
  static const Color green = Color(0xFF10B981);
  static const Color gold = Color(0xFFF59E0B);
}

const List<FoodItem> _foodItems = [
  FoodItem(
    id: 'classic-burger',
    name: 'Classic Burger',
    restaurant: 'Burger District',
    category: 'Burger',
    rating: 4.8,
    price: 35000,
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=900&auto=format&fit=crop',
    description:
        'Juicy grilled beef patty with melted cheese, fresh lettuce, tomato, onion, and a signature smoky sauce.',
    color: Color(0xFFFF7A1A),
  ),
  FoodItem(
    id: 'pepperoni-pizza',
    name: 'Pepperoni Pizza',
    restaurant: 'Slice Society',
    category: 'Pizza',
    rating: 4.7,
    price: 52000,
    imageUrl:
        'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=900&auto=format&fit=crop',
    description:
        'Crispy thin crust pizza layered with tomato sauce, mozzarella, and spicy pepperoni slices.',
    color: Color(0xFFEF4444),
  ),
  FoodItem(
    id: 'crispy-chicken',
    name: 'Crispy Chicken',
    restaurant: 'Golden Coop',
    category: 'Chicken',
    rating: 4.9,
    price: 42000,
    imageUrl:
        'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?q=80&w=900&auto=format&fit=crop',
    description:
        'Crunchy fried chicken with herbs, spicy mayo dip, and soft potato wedges on the side.',
    color: Color(0xFFF59E0B),
  ),
  FoodItem(
    id: 'ramen-noodles',
    name: 'Spicy Ramen',
    restaurant: 'Noodle Lab',
    category: 'Noodles',
    rating: 4.6,
    price: 39000,
    imageUrl:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=900&auto=format&fit=crop',
    description:
        'Warm ramen bowl with springy noodles, chili broth, soft egg, scallion, and roasted chicken.',
    color: Color(0xFFDC2626),
  ),
  FoodItem(
    id: 'iced-matcha',
    name: 'Iced Matcha Latte',
    restaurant: 'Leaf & Cream',
    category: 'Drinks',
    rating: 4.5,
    price: 25000,
    imageUrl:
        'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?q=80&w=900&auto=format&fit=crop',
    description:
        'Cold creamy matcha latte with milk foam, balanced sweetness, and a clean earthy finish.',
    color: Color(0xFF10B981),
  ),
  FoodItem(
    id: 'berry-waffle',
    name: 'Berry Waffle',
    restaurant: 'Sweet Studio',
    category: 'Dessert',
    rating: 4.8,
    price: 31000,
    imageUrl:
        'https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=900&auto=format&fit=crop',
    description:
        'Golden waffle with whipped cream, fresh berries, maple drizzle, and crushed almond.',
    color: Color(0xFFEC4899),
  ),
];
