import 'package:equatable/equatable.dart';

class FoodModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<AddonModel> availableAddons;

  const FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.availableAddons = const [],
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, availableAddons];
}

class AddonModel extends Equatable {
  final String id;
  final String name;
  final double price;

  const AddonModel({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}
