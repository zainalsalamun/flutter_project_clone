import 'package:flutter/material.dart';
import '../models/botanica_models.dart';

class BotanicaData {
  static final BotanicaData _instance = BotanicaData._internal();
  factory BotanicaData() => _instance;
  BotanicaData._internal();

  // Reactive State Notifiers
  final ValueNotifier<List<BotanicaProduct>> productsNotifier = ValueNotifier<List<BotanicaProduct>>([]);
  final ValueNotifier<List<BotanicaCartItem>> cartNotifier = ValueNotifier<List<BotanicaCartItem>>([]);
  final ValueNotifier<String> selectedCategoryNotifier = ValueNotifier<String>('All');
  final ValueNotifier<String> appliedVoucherNotifier = ValueNotifier<String>('');
  final ValueNotifier<int> voucherDiscountNotifier = ValueNotifier<int>(0);

  void init() {
    productsNotifier.value = List.from(defaultProducts);
    // Preload some wishlist items
    cartNotifier.value = [
      BotanicaCartItem(
        product: defaultProducts[0],
        selectedSize: '70 ml',
        quantity: 1,
      ),
    ];
  }

  void toggleWishlist(String productId) {
    final list = List<BotanicaProduct>.from(productsNotifier.value);
    final index = list.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final p = list[index];
      list[index] = p.copyWith(isWishlist: !p.isWishlist);
      productsNotifier.value = list;
    }
  }

  void addToCart(BotanicaProduct product, String size, int quantity) {
    final list = List<BotanicaCartItem>.from(cartNotifier.value);
    final index = list.indexWhere((item) => item.product.id == product.id && item.selectedSize == size);

    if (index >= 0) {
      list[index].quantity += quantity;
    } else {
      list.add(BotanicaCartItem(
        product: product,
        selectedSize: size,
        quantity: quantity,
      ));
    }
    cartNotifier.value = list;
  }

  void updateCartQuantity(int itemIndex, int newQty) {
    final list = List<BotanicaCartItem>.from(cartNotifier.value);
    if (itemIndex >= 0 && itemIndex < list.length) {
      if (newQty <= 0) {
        list.removeAt(itemIndex);
      } else {
        list[itemIndex].quantity = newQty;
      }
      cartNotifier.value = list;
    }
  }

  void removeFromCart(int itemIndex) {
    final list = List<BotanicaCartItem>.from(cartNotifier.value);
    if (itemIndex >= 0 && itemIndex < list.length) {
      list.removeAt(itemIndex);
      cartNotifier.value = list;
    }
  }

  bool applyVoucher(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'BOTANICAGLOW' || cleanCode == 'BEAUTY50') {
      appliedVoucherNotifier.value = cleanCode;
      voucherDiscountNotifier.value = 50000;
      return true;
    } else if (cleanCode == 'DISCOUNT20') {
      appliedVoucherNotifier.value = cleanCode;
      voucherDiscountNotifier.value = 25000;
      return true;
    }
    return false;
  }

  int get cartTotalSubtotal {
    return cartNotifier.value.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get cartFinalTotal {
    final sub = cartTotalSubtotal;
    final disc = voucherDiscountNotifier.value;
    final shipping = sub >= 250000 ? 0 : 20000;
    final total = sub - disc + shipping;
    return total > 0 ? total : 0;
  }

  static final List<BotanicaBanner> defaultBanners = [
    const BotanicaBanner(
      id: 'b1',
      title: 'Healthy Skin\nBrighter You',
      subtitle: 'Discover premium botanical skincare for your natural glow.',
      buttonText: 'Shop Now',
      imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&auto=format&fit=crop&q=80',
      tag: 'Best Seller Pick',
    ),
    const BotanicaBanner(
      id: 'b2',
      title: 'Deep Hydration\nBarrier Restored',
      subtitle: 'Enriched with 5D Hyaluronic Acid & Ceramide Complex.',
      buttonText: 'Explore',
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      tag: 'New Formula',
    ),
  ];

  static final List<BotanicaProduct> defaultProducts = [
    BotanicaProduct(
      id: 'prod_1',
      brand: 'LANEIGE',
      title: 'Water Sleeping Mask EX',
      subtitle: 'Hydrating • Brightening • Repairing',
      category: 'Skincare',
      price: 489000,
      originalPrice: 599000,
      discountPercent: 20,
      rating: 4.8,
      reviewCount: 1240,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1608248597359-07f23e200155?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['50 ml', '70 ml', '100 ml'],
      description: 'Wake up to soft, hydrated and glowing skin. Laneige Water Sleeping Mask EX deeply moisturizes and repairs your skin barrier overnight while you sleep, providing a healthier and radiant complexion.',
      keyIngredients: ['Probiotics Complex', 'Squalane', 'Hyaluronic Acid 5D', 'Niacinamide'],
      isBestSeller: true,
      isWishlist: true,
    ),
    BotanicaProduct(
      id: 'prod_2',
      brand: 'CeraVe',
      title: 'Daily Moisturizing Lotion',
      subtitle: 'Lightweight • 3 Essential Ceramides • Oil Free',
      category: 'Skincare',
      price: 245000,
      originalPrice: 289000,
      discountPercent: 15,
      rating: 4.7,
      reviewCount: 856,
      imageUrl: 'https://images.unsplash.com/photo-1608248597359-07f23e200155?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1608248597359-07f23e200155?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['88 ml', '236 ml', '473 ml'],
      description: 'Developed with dermatologists, CeraVe Daily Moisturizing Lotion has a unique, lightweight formula that provides 24-hour hydration and helps restore the protective skin barrier with 3 essential ceramides.',
      keyIngredients: ['Ceramides 1, 3, 6-II', 'Hyaluronic Acid', 'MVE Delivery Tech'],
      isBestSeller: true,
      isWishlist: true,
    ),
    BotanicaProduct(
      id: 'prod_3',
      brand: 'Rare Beauty',
      title: 'Soft Pinch Liquid Blush',
      subtitle: 'Long-lasting • Weightless • Dewy Finish',
      category: 'Makeup',
      price: 385000,
      originalPrice: 450000,
      discountPercent: 14,
      rating: 4.9,
      reviewCount: 2150,
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['3.2 ml (Mini)', '7.5 ml (Full Size)'],
      description: 'An airy, lightweight liquid blush that blends and builds effortlessly for a soft, healthy flush. Infused with botanical extracts of gardenia, lotus, and white water lily.',
      keyIngredients: ['Lotus Botanical Extract', 'Gardenia Extract', 'White Water Lily'],
      isBestSeller: true,
      isWishlist: true,
    ),
    BotanicaProduct(
      id: 'prod_4',
      brand: 'CAUDALIE',
      title: 'Vinopure Purifying Gel Cleanser',
      subtitle: 'Pore Minimizing • Salicylic Acid • Oil Control',
      category: 'Skincare',
      price: 295000,
      originalPrice: 350000,
      discountPercent: 15,
      rating: 4.8,
      reviewCount: 620,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['150 ml', '380 ml'],
      description: 'The first essential step in your acne-prone skincare routine. It cleanses, tightens pores, and reduces excess sebum without drying out the skin.',
      keyIngredients: ['Natural Salicylic Acid', 'Organic Grape Water', 'Organic Essential Oils'],
      isBestSeller: true,
      isWishlist: true,
    ),
    BotanicaProduct(
      id: 'prod_5',
      brand: 'COSRX',
      title: 'Advanced Snail 96 Mucin Power Essence',
      subtitle: 'Intense Moisture • Soothing • Skin Elasticity',
      category: 'Skincare',
      price: 215000,
      originalPrice: 265000,
      discountPercent: 18,
      rating: 4.9,
      reviewCount: 3410,
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['100 ml'],
      description: 'Formulated with 96.3% Snail Secretion Filtrate, this essence protects the skin from moisture loss while improving skin elasticity and soothing irritation.',
      keyIngredients: ['96.3% Snail Secretion Filtrate', 'Sodium Hyaluronate', 'Allantoin', 'Panthenol'],
      isBestSeller: true,
      isWishlist: false,
    ),
    BotanicaProduct(
      id: 'prod_6',
      brand: 'Innisfree',
      title: 'Green Tea Seed Hyaluronic Serum',
      subtitle: 'Deep Hydration • Jeju Green Tea • Glow',
      category: 'Skincare',
      price: 340000,
      originalPrice: 400000,
      discountPercent: 15,
      rating: 4.8,
      reviewCount: 980,
      imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['50 ml', '80 ml', '160 ml'],
      description: 'Intensive hydrating serum with Beauty Green Tea extract and 5 types of hyaluronic acid to quench dehydrated skin quickly.',
      keyIngredients: ['Jeju Green Tea Water', 'Green Tea Biome', 'Hyaluronic Acid 5D'],
      isBestSeller: false,
      isWishlist: false,
    ),
    BotanicaProduct(
      id: 'prod_7',
      brand: 'Olaplex',
      title: 'No. 7 Bonding Hair Oil',
      subtitle: 'Heat Protection 450°F • Anti-Frizz • Shine',
      category: 'Hair Care',
      price: 495000,
      originalPrice: 560000,
      discountPercent: 12,
      rating: 4.9,
      reviewCount: 1450,
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['30 ml'],
      description: 'A highly-concentrated, weightless reparative styling oil that dramatically increases shine, softness, and color vibrancy while minimizing flyaways.',
      keyIngredients: ['Bis-Aminopropyl Diglycol Dimaleate', 'Grape Seed Oil', 'Fermented Green Tea Oil'],
      isBestSeller: true,
      isWishlist: false,
    ),
    BotanicaProduct(
      id: 'prod_8',
      brand: 'Maison Margiela',
      title: 'Replica Lazy Sunday Morning',
      subtitle: 'Floral Woody Musk • Fresh Linen Notes',
      category: 'Fragrance',
      price: 1950000,
      originalPrice: 2200000,
      discountPercent: 11,
      rating: 4.9,
      reviewCount: 780,
      imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=800&auto=format&fit=crop&q=80',
      thumbnails: [
        'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=800&auto=format&fit=crop&q=80',
      ],
      sizes: ['30 ml', '100 ml'],
      description: 'A classic floral fragrance that recalls the memory of soft, sunlit mornings in bed with crisp white cotton sheets.',
      keyIngredients: ['Lily of the Valley', 'Iris', 'White Musk', 'Pear Extract'],
      isBestSeller: false,
      isWishlist: false,
    ),
  ];
}
