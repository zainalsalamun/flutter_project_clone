import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';

class DummyData {
  static List<RestaurantModel> getRestaurants() {
    return [
      RestaurantModel(
        id: 'r1',
        name: 'McDonald\'s',
        imageUrl: 'https://images.unsplash.com/photo-1626229652216-e5bb7f511917?q=80&w=1932&auto=format&fit=crop',
        rating: 4.5,
        distance: 2.3,
        deliveryTimeMin: 25,
        deliveryFee: 15000,
        categories: const ['Fast Food', 'Burger', 'American'],
        menu: [
          const FoodModel(
            id: 'f1',
            name: 'Big Mac',
            description: 'Mouthwatering perfection starts with two 100% pure beef patties and Big Mac sauce sandwiched between a sesame seed bun.',
            price: 45000,
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1899&auto=format&fit=crop',
            availableAddons: [
              AddonModel(id: 'a1', name: 'Extra Cheese', price: 5000),
              AddonModel(id: 'a2', name: 'Extra Patty', price: 15000),
            ],
          ),
          const FoodModel(
            id: 'f2',
            name: 'French Fries',
            description: 'Our world famous fries are made from premium potatoes.',
            price: 20000,
            imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?q=80&w=1947&auto=format&fit=crop',
          ),
        ],
      ),
      RestaurantModel(
        id: 'r2',
        name: 'Pizza Hut',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2070&auto=format&fit=crop',
        rating: 4.8,
        distance: 4.1,
        deliveryTimeMin: 40,
        deliveryFee: 20000,
        categories: const ['Pizza', 'Italian'],
        menu: [
          const FoodModel(
            id: 'f3',
            name: 'Pepperoni Pizza',
            description: 'Classic pepperoni pizza with mozzarella cheese.',
            price: 85000,
            imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=1780&auto=format&fit=crop',
            availableAddons: [
              AddonModel(id: 'a3', name: 'Stuffed Crust', price: 25000),
              AddonModel(id: 'a4', name: 'Extra Pepperoni', price: 15000),
            ],
          ),
        ],
      ),
      RestaurantModel(
        id: 'r3',
        name: 'KFC',
        imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?q=80&w=2070&auto=format&fit=crop',
        rating: 4.3,
        distance: 1.5,
        deliveryTimeMin: 15,
        deliveryFee: 10000,
        categories: const ['Chicken', 'Fast Food'],
        menu: [
          const FoodModel(
            id: 'f4',
            name: 'Original Recipe Chicken',
            description: 'Freshly prepared chicken, hand-breaded in our secret 11 herbs and spices.',
            price: 35000,
            imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?q=80&w=2070&auto=format&fit=crop',
            availableAddons: [
              AddonModel(id: 'a5', name: 'Rice', price: 8000),
              AddonModel(id: 'a6', name: 'Pepsi', price: 10000),
            ],
          ),
        ],
      ),
    ];
  }
}
