import 'package:flutter/material.dart';
import '../../core/botanica_currency.dart';
import '../../core/botanica_data.dart';
import '../../core/botanica_theme.dart';
import '../../models/botanica_models.dart';
import '../../widgets/botanica_cart_sheet.dart';
import '../../widgets/botanica_network_image.dart';
import '../../widgets/botanica_trust_badge.dart';

class BotanicaProductDetailScreen extends StatefulWidget {
  final BotanicaProduct product;

  const BotanicaProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<BotanicaProductDetailScreen> createState() => _BotanicaProductDetailScreenState();
}

class _BotanicaProductDetailScreenState extends State<BotanicaProductDetailScreen> {
  late int _selectedImageIndex;
  late String _selectedSize;
  int _quantity = 1;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedImageIndex = 0;
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'Default';
  }

  void _handleAddToCart() {
    BotanicaData().addToCart(widget.product, _selectedSize, _quantity);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.product.title} ($_selectedSize) ditambahkan ke shopping bag!',
                style: BotanicaTheme.font(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: BotanicaTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Lihat Bag',
          textColor: const Color(0xFF93C5FD),
          onPressed: () {
            BotanicaCartSheet.show(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.thumbnails.isNotEmpty
        ? widget.product.thumbnails
        : [widget.product.imageUrl];

    final currentImageUrl = _selectedImageIndex < images.length
        ? images[_selectedImageIndex]
        : widget.product.imageUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: BotanicaTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.brand,
          style: BotanicaTheme.font(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: BotanicaTheme.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20, color: BotanicaTheme.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tautan produk disalin ke clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          ValueListenableBuilder<List<BotanicaProduct>>(
            valueListenable: BotanicaData().productsNotifier,
            builder: (context, products, _) {
              final currentProd = products.firstWhere(
                (p) => p.id == widget.product.id,
                orElse: () => widget.product,
              );
              return IconButton(
                icon: Icon(
                  currentProd.isWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: currentProd.isWishlist ? BotanicaTheme.accentRose : BotanicaTheme.textPrimary,
                  size: 22,
                ),
                onPressed: () {
                  BotanicaData().toggleWishlist(widget.product.id);
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image View
                  Container(
                    width: double.infinity,
                    height: 290,
                    color: const Color(0xFFF9FAFB),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: BotanicaNetworkImage(
                          imageUrl: currentImageUrl,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Thumbnails Row
                  if (images.length > 1)
                    Container(
                      height: 72,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          final isSelected = index == _selectedImageIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? BotanicaTheme.primary : BotanicaTheme.cardBorder,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected ? BotanicaTheme.cardShadow : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: BotanicaNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Product Details Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.brand.toUpperCase(),
                              style: BotanicaTheme.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: BotanicaTheme.textTertiary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: BotanicaTheme.accentAmber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.rating}',
                                    style: BotanicaTheme.font(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${widget.product.reviewCount})',
                                    style: BotanicaTheme.font(
                                      fontSize: 11,
                                      color: const Color(0xFFB45309),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Title
                        Text(
                          widget.product.title,
                          style: BotanicaTheme.font(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: BotanicaTheme.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Subtitle / tags
                        Text(
                          widget.product.subtitle,
                          style: BotanicaTheme.font(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: BotanicaTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Pricing Row
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            Text(
                              formatBotanicaRupiah(widget.product.price),
                              style: BotanicaTheme.font(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: BotanicaTheme.primary,
                              ),
                            ),
                            if (widget.product.originalPrice > widget.product.price) ...[
                              Text(
                                formatBotanicaRupiah(widget.product.originalPrice),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: BotanicaTheme.textTertiary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: BotanicaTheme.discountTagBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Hemat ${widget.product.discountPercent}%',
                                  style: BotanicaTheme.font(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: BotanicaTheme.discountTagText,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 12),

                        // Select Size / Volume
                        Text(
                          'Pilih Ukuran (Volume)',
                          style: BotanicaTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: widget.product.sizes.map((size) {
                            final isSelected = size == _selectedSize;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? BotanicaTheme.primaryTint : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? BotanicaTheme.primary : BotanicaTheme.cardBorder,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: BotanicaTheme.font(
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? BotanicaTheme.primary : BotanicaTheme.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 12),

                        // Key Ingredients
                        Text(
                          'Kandungan Utama (Key Ingredients)',
                          style: BotanicaTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.product.keyIngredients.map((ingredient) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.eco_outlined, size: 14, color: Color(0xFF059669)),
                                  const SizedBox(width: 6),
                                  Text(
                                    ingredient,
                                    style: BotanicaTheme.font(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: BotanicaTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFF3F4F6)),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          'Deskripsi Produk',
                          style: BotanicaTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          maxLines: _isDescriptionExpanded ? null : 3,
                          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: BotanicaTheme.font(
                            fontSize: 13,
                            color: BotanicaTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _isDescriptionExpanded ? 'Tutup Deskripsi' : 'Baca Selengkapnya',
                              style: BotanicaTheme.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: BotanicaTheme.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Trust Badges
                        const BotanicaTrustBadgeRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 16, color: BotanicaTheme.textPrimary),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$_quantity',
                            style: BotanicaTheme.font(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: BotanicaTheme.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 16, color: BotanicaTheme.textPrimary),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Add to Bag Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BotanicaTheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Add to Bag • ${formatBotanicaRupiah(widget.product.price * _quantity)}',
                                  maxLines: 1,
                                  style: BotanicaTheme.font(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
