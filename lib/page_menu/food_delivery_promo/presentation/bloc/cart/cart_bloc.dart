import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(items: [])) {
    on<AddToCartEvent>(_onAddToCart);
    on<IncreaseQuantityEvent>(_onIncreaseQuantity);
    on<DecreaseQuantityEvent>(_onDecreaseQuantity);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final key = '${event.food.id}-${event.size}-${event.addons.join(',')}';
    final items = [...state.items];
    final index = items.indexWhere((item) => item.key == key);

    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(
        quantity: current.quantity + event.quantity,
      );
    } else {
      items.add(
        CartItem(
          key: key,
          food: event.food,
          quantity: event.quantity,
          unitPrice: event.unitPrice,
          size: event.size,
          addons: event.addons,
        ),
      );
    }

    emit(CartState(items: items));
  }

  void _onIncreaseQuantity(
    IncreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item.key == event.key) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    emit(CartState(items: updatedItems));
  }

  void _onDecreaseQuantity(
    DecreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final updatedItems = state.items
        .map((item) {
          if (item.key == event.key) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();

    emit(CartState(items: updatedItems));
  }

  void _onRemoveCartItem(RemoveCartItemEvent event, Emitter<CartState> emit) {
    final updatedItems =
        state.items.where((item) => item.key != event.key).toList();
    emit(CartState(items: updatedItems));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
