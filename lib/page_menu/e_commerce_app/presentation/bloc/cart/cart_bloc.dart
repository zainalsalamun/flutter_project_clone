import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/cart_repository.dart';

// --- Events ---
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoadCart extends CartEvent {}
class AddToCart extends CartEvent {
  final ProductModel product;
  final int quantity;
  AddToCart(this.product, {this.quantity = 1});
  @override
  List<Object?> get props => [product, quantity];
}
class RemoveFromCart extends CartEvent {
  final int productId;
  RemoveFromCart(this.productId);
  @override
  List<Object?> get props => [productId];
}
class UpdateCartQuantity extends CartEvent {
  final int productId;
  final int quantity;
  UpdateCartQuantity(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}
class ClearCart extends CartEvent {}

// --- States ---
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final List<CartItemModel> items;
  CartLoaded(this.items);
  
  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  
  @override
  List<Object?> get props => [items];
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await repository.getCart();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<AddToCart>((event, emit) async {
      try {
        await repository.addToCart(event.product, quantity: event.quantity);
        final items = await repository.getCart();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      try {
        await repository.removeFromCart(event.productId);
        final items = await repository.getCart();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<UpdateCartQuantity>((event, emit) async {
      try {
        await repository.updateQuantity(event.productId, event.quantity);
        final items = await repository.getCart();
        emit(CartLoaded(items));
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
