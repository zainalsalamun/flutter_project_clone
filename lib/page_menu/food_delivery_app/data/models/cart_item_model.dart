import 'package:equatable/equatable.dart';
import 'food_model.dart';
import 'restaurant_model.dart';

class CartItemModel extends Equatable {
  final FoodModel food;
  final RestaurantModel restaurant;
  final int quantity;
  final List<AddonModel> selectedAddons;
  final String notes;

  const CartItemModel({
    required this.food,
    required this.restaurant,
    required this.quantity,
    this.selectedAddons = const [],
    this.notes = '',
  });

  CartItemModel copyWith({
    FoodModel? food,
    RestaurantModel? restaurant,
    int? quantity,
    List<AddonModel>? selectedAddons,
    String? notes,
  }) {
    return CartItemModel(
      food: food ?? this.food,
      restaurant: restaurant ?? this.restaurant,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice {
    double addonsTotal = selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonsTotal) * quantity;
  }

  @override
  List<Object?> get props => [food, restaurant, quantity, selectedAddons, notes];
}
