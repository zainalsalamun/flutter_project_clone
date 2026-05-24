import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ShopMockDatasource {
  Future<List<CategoryModel>> getCategories() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const CategoryModel(
        name: "Nike",
        imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop&q=60",
      ),
      const CategoryModel(
        name: "Lacoste",
        // Replaced 404 image with a highly reliable Unsplash polo shirt texture asset
        imageUrl: "https://images.unsplash.com/photo-1582533561751-ef6f6ab93a2e?w=400&auto=format&fit=crop&q=60",
      ),
      const CategoryModel(
        name: "Edge",
        imageUrl: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400&auto=format&fit=crop&q=60",
      ),
      const CategoryModel(
        name: "Prada",
        imageUrl: "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop&q=60",
      ),
      const CategoryModel(
        name: "Adidas",
        imageUrl: "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400&auto=format&fit=crop&q=60",
      ),
    ];
  }

  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ProductModel(
        id: "1",
        name: "Edge runner-Black",
        category: "Premium Hoodie",
        price: 23.65,
        rating: 4.5,
        imageUrl: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "Premium ultra-cotton heavyweight hoodie designed for modern street comfort. Features drop shoulder sleeves, high-density edge graphic embroidery, and double-lined cozy hood.",
        colors: [Colors.black, Colors.deepPurple, Colors.indigo],
        sizes: const ["S", "M", "L", "XL"],
      ),
      ProductModel(
        id: "2",
        name: "Gamer Gloves",
        category: "Winter Gloves",
        price: 10.60,
        rating: 4.8,
        imageUrl: "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&auto=format&fit=crop&q=80",
        isNew: false,
        description: "Ergonomic compression touch gloves with neon reflective patterns. Perfect for gaming in cold environments or active outdoor use, featuring micro-grip silicone palms.",
        colors: const [Colors.pinkAccent, Colors.cyanAccent, Colors.amber],
        sizes: const ["M", "L"],
      ),
      ProductModel(
        id: "3",
        name: "All black retro",
        category: "Classic Hoodie",
        price: 32.95,
        rating: 4.9,
        imageUrl: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "Reinvented 90s aesthetic graphic hoodie with distressed hem and vintage screenprint design. Midweight French Terry lining, crafted with premium sustainably sourced organic cotton.",
        colors: [Colors.grey.shade900, Colors.redAccent, Colors.blueGrey],
        sizes: const ["M", "L", "XL", "XXL"],
      ),
      ProductModel(
        id: "4",
        name: "Vortex Sneakers",
        category: "Street Shoes",
        price: 89.99,
        rating: 4.7,
        imageUrl: "https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "High-top cyberpunk inspired sneakers featuring translucent neon green air pods and an auto-tensioning secure lock mechanism. Ultra responsive cushioning system.",
        colors: const [Colors.lightGreenAccent, Colors.purpleAccent, Colors.white],
        sizes: const ["40", "41", "42", "43", "44"],
      ),
    ];
  }
}
