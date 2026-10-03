import 'package:flutter/material.dart';
import '../../core/botanica_data.dart';
import '../../core/botanica_theme.dart';
import '../../models/botanica_models.dart';
import '../../widgets/botanica_cart_sheet.dart';
import '../../widgets/botanica_product_card.dart';
import '../product/botanica_product_detail_screen.dart';

class BotanicaExploreTab extends StatefulWidget {
  const BotanicaExploreTab({super.key});

  @override
  State<BotanicaExploreTab> createState() => _BotanicaExploreTabState();
}

class _BotanicaExploreTabState extends State<BotanicaExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'Popular'; // 'Popular', 'Price: Low to High', 'Price: High to Low', 'Top Rated'

  final List<String> _categories = [
    'All',
    'Skincare',
    'Makeup',
    'Hair Care',
    'Fragrance',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BotanicaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Eksplor Katalog',
          style: BotanicaTheme.font(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: BotanicaTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: BotanicaTheme.textPrimary, size: 22),
            onPressed: () => BotanicaCartSheet.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Column(
              children: [
                // Search Input
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BotanicaTheme.cardBorder),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari berdasarkan nama atau merk...',
                      hintStyle: BotanicaTheme.font(fontSize: 12.5, color: BotanicaTheme.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: BotanicaTheme.textTertiary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16, color: BotanicaTheme.textTertiary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Sort Dropdown & Active Category Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category Chips Bar (inline)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((cat) {
                            final isSelected = cat == _selectedCategory;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text(
                                  cat,
                                  style: BotanicaTheme.font(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : BotanicaTheme.textSecondary,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: BotanicaTheme.primary,
                                backgroundColor: const Color(0xFFF3F4F6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                side: BorderSide.none,
                                showCheckmark: false,
                                onSelected: (sel) {
                                  if (sel) {
                                    setState(() {
                                      _selectedCategory = cat;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Sort menu button
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sort_rounded, size: 16, color: BotanicaTheme.textPrimary),
                            const SizedBox(width: 4),
                            Text(
                              _sortBy,
                              style: BotanicaTheme.font(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      onSelected: (val) {
                        setState(() {
                          _sortBy = val;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Popular', child: Text('Terpopuler')),
                        const PopupMenuItem(value: 'Price: Low to High', child: Text('Harga: Terendah')),
                        const PopupMenuItem(value: 'Price: High to Low', child: Text('Harga: Tertinggi')),
                        const PopupMenuItem(value: 'Top Rated', child: Text('Rating Tertinggi')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Product Grid Catalog
          Expanded(
            child: ValueListenableBuilder<List<BotanicaProduct>>(
              valueListenable: BotanicaData().productsNotifier,
              builder: (context, products, _) {
                final query = _searchController.text.trim().toLowerCase();
                var filtered = products.where((p) {
                  final matchCat = _selectedCategory == 'All' || p.category.toLowerCase() == _selectedCategory.toLowerCase();
                  final matchSearch = query.isEmpty ||
                      p.title.toLowerCase().contains(query) ||
                      p.brand.toLowerCase().contains(query) ||
                      p.subtitle.toLowerCase().contains(query);
                  return matchCat && matchSearch;
                }).toList();

                // Sort
                if (_sortBy == 'Price: Low to High') {
                  filtered.sort((a, b) => a.price.compareTo(b.price));
                } else if (_sortBy == 'Price: High to Low') {
                  filtered.sort((a, b) => b.price.compareTo(a.price));
                } else if (_sortBy == 'Top Rated') {
                  filtered.sort((a, b) => b.rating.compareTo(a.rating));
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: BotanicaTheme.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada produk yang cocok',
                          style: BotanicaTheme.font(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: BotanicaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.64,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
