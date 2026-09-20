import 'package:equatable/equatable.dart';
import 'food_model.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final double distance;
  final int deliveryTimeMin;
  final double deliveryFee;
  final List<String> categories;
  final List<FoodModel> menu;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.deliveryTimeMin,
    required this.deliveryFee,
    required this.categories,
    required this.menu,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rating,
        distance,
        deliveryTimeMin,
        deliveryFee,
        categories,
        menu,
      ];
}
