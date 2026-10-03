import 'package:flutter/material.dart';
import '../../core/botanica_currency.dart';
import '../../core/botanica_data.dart';
import '../../core/botanica_theme.dart';
import '../../models/botanica_models.dart';
import '../../widgets/botanica_cart_sheet.dart';
import '../../widgets/botanica_network_image.dart';
import '../product/botanica_product_detail_screen.dart';

class BotanicaWishlistTab extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const BotanicaWishlistTab({
    super.key,
    this.onExploreTap,
  });

  @override
  State<BotanicaWishlistTab> createState() => _BotanicaWishlistTabState();
}

class _BotanicaWishlistTabState extends State<BotanicaWishlistTab> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BotanicaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ValueListenableBuilder<List<BotanicaProduct>>(
          valueListenable: BotanicaData().productsNotifier,
          builder: (context, products, _) {
            final wishlistCount = products.where((p) => p.isWishlist).length;
            return Text(
              'Wishlist Saya ($wishlistCount)',
              style: BotanicaTheme.font(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: BotanicaTheme.textPrimary,
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: BotanicaTheme.textPrimary, size: 22),
            onPressed: () => BotanicaCartSheet.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<List<BotanicaProduct>>(
        valueListenable: BotanicaData().productsNotifier,
        builder: (context, products, _) {
          final wishlistProducts = products.where((p) => p.isWishlist).toList();

          if (wishlistProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE4E6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 40,
                        color: BotanicaTheme.accentRose,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Wishlist Anda Masih Kosong',
                      style: BotanicaTheme.font(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: BotanicaTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Simpan produk skincare dan beauty favorit Anda untuk dibeli nanti.',
                      textAlign: TextAlign.center,
                      style: BotanicaTheme.font(
                        fontSize: 13,
                        color: BotanicaTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: widget.onExploreTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BotanicaTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Jelajahi Produk',
                        style: BotanicaTheme.font(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Compute categories dynamically
          final categories = ['All'];
          for (var p in wishlistProducts) {
            if (!categories.contains(p.category)) {
              categories.add(p.category);
            }
          }

          final displayedProducts = wishlistProducts.where((p) {
            if (_selectedCategory == 'All') return true;
            return p.category.toLowerCase() == _selectedCategory.toLowerCase();
          }).toList();

          return Column(
            children: [
              // Category filter bar
              Container(
                height: 52,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  separatorBuilder: (context, idx) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final count = cat == 'All'
                        ? wishlistProducts.length
                        : wishlistProducts.where((p) => p.category == cat).length;
                    final isSelected = cat == _selectedCategory;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? BotanicaTheme.primary : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '$cat ($count)',
                            style: BotanicaTheme.font(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : BotanicaTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1, color: Color(0xFFF3F4F6)),

              // Product list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: displayedProducts.length,
                  separatorBuilder: (context, idx) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final product = displayedProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BotanicaProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: BotanicaTheme.cardBorderLight),
                          boxShadow: BotanicaTheme.cardShadow,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail Box
                            Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: BotanicaNetworkImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Info & Actions
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.brand.toUpperCase(),
                                        style: BotanicaTheme.font(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: BotanicaTheme.textTertiary,
                                        ),
                                      ),
                                      // Remove heart button
                                      InkWell(
                                        onTap: () {
                                          BotanicaData().toggleWishlist(product.id);
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.favorite_rounded,
                                            color: BotanicaTheme.accentRose,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BotanicaTheme.font(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: BotanicaTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    product.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: BotanicaTheme.font(
                                      fontSize: 11,
                                      color: BotanicaTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Price and Add to Bag
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formatBotanicaRupiah(product.price),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: BotanicaTheme.font(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w800,
                                                color: BotanicaTheme.textPrimary,
                                              ),
                                            ),
                                            if (product.originalPrice > product.price)
                                              Text(
                                                formatBotanicaRupiah(product.originalPrice),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: BotanicaTheme.textTertiary,
                                                  decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Direct Add to Bag Pill Button
                                      ElevatedButton(
                                        onPressed: () {
                                          final size = product.sizes.isNotEmpty ? product.sizes.first : 'Default';
                                          BotanicaData().addToCart(product, size, 1);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product.title} ditambahkan ke shopping bag!'),
                                              backgroundColor: BotanicaTheme.primary,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              action: SnackBarAction(
                                                label: 'Buka Bag',
                                                textColor: const Color(0xFF93C5FD),
                                                onPressed: () => BotanicaCartSheet.show(context),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: BotanicaTheme.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.white),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Add to Bag',
                                              style: BotanicaTheme.font(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
