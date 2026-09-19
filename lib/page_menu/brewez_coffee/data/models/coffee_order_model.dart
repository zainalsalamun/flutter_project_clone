import 'coffee_addon_model.dart';

enum PaymentType {
  qris,
  gopay,
  ovo,
  dana,
  shopeepay,
  bcaVa,
  mandiriVa,
  briVa,
  cash,
}

class CoffeeOrderItem {
  final String name;
  final String? subtitle;
  final String? image;
  final String size; // S, M, L
  final bool isHot;
  final int sweetness; // 0, 50, 70, 100
  final Set<AddonType> selectedAddons;
  final double unitPrice;
  final int quantity;

  const CoffeeOrderItem({
    required this.name,
    this.subtitle,
    this.image,
    required this.size,
    required this.isHot,
    required this.sweetness,
    required this.selectedAddons,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;
}

class CoffeeOrderModel {
  final String orderId;
  final String queueNumber;
  final List<CoffeeOrderItem> items;
  final double subtotal;
  final double discount;
  final double serviceFee;
  final double totalAmount;
  final PaymentType paymentType;
  final String paymentReference;
  final DateTime orderTime;
  final String? promoCode;

  const CoffeeOrderModel({
    required this.orderId,
    required this.queueNumber,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.serviceFee,
    required this.totalAmount,
    required this.paymentType,
    required this.paymentReference,
    required this.orderTime,
    this.promoCode,
  });

  int get totalItemsCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}
