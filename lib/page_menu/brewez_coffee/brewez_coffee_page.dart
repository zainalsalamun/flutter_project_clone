import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'brewez_all_menu_page.dart';
import 'brewez_coffee_detail_page.dart';
import 'core/localization/brewez_localization.dart';
import 'core/theme/brewez_theme.dart';
import 'data/models/coffee_addon_model.dart';
import 'data/models/coffee_order_model.dart';
import 'presentation/widgets/animated_coffee_card.dart';
import 'presentation/widgets/brewing_modal.dart';
import 'presentation/widgets/cart_modal_sheet.dart';
import 'presentation/widgets/coffee_filter_modal_sheet.dart';
import 'presentation/widgets/coffee_mood_selector.dart';
import 'presentation/widgets/language_toggle_button.dart';
import 'presentation/widgets/payment_modal_sheet.dart';
import 'presentation/widgets/promo_banner_carousel.dart';
import 'presentation/widgets/quick_customize_sheet.dart';

class BrewezCoffeePage extends StatefulWidget {
  const BrewezCoffeePage({super.key});

  @override
  State<BrewezCoffeePage> createState() => _BrewezCoffeePageState();
}

class _BrewezCoffeePageState extends State<BrewezCoffeePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedCategoryKey = 'all_coffee';
  String _selectedMood = 'all';

  // Search & Filter State
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CoffeeFilterOptions _filterOptions = const CoffeeFilterOptions();

  // Shopping Cart List
  final List<Map<String, dynamic>> _cartItems = [];
  late AnimationController _cartBadgeController;
  late AnimationController _flyingAnimationController;
  Offset _flyingStartOffset = Offset.zero;
  bool _isFlying = false;

  final GlobalKey _cartKey = GlobalKey();

  final List<Map<String, String>> _categories = [
    {'key': 'all_coffee', 'category': 'all'},
    {'key': 'espresso', 'category': 'Espresso'},
    {'key': 'latte', 'category': 'Latte'},
    {'key': 'cappuccino', 'category': 'Cappuccino'},
    {'key': 'macchiato', 'category': 'Macchiato'},
    {'key': 'cold_brew', 'category': 'Cold Brew'},
  ];

  final List<Map<String, dynamic>> _coffees = [
    {
      'name': 'Caramel Macchiato',
      'subtitle': 'Ice, Caramel, Milk Foam',
      'price': 32000,
      'rating': 4.8,
      'category': 'Macchiato',
      'moods': ['focus', 'chill'],
      'image':
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Velvet Oat Latte',
      'subtitle': 'Hot, Creamy Oat Milk',
      'price': 28000,
      'rating': 4.9,
      'category': 'Latte',
      'moods': ['chill', 'focus'],
      'image':
          'https://images.unsplash.com/photo-1541167760496-1628856ab772?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Turkish Spiced Coffee',
      'subtitle': 'Hot, Strong, Cardamom',
      'price': 25000,
      'rating': 4.9,
      'category': 'Espresso',
      'moods': ['energy'],
      'image':
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Classic Double Espresso',
      'subtitle': 'Hot, Intense Blend',
      'price': 22000,
      'rating': 4.7,
      'category': 'Espresso',
      'moods': ['energy', 'focus'],
      'image':
          'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Nitro Cold Brew',
      'subtitle': 'Iced, Velvety Texture',
      'price': 35000,
      'rating': 4.9,
      'category': 'Cold Brew',
      'moods': ['refresh', 'energy'],
      'image':
          'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _cartBadgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.28,
    );

    _flyingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cartBadgeController.dispose();
    _flyingAnimationController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    CoffeeFilterModalSheet.show(
      context,
      currentFilter: _filterOptions,
      onApply: (newFilter) {
        setState(() {
          _filterOptions = newFilter;
        });
      },
    );
  }

  void _navigateToAllMenu({String? initialCategory}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrewezAllMenuPage(
          cartItems: _cartItems,
          initialCategoryKey: initialCategory ?? _selectedCategoryKey,
          onAddToCart: (item) {
            setState(() {});
          },
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  int get _totalCartCount {
    return _cartItems.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int? ?? 1),
    );
  }

  void _openQuickCustomize(Map<String, dynamic> coffee, BuildContext itemContext) {
    // Find tapped item global position
    final renderBox = itemContext.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _flyingStartOffset = renderBox.localToGlobal(Offset.zero);
    } else {
      _flyingStartOffset = const Offset(150, 400);
    }

    QuickCustomizeSheet.show(
      context,
      coffee: coffee,
      onAddToCart: (customizedItem) {
        setState(() {
          _isFlying = true;
          // Check if identical customized item exists
          final existingIndex = _cartItems.indexWhere((item) =>
              item['name'] == customizedItem['name'] &&
              item['size'] == customizedItem['size'] &&
              item['isHot'] == customizedItem['isHot'] &&
              item['sweetness'] == customizedItem['sweetness'] &&
              item['price'] == customizedItem['price']);

          if (existingIndex >= 0) {
            _cartItems[existingIndex]['quantity'] =
                (_cartItems[existingIndex]['quantity'] as int) + 1;
          } else {
            _cartItems.add(customizedItem);
          }
        });

        _flyingAnimationController.forward(from: 0.0).then((_) {
          setState(() {
            _isFlying = false;
          });
          _cartBadgeController.forward().then((_) {
            _cartBadgeController.reverse();
          });
        });

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${customizedItem['name']} ${BrewezLocalization.tr('cart_added_toast')}",
                  ),
                ),
              ],
            ),
            backgroundColor: BrewezTheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1400),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _openCartModal() {
    CartModalSheet.show(
      context,
      cartItems: _cartItems,
      onIncrement: (index) {
        setState(() {
          _cartItems[index]['quantity'] =
              (_cartItems[index]['quantity'] as int) + 1;
        });
      },
      onDecrement: (index) {
        setState(() {
          if ((_cartItems[index]['quantity'] as int) > 1) {
            _cartItems[index]['quantity'] =
                (_cartItems[index]['quantity'] as int) - 1;
          } else {
            _cartItems.removeAt(index);
          }
        });
      },
      onCheckout: () {
        if (_cartItems.isEmpty) return;

        final orderItems = _cartItems.map((item) {
          final addons = item['selectedAddons'] as Set<AddonType>? ?? {};
          return CoffeeOrderItem(
            name: item['name'] as String,
            subtitle: item['subtitle'] as String?,
            image: item['image'] as String?,
            size: item['size'] as String? ?? 'M',
            isHot: item['isHot'] as bool? ?? true,
            sweetness: item['sweetness'] as int? ?? 70,
            selectedAddons: Set<AddonType>.from(addons),
            unitPrice: (item['price'] as num).toDouble(),
            quantity: item['quantity'] as int? ?? 1,
          );
        }).toList();

        PaymentModalSheet.show(
          context,
          items: orderItems,
          onPaymentSuccess: (order) {
            BrewingModal.show(
              context,
              order: order,
              onFinish: () {
                setState(() {
                  _cartItems.clear();
                });
              },
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredCoffees {
    var list = _coffees.where((c) {
      // 1. Category Filter
      final matchesCategory = _selectedCategoryKey == 'all_coffee' ||
          c['category'] ==
              _categories.firstWhere(
                  (cat) => cat['key'] == _selectedCategoryKey)['category'];

      // 2. Mood Filter
      final moods = c['moods'] as List<String>? ?? [];
      final matchesMood =
          _selectedMood == 'all' || moods.contains(_selectedMood);

      // 3. Search Query Filter (name, subtitle, category)
      final q = _searchQuery.toLowerCase();
      final name = (c['name'] as String).toLowerCase();
      final sub = (c['subtitle'] as String).toLowerCase();
      final cat = (c['category'] as String).toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          name.contains(q) ||
          sub.contains(q) ||
          cat.contains(q);

      // 4. Price Range Filter
      final price = (c['price'] as num).toDouble();
      final matchesPrice = price >= _filterOptions.priceRange.start &&
          price <= _filterOptions.priceRange.end;

      // 5. Minimum Rating Filter
      final rating = (c['rating'] as num).toDouble();
      final matchesRating = rating >= _filterOptions.minRating;

      return matchesCategory &&
          matchesMood &&
          matchesSearch &&
          matchesPrice &&
          matchesRating;
    }).toList();

    // 6. Sorting
    switch (_filterOptions.sortBy) {
      case 'price_low':
        list.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'price_high':
        list.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'name':
        list.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'popular':
      default:
        list.sort(
            (a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BrewezLanguage>(
      valueListenable: BrewezLocalization.currentLanguage,
      builder: (context, lang, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9F9FB),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 10),
                    _buildSearchBar(),
                    const SizedBox(height: 14),

                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        children: [
                          // 1. Promo Banner Carousel (Hero Banner at Top)
                          const PromoBannerCarousel(),
                          const SizedBox(height: 18),

                          // 2. Coffee Mood Selector
                          CoffeeMoodSelector(
                            selectedMood: _selectedMood,
                            onMoodSelected: (mood) {
                              setState(() {
                                _selectedMood = mood;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // 3. Categories Chips
                          _buildCategories(),
                          const SizedBox(height: 20),

                          // 4. Popular Brews Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  BrewezLocalization.tr('popular_brews'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: BrewezTheme.textDark,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _navigateToAllMenu(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: BrewezTheme.primary
                                          .withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${BrewezLocalization.tr('see_all')} (${_filteredCoffees.length})',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: BrewezTheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 11,
                                          color: BrewezTheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: _buildCoffeeGrid(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(),
            ),

            // Parabolic Flying Coffee Bean / Particle
            if (_isFlying) _buildFlyingParticle(),
          ],
        );
      },
    );
  }

  Widget _buildFlyingParticle() {
    final screenSize = MediaQuery.of(context).size;
    final cartTargetOffset = Offset(screenSize.width - 45, 60);

    return AnimatedBuilder(
      animation: _flyingAnimationController,
      builder: (context, child) {
        final t = _flyingAnimationController.value;
        // Parabolic curved trajectory
        final currentX = _flyingStartOffset.dx +
            (cartTargetOffset.dx - _flyingStartOffset.dx) * t;
        final currentY = _flyingStartOffset.dy +
            (cartTargetOffset.dy - _flyingStartOffset.dy) * t -
            math.sin(t * math.pi) * 80;
        final scale = 1.0 - (t * 0.4);

        return Positioned(
          left: currentX,
          top: currentY,
          child: Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: BrewezTheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: BrewezTheme.primary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.coffee_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: BrewezTheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      BrewezLocalization.tr('location'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  BrewezLocalization.tr('app_title'),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: BrewezTheme.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Language Switcher & Interactive Clickable Cart
          Row(
            children: [
              const LanguageToggleButton(),
              const SizedBox(width: 12),
              GestureDetector(
                key: _cartKey,
                onTap: _openCartModal,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: BrewezTheme.textDark,
                        size: 22,
                      ),
                    ),
                    if (_totalCartCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: AnimatedBuilder(
                          animation: _cartBadgeController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + _cartBadgeController.value,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: BrewezTheme.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  '$_totalCartCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final activeFilters = _filterOptions.activeFilterCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim();
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: BrewezLocalization.tr('search_hint'),
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            icon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.cancel_rounded,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: _openFilterModal,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BrewezTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: BrewezTheme.primary.withOpacity(0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      if (activeFilters > 0)
                        Positioned(
                          top: 2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2C1810),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$activeFilters',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat['key'] == _selectedCategoryKey;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryKey = cat['key']!;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? BrewezTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? BrewezTheme.primary
                      : Colors.grey.shade200,
                ),
                boxShadow: isSelected
                    ? BrewezTheme.glowShadow(BrewezTheme.primary)
                    : null,
              ),
              child: Text(
                BrewezLocalization.tr(cat['key']!),
                style: TextStyle(
                  color: isSelected ? Colors.white : BrewezTheme.textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoffeeGrid() {
    final list = _filteredCoffees;
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BrewezTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 28,
                color: BrewezTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              BrewezLocalization.tr('search_no_results'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: BrewezTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              BrewezLocalization.tr('search_no_results_sub'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategoryKey = 'all_coffee';
                  _selectedMood = 'all';
                  _filterOptions = const CoffeeFilterOptions();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BrewezTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
              ),
              child: Text(
                BrewezLocalization.tr('reset_filter'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 265,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final coffee = list[index];
          return Builder(
            builder: (itemContext) {
              return AnimatedCoffeeCard(
                key: ValueKey(coffee['name']),
                coffee: coffee,
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, anim1, anim2) =>
                          BrewezCoffeeDetailPage(coffee: coffee),
                      transitionsBuilder: (context, anim1, anim2, child) {
                        return FadeTransition(
                          opacity: anim1,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: anim1,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                onAdd: () => _openQuickCustomize(coffee, itemContext),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.coffee_rounded, 1),
          _buildNavItem(Icons.shopping_bag_rounded, 2),
          _buildNavItem(Icons.favorite_rounded, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          _navigateToAllMenu();
        } else if (index == 2) {
          _openCartModal();
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? BrewezTheme.primary : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isSelected ? 6 : 0,
            height: isSelected ? 6 : 0,
            decoration: const BoxDecoration(
              color: BrewezTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
