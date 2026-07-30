import '../datasources/local/cart_local_data_source.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepository({required this.localDataSource});

  Future<List<CartItemModel>> getCart() => localDataSource.getCart();

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final cart = await localDataSource.getCart();
    final index = cart.indexWhere((element) => element.product.id == product.id);
    if (index != -1) {
      cart[index] = cart[index].copyWith(quantity: cart[index].quantity + quantity);
    } else {
      cart.add(CartItemModel(product: product, quantity: quantity));
    }
    await localDataSource.saveCart(cart);
  }

  Future<void> removeFromCart(int productId) async {
    final cart = await localDataSource.getCart();
    cart.removeWhere((element) => element.product.id == productId);
    await localDataSource.saveCart(cart);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final cart = await localDataSource.getCart();
    final index = cart.indexWhere((element) => element.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index] = cart[index].copyWith(quantity: quantity);
      }
      await localDataSource.saveCart(cart);
    }
  }

  Future<void> clearCart() => localDataSource.clearCart();
}
