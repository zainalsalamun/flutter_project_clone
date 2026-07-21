import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/shop_repository.dart';

class ShopNotifier extends ChangeNotifier {
  final ShopRepository repository;

  ShopNotifier(this.repository);

  List<CategoryEntity> _categories = [];
  List<ProductEntity> _products = [];
  bool _isLoading = false;
  bool _isDarkMode = true; // Default theme is dark mode

  List<CategoryEntity> get categories => _categories;
  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;

  // Theme Management
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Cart Management
  final Map<String, int> _cart = {}; // productId -> quantity
  Map<String, int> get cart => _cart;

  int get cartCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  void addToCart(String productId, int quantity) {
    _cart[productId] = (_cart[productId] ?? 0) + quantity;
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> loadShopData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await repository.fetchCategories();
      _products = await repository.fetchProducts();
    } catch (e) {
      debugPrint("Error loading shop data in ShopNotifier: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
