import 'package:flutter/material.dart';

class ProductEntity {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isNew;
  final String description;
  final List<Color> colors;
  final List<String> sizes;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.isNew,
    required this.description,
    required this.colors,
    required this.sizes,
  });
}
