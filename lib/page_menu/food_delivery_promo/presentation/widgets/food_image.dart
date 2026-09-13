import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class FoodImage extends StatelessWidget {
  const FoodImage({
    super.key,
    required this.imageUrl,
    required this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder:
            (context, url) => Container(
              color: FoodPromoTheme.softOrange,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: FoodPromoTheme.orange,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: FoodPromoTheme.softOrange,
              child: const Icon(
                Icons.fastfood_rounded,
                color: FoodPromoTheme.orange,
              ),
            ),
      ),
    );
  }
}
