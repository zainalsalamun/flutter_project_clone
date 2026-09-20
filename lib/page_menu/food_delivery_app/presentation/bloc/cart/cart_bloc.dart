import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/cart_repository.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}
class AddToCart extends CartEvent {
  final FoodModel food;
  final RestaurantModel restaurant;
  final int quantity;
  final List<AddonModel> selectedAddons;
  final String notes;

  AddToCart(this.food, this.restaurant, {this.quantity = 1, this.selectedAddons = const [], this.notes = ''});

  @override
  List<Object?> get props => [food, restaurant, quantity, selectedAddons, notes];
}
class RemoveFromCart extends CartEvent {
  final CartItemModel item;
  RemoveFromCart(this.item);
  @override
  List<Object?> get props => [item];
}
class UpdateCartQuantity extends CartEvent {
  final CartItemModel item;
  final int quantity;
  UpdateCartQuantity(this.item, this.quantity);
  @override
  List<Object?> get props => [item, quantity];
}
class ClearCart extends CartEvent {}

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final List<CartItemModel> items;
  CartLoaded(this.items);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => items.isNotEmpty ? items.first.restaurant.deliveryFee : 0;
  double get serviceFee => items.isNotEmpty ? 2000 : 0; // Fixed dummy fee
  double get total => subtotal + deliveryFee + serviceFee;

  RestaurantModel? get restaurant => items.isNotEmpty ? items.first.restaurant : null;

  @override
  List<Object?> get props => [items];
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
  @override
  List<Object?> get props => [message];
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await repository.getCart();
        emit(CartLoaded(List.from(items)));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<AddToCart>((event, emit) async {
      try {
        await repository.addToCart(
          event.food,
          event.restaurant,
          quantity: event.quantity,
          selectedAddons: event.selectedAddons,
          notes: event.notes,
        );
        final items = await repository.getCart();
        emit(CartLoaded(List.from(items)));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      try {
        await repository.removeFromCart(event.item);
        final items = await repository.getCart();
        emit(CartLoaded(List.from(items)));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<UpdateCartQuantity>((event, emit) async {
      try {
        await repository.updateQuantity(event.item, event.quantity);
        final items = await repository.getCart();
        emit(CartLoaded(List.from(items)));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<ClearCart>((event, emit) async {
      try {
        await repository.clearCart();
        emit(CartLoaded(const []));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
  }
}
