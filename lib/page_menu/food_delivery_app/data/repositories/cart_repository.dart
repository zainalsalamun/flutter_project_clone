import '../models/cart_item_model.dart';
import '../models/food_model.dart';
import '../models/restaurant_model.dart';

class CartRepository {
  final List<CartItemModel> _cartItems = [];

  Future<List<CartItemModel>> getCart() async {
    return List.unmodifiable(_cartItems);
  }

  Future<void> addToCart(
    FoodModel food,
    RestaurantModel restaurant, {
    int quantity = 1,
    List<AddonModel> selectedAddons = const [],
    String notes = '',
  }) async {
    // If cart has items from different restaurant, we should ideally clear it or throw error.
    // For simplicity, we just clear it if it's a different restaurant.
    if (_cartItems.isNotEmpty && _cartItems.first.restaurant.id != restaurant.id) {
      _cartItems.clear();
    }

    final index = _cartItems.indexWhere((item) =>
        item.food.id == food.id &&
        _areAddonsEqual(item.selectedAddons, selectedAddons) &&
        item.notes == notes);

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: _cartItems[index].quantity + quantity);
    } else {
      _cartItems.add(CartItemModel(
        food: food,
        restaurant: restaurant,
        quantity: quantity,
        selectedAddons: selectedAddons,
        notes: notes,
      ));
    }
  }

  bool _areAddonsEqual(List<AddonModel> a, List<AddonModel> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toList()..sort();
    final bIds = b.map((e) => e.id).toList()..sort();
    for (int i = 0; i < aIds.length; i++) {
      if (aIds[i] != bIds[i]) return false;
    }
    return true;
  }

  Future<void> removeFromCart(CartItemModel item) async {
    _cartItems.remove(item);
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    final index = _cartItems.indexOf(item);
    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
  }
}
