import 'package:flutter/material.dart';
import 'brewez_coffee_detail_page.dart';
import 'core/localization/brewez_localization.dart';
import 'core/theme/brewez_theme.dart';
import 'core/utils/brewez_currency.dart';
import 'data/models/coffee_addon_model.dart';
import 'data/models/coffee_order_model.dart';
import 'presentation/widgets/brewing_modal.dart';
import 'presentation/widgets/cart_modal_sheet.dart';
import 'presentation/widgets/coffee_filter_modal_sheet.dart';
import 'presentation/widgets/payment_modal_sheet.dart';
import 'presentation/widgets/quick_customize_sheet.dart';

class BrewezAllMenuPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic> item)? onAddToCart;
  final String? initialCategoryKey;

  const BrewezAllMenuPage({
    super.key,
    required this.cartItems,
    this.onAddToCart,
    this.initialCategoryKey,
  });

  @override
  State<BrewezAllMenuPage> createState() => _BrewezAllMenuPageState();
}

class _BrewezAllMenuPageState extends State<BrewezAllMenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryKey = 'all_coffee';
  bool _isGridView = true;
  CoffeeFilterOptions _filterOptions = const CoffeeFilterOptions();

  final List<Map<String, String>> _categories = [
    {'key': 'all_coffee', 'category': 'all'},
    {'key': 'espresso', 'category': 'Espresso'},
    {'key': 'latte', 'category': 'Latte'},
    {'key': 'cappuccino', 'category': 'Cappuccino'},
    {'key': 'macchiato', 'category': 'Macchiato'},
    {'key': 'cold_brew', 'category': 'Cold Brew'},
  ];

  final List<Map<String, dynamic>> _allCoffees = [
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
    {
      'name': 'Vanilla Bean Cappuccino',
      'subtitle': 'Hot, Fluffy Foam, Vanilla',
      'price': 29000,
      'rating': 4.8,
      'category': 'Cappuccino',
      'moods': ['chill', 'focus'],
      'image':
          'https://images.unsplash.com/photo-1534778101976-62847782c213?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Spanish Iced Latte',
      'subtitle': 'Iced, Sweet Condensed Milk',
      'price': 31000,
      'rating': 4.8,
      'category': 'Latte',
      'moods': ['refresh', 'chill'],
      'image':
          'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Hazelnut Cold Brew',
      'subtitle': 'Iced, Roasted Hazelnut Note',
      'price': 34000,
      'rating': 4.7,
      'category': 'Cold Brew',
      'moods': ['refresh', 'energy'],
      'image':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Cinnamon Honey Cappuccino',
      'subtitle': 'Hot, Wild Honey & Spice',
      'price': 30000,
      'rating': 4.9,
      'category': 'Cappuccino',
      'moods': ['chill'],
      'image':
          'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Mocha Macchiato Deluxe',
      'subtitle': 'Hot, Dark Chocolate & Crema',
      'price': 33000,
      'rating': 4.8,
      'category': 'Macchiato',
      'moods': ['energy', 'chill'],
      'image':
          'https://images.unsplash.com/photo-1559496417-e7f25cb247f3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryKey != null) {
      _selectedCategoryKey = widget.initialCategoryKey!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalCartCount {
    return widget.cartItems.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int? ?? 1),
    );
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

  void _openQuickCustomize(Map<String, dynamic> coffee) {
    QuickCustomizeSheet.show(
      context,
      coffee: coffee,
      onAddToCart: (customizedItem) {
        setState(() {
          final existingIndex = widget.cartItems.indexWhere((item) =>
              item['name'] == customizedItem['name'] &&
              item['size'] == customizedItem['size'] &&
              item['isHot'] == customizedItem['isHot'] &&
              item['sweetness'] == customizedItem['sweetness'] &&
              item['price'] == customizedItem['price']);

          if (existingIndex >= 0) {
            widget.cartItems[existingIndex]['quantity'] =
                (widget.cartItems[existingIndex]['quantity'] as int) + 1;
          } else {
            widget.cartItems.add(customizedItem);
          }
        });

        widget.onAddToCart?.call(customizedItem);

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
      cartItems: widget.cartItems,
      onIncrement: (index) {
        setState(() {
          widget.cartItems[index]['quantity'] =
              (widget.cartItems[index]['quantity'] as int) + 1;
        });
      },
      onDecrement: (index) {
        setState(() {
          final currentQty = widget.cartItems[index]['quantity'] as int;
          if (currentQty > 1) {
            widget.cartItems[index]['quantity'] = currentQty - 1;
          } else {
            widget.cartItems.removeAt(index);
          }
        });
      },
      onCheckout: () {
        if (widget.cartItems.isEmpty) return;

        final orderItems = widget.cartItems.map((item) {
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
                  widget.cartItems.clear();
                });
              },
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredCoffees {
    var list = _allCoffees.where((c) {
      // 1. Category Filter
      final matchesCategory = _selectedCategoryKey == 'all_coffee' ||
          c['category'] ==
              _categories.firstWhere(
                  (cat) => cat['key'] == _selectedCategoryKey)['category'];

      // 2. Search Query Filter
      final q = _searchQuery.toLowerCase();
      final name = (c['name'] as String).toLowerCase();
      final sub = (c['subtitle'] as String).toLowerCase();
      final cat = (c['category'] as String).toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          name.contains(q) ||
          sub.contains(q) ||
          cat.contains(q);

      // 3. Price Range Filter
      final price = (c['price'] as num).toDouble();
      final matchesPrice = price >= _filterOptions.priceRange.start &&
          price <= _filterOptions.priceRange.end;

      // 4. Minimum Rating Filter
      final rating = (c['rating'] as num).toDouble();
      final matchesRating = rating >= _filterOptions.minRating;

      return matchesCategory && matchesSearch && matchesPrice && matchesRating;
    }).toList();

    // 5. Sorting
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
    final filtered = _filteredCoffees;

    return ValueListenableBuilder<BrewezLanguage>(
      valueListenable: BrewezLocalization.currentLanguage,
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: BrewezTheme.background,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              // Search Bar & Filter Controls
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildSearchBar(),
              ),

              // Categories Chips
              _buildCategoryTabs(),
              const SizedBox(height: 10),

              // Results Count & Layout Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${BrewezLocalization.tr('showing_menu_count')}: ${filtered.length}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isGridView = true;
                            });
                          },
                          icon: Icon(
                            Icons.grid_view_rounded,
                            color: _isGridView
                                ? BrewezTheme.primary
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                          tooltip: BrewezLocalization.tr('view_grid'),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isGridView = false;
                            });
                          },
                          icon: Icon(
                            Icons.view_agenda_rounded,
                            color: !_isGridView
                                ? BrewezTheme.primary
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                          tooltip: BrewezLocalization.tr('view_list'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu List / Grid View
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : _isGridView
                        ? _buildGridView(filtered)
                        : _buildListView(filtered),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomCartBar(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: BrewezTheme.textDark,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            BrewezLocalization.tr('all_menu_title'),
            style: const TextStyle(
              color: BrewezTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            BrewezLocalization.tr('all_menu_sub'),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: BrewezTheme.textDark,
                  size: 20,
                ),
              ),
              onPressed: _openCartModal,
            ),
            if (_totalCartCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
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
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    final activeCount = _filterOptions.activeFilterCount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
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
        style: const TextStyle(
          color: BrewezTheme.textDark,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: BrewezLocalization.tr('search_hint'),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: BrewezTheme.primary,
            size: 22,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: activeCount > 0
                          ? BrewezTheme.primary
                          : Colors.grey.shade600,
                      size: 22,
                    ),
                    onPressed: _openFilterModal,
                  ),
                  if (activeCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$activeCount',
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
            ],
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategoryKey == cat['key'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryKey = cat['key']!;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? BrewezTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? BrewezTheme.primary : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: BrewezTheme.primary.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                BrewezLocalization.tr(cat['key']!),
                style: TextStyle(
                  color: isSelected ? Colors.white : BrewezTheme.textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> list) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final coffee = list[index];
        return _buildGridCard(coffee);
      },
    );
  }

  Widget _buildGridCard(Map<String, dynamic> coffee) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrewezCoffeeDetailPage(coffee: coffee),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Rating Badge
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(coffee['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            coffee['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Coffee Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffee['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: BrewezTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          coffee['subtitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          BrewezCurrency.format(coffee['price']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: BrewezTheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openQuickCustomize(coffee),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: BrewezTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final coffee = list[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrewezCoffeeDetailPage(coffee: coffee),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    coffee['image'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coffee['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: BrewezTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        coffee['subtitle'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${coffee['rating']}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: BrewezTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              coffee['category'],
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      BrewezCurrency.format(coffee['price']),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: BrewezTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _openQuickCustomize(coffee),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrewezTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_rounded, size: 14),
                          SizedBox(width: 2),
                          Text(
                            '+',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrewezTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: BrewezTheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              BrewezLocalization.tr('search_no_results'),
              style: const TextStyle(
                fontSize: 15,
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
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategoryKey = 'all_coffee';
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
      ),
    );
  }

  Widget? _buildBottomCartBar() {
    if (widget.cartItems.isEmpty) return null;

    final subtotal = widget.cartItems.fold<int>(
      0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['quantity'] as int? ?? 1)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$_totalCartCount ${BrewezLocalization.tr('items_count')}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  BrewezCurrency.format(subtotal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BrewezTheme.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _openCartModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: BrewezTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    BrewezLocalization.tr('my_cart'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
