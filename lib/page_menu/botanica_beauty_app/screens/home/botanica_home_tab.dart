import 'package:flutter/material.dart';
import '../../core/botanica_data.dart';
import '../../core/botanica_theme.dart';
import '../../models/botanica_models.dart';
import '../../widgets/botanica_banner_carousel.dart';
import '../../widgets/botanica_cart_sheet.dart';
import '../../widgets/botanica_product_card.dart';
import '../product/botanica_product_detail_screen.dart';

class BotanicaHomeTab extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const BotanicaHomeTab({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<BotanicaHomeTab> createState() => _BotanicaHomeTabState();
}

class _BotanicaHomeTabState extends State<BotanicaHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Skincare', 'Hair Care', 'Makeup', 'Fragrance'];
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BotanicaTheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar / Top Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: BotanicaTheme.primaryTint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: BotanicaTheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BOTANICA',
                              style: BotanicaTheme.font(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: BotanicaTheme.primary,
                              ),
                            ),
                            Text(
                              'Beauty & Care',
                              style: BotanicaTheme.font(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: BotanicaTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Actions: Notification & Cart
                    Row(
                      children: [
                        // Notification Bell
                        Stack(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: BotanicaTheme.cardBorder),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_outlined, size: 20, color: BotanicaTheme.textPrimary),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tidak ada notifikasi baru.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: BotanicaTheme.accentRose,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),

                        // Shopping Bag Icon
                        ValueListenableBuilder<List<BotanicaCartItem>>(
                          valueListenable: BotanicaData().cartNotifier,
                          builder: (context, cart, _) {
                            final count = cart.fold<int>(0, (sum, i) => sum + i.quantity);
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: BotanicaTheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.white),
                                    onPressed: () => BotanicaCartSheet.show(context),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: BotanicaTheme.accentRose,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                      child: Center(
                                        child: Text(
                                          '$count',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: BotanicaTheme.cardBorder),
                          boxShadow: BotanicaTheme.cardShadow,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim().toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari skincare, serum, sunscreen...',
                            hintStyle: BotanicaTheme.font(
                              fontSize: 12.5,
                              color: BotanicaTheme.textTertiary,
                            ),
                            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: BotanicaTheme.textTertiary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 16, color: BotanicaTheme.textTertiary),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: BotanicaTheme.cardBorder),
                        boxShadow: BotanicaTheme.cardShadow,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, size: 20, color: BotanicaTheme.primary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filter kustomisasi kategori aktif.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Chips Selector
            SliverToBoxAdapter(
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ValueListenableBuilder<String>(
                  valueListenable: BotanicaData().selectedCategoryNotifier,
                  builder: (context, activeCategory, _) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _categories.length,
                      separatorBuilder: (context, idx) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == activeCategory;
                        return InkWell(
                          onTap: () {
                            BotanicaData().selectedCategoryNotifier.value = cat;
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? BotanicaTheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? BotanicaTheme.primary : BotanicaTheme.cardBorder,
                              ),
                              boxShadow: isSelected ? BotanicaTheme.cardShadow : null,
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: BotanicaTheme.font(
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : BotanicaTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Hero Banner Carousel
            if (_searchQuery.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: BotanicaBannerCarousel(
                    banners: BotanicaData.defaultBanners,
                    onBannerTap: (banner) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Promo: ${banner.title.replaceAll('\n', ' ')}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Section Header: Best Sellers / Catalog
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilihan Terlaris',
                          style: BotanicaTheme.font(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Formula dermatologis bersertifikat BPOM',
                          style: BotanicaTheme.font(
                            fontSize: 11,
                            color: BotanicaTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onNavigateTab?.call(1); // switch to explore tab
                      },
                      child: Text(
                        'Lihat Semua',
                        style: BotanicaTheme.font(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: BotanicaTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            ValueListenableBuilder<List<BotanicaProduct>>(
              valueListenable: BotanicaData().productsNotifier,
              builder: (context, products, _) {
                return ValueListenableBuilder<String>(
                  valueListenable: BotanicaData().selectedCategoryNotifier,
                  builder: (context, selectedCat, _) {
                    final filtered = products.where((p) {
                      final matchCat = selectedCat == 'All' || p.category.toLowerCase() == selectedCat.toLowerCase();
                      final matchSearch = _searchQuery.isEmpty ||
                          p.title.toLowerCase().contains(_searchQuery) ||
                          p.brand.toLowerCase().contains(_searchQuery) ||
                          p.subtitle.toLowerCase().contains(_searchQuery);
                      return matchCat && matchSearch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              const Icon(Icons.search_off_rounded, size: 48, color: BotanicaTheme.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                'Produk tidak ditemukan',
                                style: BotanicaTheme.font(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: BotanicaTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Coba cari dengan kata kunci lain atau pilih kategori lain.',
                                textAlign: TextAlign.center,
                                style: BotanicaTheme.font(fontSize: 12, color: BotanicaTheme.textTertiary),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  BotanicaData().selectedCategoryNotifier.value = 'All';
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Reset Filter'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.64,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = filtered[index];
                            return BotanicaProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BotanicaProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: filtered.length,
                        ),
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
