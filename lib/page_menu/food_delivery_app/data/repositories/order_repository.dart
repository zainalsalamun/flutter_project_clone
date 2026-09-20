import '../models/order_model.dart';

class OrderRepository {
  OrderModel? _currentOrder;

  Future<OrderModel> createOrder(OrderModel order) async {
    // Simulate network
    await Future.delayed(const Duration(seconds: 1));
    final newOrder = order.copyWith(status: OrderStatus.received);
    _currentOrder = newOrder;
    return newOrder;
  }

  Future<OrderModel?> getCurrentOrder() async {
    return _currentOrder;
  }

  Future<OrderModel?> updateOrderStatus(OrderStatus status) async {
    if (_currentOrder != null) {
      _currentOrder = _currentOrder!.copyWith(status: status);
      return _currentOrder;
    }
    return null;
  }
}
