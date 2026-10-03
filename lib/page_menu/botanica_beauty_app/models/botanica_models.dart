class BotanicaProduct {
  final String id;
  final String brand;
  final String title;
  final String subtitle;
  final String category;
  final int price;
  final int originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> thumbnails;
  final List<String> sizes;
  final String description;
  final List<String> keyIngredients;
  final bool isBestSeller;
  bool isWishlist;

  BotanicaProduct({
    required this.id,
    required this.brand,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.thumbnails,
    required this.sizes,
    required this.description,
    required this.keyIngredients,
    this.isBestSeller = false,
    this.isWishlist = false,
  });

  BotanicaProduct copyWith({
    String? id,
    String? brand,
    String? title,
    String? subtitle,
    String? category,
    int? price,
    int? originalPrice,
    int? discountPercent,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    List<String>? thumbnails,
    List<String>? sizes,
    String? description,
    List<String>? keyIngredients,
    bool? isBestSeller,
    bool? isWishlist,
  }) {
    return BotanicaProduct(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnails: thumbnails ?? this.thumbnails,
      sizes: sizes ?? this.sizes,
      description: description ?? this.description,
      keyIngredients: keyIngredients ?? this.keyIngredients,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isWishlist: isWishlist ?? this.isWishlist,
    );
  }
}

class BotanicaCartItem {
  final BotanicaProduct product;
  String selectedSize;
  int quantity;

  BotanicaCartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  int get totalPrice => product.price * quantity;
}

class BotanicaBanner {
  final String id;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final String tag;

  const BotanicaBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.tag,
  });
}
