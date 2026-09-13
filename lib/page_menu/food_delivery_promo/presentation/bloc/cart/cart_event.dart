import 'package:equatable/equatable.dart';

import '../../../data/models/food_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  const AddToCartEvent({
    required this.food,
    required this.quantity,
    required this.unitPrice,
    required this.size,
    required this.addons,
  });

  final FoodItem food;
  final int quantity;
  final int unitPrice;
  final String size;
  final List<String> addons;

  @override
  List<Object?> get props => [food, quantity, unitPrice, size, addons];
}

class IncreaseQuantityEvent extends CartEvent {
  const IncreaseQuantityEvent(this.key);

  final String key;

  @override
  List<Object?> get props => [key];
}

class DecreaseQuantityEvent extends CartEvent {
  const DecreaseQuantityEvent(this.key);

  final String key;

  @override
  List<Object?> get props => [key];
}

class RemoveCartItemEvent extends CartEvent {
  const RemoveCartItemEvent(this.key);

  final String key;

  @override
  List<Object?> get props => [key];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
