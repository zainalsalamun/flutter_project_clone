import 'package:flutter/material.dart';
import '../core/botanica_currency.dart';
import '../core/botanica_data.dart';
import '../core/botanica_theme.dart';
import '../models/botanica_models.dart';
import 'botanica_network_image.dart';

class BotanicaProductCard extends StatelessWidget {
  final BotanicaProduct product;
  final VoidCallback onTap;

  const BotanicaProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: BotanicaTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BotanicaTheme.cardBorderLight),
          boxShadow: BotanicaTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flexible Product Image Container with Badges
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: BotanicaNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Discount Tag (Top-Left)
                  if (product.discountPercent > 0)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: BotanicaTheme.discountTagBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: BotanicaTheme.font(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: BotanicaTheme.discountTagText,
                          ),
                        ),
                      ),
                    ),

                  // Wishlist Heart Button (Top-Right)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: InkWell(
                      onTap: () {
                        BotanicaData().toggleWishlist(product.id);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          product.isWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: product.isWishlist ? BotanicaTheme.accentRose : BotanicaTheme.textTertiary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BotanicaTheme.font(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: BotanicaTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Brand
                  Text(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BotanicaTheme.font(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: BotanicaTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          formatBotanicaRupiahClean(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: BotanicaTheme.font(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: BotanicaTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (product.originalPrice > product.price) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            formatBotanicaRupiahClean(product.originalPrice),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: BotanicaTheme.textTertiary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Rating Row
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: BotanicaTheme.accentAmber,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: BotanicaTheme.font(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: BotanicaTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        ' (${product.reviewCount > 999 ? '${(product.reviewCount / 1000).toStringAsFixed(1)}k' : product.reviewCount})',
                        style: BotanicaTheme.font(
                          fontSize: 10,
                          color: BotanicaTheme.textTertiary,
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
  }
}
