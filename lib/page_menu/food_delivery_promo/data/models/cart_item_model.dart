import 'package:equatable/equatable.dart';

import 'food_item_model.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.key,
    required this.food,
    required this.quantity,
    required this.unitPrice,
    required this.size,
    required this.addons,
  });

  final String key;
  final FoodItem food;
  final int quantity;
  final int unitPrice;
  final String size;
  final List<String> addons;

  int get total => unitPrice * quantity;

  CartItem copyWith({
    String? key,
    FoodItem? food,
    int? quantity,
    int? unitPrice,
    String? size,
    List<String>? addons,
  }) {
    return CartItem(
      key: key ?? this.key,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      size: size ?? this.size,
      addons: addons ?? this.addons,
    );
  }

  @override
  List<Object?> get props => [
    key,
    food,
    quantity,
    unitPrice,
    size,
    addons,
  ];
}
