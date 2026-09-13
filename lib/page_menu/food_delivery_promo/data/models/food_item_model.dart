import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FoodItem extends Equatable {
  const FoodItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.category,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.color,
  });

  final String id;
  final String name;
  final String restaurant;
  final String category;
  final double rating;
  final int price;
  final String imageUrl;
  final String description;
  final Color color;

  String get heroTag => 'food-image-$id';

  @override
  List<Object?> get props => [
    id,
    name,
    restaurant,
    category,
    rating,
    price,
    imageUrl,
    description,
    color,
  ];
}

class SizeOption extends Equatable {
  const SizeOption({required this.name, required this.priceDelta});

  final String name;
  final int priceDelta;

  @override
  List<Object?> get props => [name, priceDelta];
}

class AddonOption extends Equatable {
  const AddonOption({required this.name, required this.price});

  final String name;
  final int price;

  @override
  List<Object?> get props => [name, price];
}
