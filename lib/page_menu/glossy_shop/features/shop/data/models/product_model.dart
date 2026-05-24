import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.rating,
    required super.imageUrl,
    required super.isNew,
    required super.description,
    required super.colors,
    required super.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isNew: json['isNew'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      colors: (json['colors'] as List<dynamic>? ?? [])
          .map((c) => Color(c as int))
          .toList(),
      sizes: List<String>.from(json['sizes'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'isNew': isNew,
      'description': description,
      'colors': colors.map((c) => c.value).toList(),
      'sizes': sizes,
    };
  }
}
