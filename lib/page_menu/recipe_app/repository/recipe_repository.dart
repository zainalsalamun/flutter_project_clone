import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeRepository {
  final ApiService _apiService = ApiService();
  static const String _favoritesKey = 'favorite_recipes_v1';

  Future<List<Recipe>> getRecipes() async {
    return await _apiService.fetchAllRecipes();
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    return await _apiService.searchRecipes(query);
  }

  // Favorites Management
  Future<List<Recipe>> getFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson != null && favoritesJson.isNotEmpty) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      return decodedList.map((json) => Recipe.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    List<Recipe> favorites = await getFavoriteRecipes();
    
    final existingIndex = favorites.indexWhere((r) => r.id == recipe.id);
    
    if (existingIndex >= 0) {
      // Remove if exists
      favorites.removeAt(existingIndex);
    } else {
      // Add if doesn't exist
      favorites.add(recipe);
    }
    
    final String encodedList = json.encode(
      favorites.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, encodedList);
  }

  Future<bool> isFavorite(int recipeId) async {
    List<Recipe> favorites = await getFavoriteRecipes();
    return favorites.any((r) => r.id == recipeId);
  }
}
