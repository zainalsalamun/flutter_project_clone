import 'package:flutter/material.dart';

import '../models/food_item_model.dart';

class FoodPromoRepository {
  List<String> getCategories() {
    return const [
      'All',
      'Burger',
      'Pizza',
      'Chicken',
      'Noodles',
      'Drinks',
      'Dessert',
    ];
  }

  List<SizeOption> getSizeOptions() {
    return const [
      SizeOption(name: 'Regular', priceDelta: 0),
      SizeOption(name: 'Large', priceDelta: 5000),
      SizeOption(name: 'Extra Large', priceDelta: 9000),
    ];
  }

  List<AddonOption> getAddonOptions() {
    return const [
      AddonOption(name: 'Extra Cheese', price: 6000),
      AddonOption(name: 'Egg', price: 5000),
      AddonOption(name: 'Beef', price: 10000),
      AddonOption(name: 'Sauce', price: 3000),
    ];
  }

  List<FoodItem> getFoodItems() {
    return const [
      FoodItem(
        id: 'classic-burger',
        name: 'Classic Burger',
        restaurant: 'Burger District',
        category: 'Burger',
        rating: 4.8,
        price: 35000,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=900&auto=format&fit=crop',
        description:
            'Juicy grilled beef patty with melted cheese, fresh lettuce, tomato, onion, and a signature smoky sauce.',
        color: Color(0xFFFF7A1A),
      ),
      FoodItem(
        id: 'pepperoni-pizza',
        name: 'Pepperoni Pizza',
        restaurant: 'Slice Society',
        category: 'Pizza',
        rating: 4.7,
        price: 52000,
        imageUrl:
            'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=900&auto=format&fit=crop',
        description:
            'Crispy thin crust pizza layered with tomato sauce, mozzarella, and spicy pepperoni slices.',
        color: Color(0xFFEF4444),
      ),
      FoodItem(
        id: 'crispy-chicken',
        name: 'Crispy Chicken',
        restaurant: 'Golden Coop',
        category: 'Chicken',
        rating: 4.9,
        price: 42000,
        imageUrl:
            'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?q=80&w=900&auto=format&fit=crop',
        description:
            'Crunchy fried chicken with herbs, spicy mayo dip, and soft potato wedges on the side.',
        color: Color(0xFFF59E0B),
      ),
      FoodItem(
        id: 'ramen-noodles',
        name: 'Spicy Ramen',
        restaurant: 'Noodle Lab',
        category: 'Noodles',
        rating: 4.6,
        price: 39000,
        imageUrl:
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=900&auto=format&fit=crop',
        description:
            'Warm ramen bowl with springy noodles, chili broth, soft egg, scallion, and roasted chicken.',
        color: Color(0xFFDC2626),
      ),
      FoodItem(
        id: 'iced-matcha',
        name: 'Iced Matcha Latte',
        restaurant: 'Leaf & Cream',
        category: 'Drinks',
        rating: 4.5,
        price: 25000,
        imageUrl:
            'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?q=80&w=900&auto=format&fit=crop',
        description:
            'Cold creamy matcha latte with milk foam, balanced sweetness, and a clean earthy finish.',
        color: Color(0xFF10B981),
      ),
      FoodItem(
        id: 'berry-waffle',
        name: 'Berry Waffle',
        restaurant: 'Sweet Studio',
        category: 'Dessert',
        rating: 4.8,
        price: 31000,
        imageUrl:
            'https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=900&auto=format&fit=crop',
        description:
            'Golden waffle with whipped cream, fresh berries, maple drizzle, and crushed almond.',
        color: Color(0xFFEC4899),
      ),
    ];
  }
}
