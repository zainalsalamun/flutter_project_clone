import 'package:equatable/equatable.dart';

import '../../../data/models/cart_item_model.dart';

class CartState extends Equatable {
  const CartState({required this.items});

  final List<CartItem> items;

  int get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get deliveryFee => items.isEmpty ? 0 : 12000;
  int get serviceFee => items.isEmpty ? 0 : 5000;
  int get discount => items.isEmpty ? 0 : 10000;
  int get total =>
      items.isEmpty ? 0 : (subtotal + deliveryFee + serviceFee - discount);
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
