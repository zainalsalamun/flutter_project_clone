import 'package:equatable/equatable.dart';
import 'cart_item_model.dart';
import 'restaurant_model.dart';

enum OrderStatus {
  received,
  accepted,
  preparing,
  driverAssigned,
  pickingUp,
  onDelivery,
  delivered,
}

class OrderModel extends Equatable {
  final String id;
  final RestaurantModel restaurant;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double discount;
  final String paymentMethod;
  final String deliveryAddress;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.restaurant,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    this.discount = 0.0,
    required this.paymentMethod,
    required this.deliveryAddress,
    this.status = OrderStatus.received,
    required this.createdAt,
  });

  double get total => (subtotal + deliveryFee + serviceFee) - discount;

  OrderModel copyWith({
    OrderStatus? status,
  }) {
    return OrderModel(
      id: id,
      restaurant: restaurant,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      serviceFee: serviceFee,
      discount: discount,
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurant,
        items,
        subtotal,
        deliveryFee,
        serviceFee,
        discount,
        paymentMethod,
        deliveryAddress,
        status,
        createdAt,
      ];
}
