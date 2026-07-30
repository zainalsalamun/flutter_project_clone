import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartKey = 'cart_items';

  Future<void> saveCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, jsonString);
  }

  Future<List<CartItemModel>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CartItemModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
