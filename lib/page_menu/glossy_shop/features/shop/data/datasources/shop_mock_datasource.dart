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
        category: "Hoodie Premium",
        price: 350000.0,
        rating: 4.5,
        imageUrl: "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "Hoodie katun ultra premium dengan berat mantap, dirancang untuk kenyamanan streetwear modern. Memiliki desain bahu drop shoulder, sulaman grafis tepi presisi tinggi, dan tudung hangat berlapis ganda.",
        colors: [Colors.black, Colors.deepPurple, Colors.indigo],
        sizes: const ["S", "M", "L", "XL"],
      ),
      ProductModel(
        id: "2",
        name: "Gamer Gloves",
        category: "Sarung Tangan Musim Dingin",
        price: 150000.0,
        rating: 4.8,
        imageUrl: "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&auto=format&fit=crop&q=80",
        isNew: false,
        description: "Sarung tangan sentuh kompresi ergonomis dengan pola neon reflektif. Sangat cocok untuk bermain game di lingkungan dingin atau aktivitas luar ruangan, dilengkapi telapak tangan silikon anti-slip.",
        colors: const [Colors.pinkAccent, Colors.cyanAccent, Colors.amber],
        sizes: const ["M", "L"],
      ),
      ProductModel(
        id: "3",
        name: "All black retro",
        category: "Hoodie Klasik",
        price: 490000.0,
        rating: 4.9,
        imageUrl: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "Hoodie grafis estetika 90-an yang diciptakan kembali dengan desain sablon vintage antik. Menggunakan lapisan French Terry berbobot sedang dari katun organik ramah lingkungan premium.",
        colors: [Colors.grey.shade900, Colors.redAccent, Colors.blueGrey],
        sizes: const ["M", "L", "XL", "XXL"],
      ),
      ProductModel(
        id: "4",
        name: "Vortex Sneakers",
        category: "Sepatu Streetwear",
        price: 1350000.0,
        rating: 4.7,
        imageUrl: "https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&auto=format&fit=crop&q=80",
        isNew: true,
        description: "Sepatu kets tinggi futuristik terinspirasi gaya cyberpunk, dilengkapi kantung udara hijau neon transparan dan mekanisme pengunci otomatis. Sistem bantalan ultra responsif.",
        colors: const [Colors.lightGreenAccent, Colors.purpleAccent, Colors.white],
        sizes: const ["40", "41", "42", "43", "44"],
      ),
    ];
  }
}
