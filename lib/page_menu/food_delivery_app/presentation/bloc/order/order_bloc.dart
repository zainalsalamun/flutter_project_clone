import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final OrderModel order;
  PlaceOrder(this.order);
  @override
  List<Object?> get props => [order];
}

class _UpdateOrderStatus extends OrderEvent {
  final OrderStatus status;
  _UpdateOrderStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class AdvanceOrderStatus extends OrderEvent {}

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}
class OrderProcessing extends OrderState {}
class OrderPlaced extends OrderState {
  final OrderModel order;
  OrderPlaced(this.order);
  @override
  List<Object?> get props => [order];
}
class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;
  Timer? _simulationTimer;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<PlaceOrder>((event, emit) async {
      emit(OrderProcessing());
      try {
        final order = await repository.createOrder(event.order);
        emit(OrderPlaced(order));
        _startSimulation();
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<_UpdateOrderStatus>((event, emit) async {
      if (state is OrderPlaced) {
        try {
          final updatedOrder = await repository.updateOrderStatus(event.status);
          if (updatedOrder != null) {
            emit(OrderPlaced(updatedOrder));
          }
        } catch (_) {}
      }
    });

    on<AdvanceOrderStatus>((event, emit) async {
      if (state is OrderPlaced) {
        final currentOrder = (state as OrderPlaced).order;
        final statuses = OrderStatus.values;
        final currentIndex = statuses.indexOf(currentOrder.status);
        if (currentIndex < statuses.length - 1) {
          final nextStatus = statuses[currentIndex + 1];
          final updatedOrder = await repository.updateOrderStatus(nextStatus);
          if (updatedOrder != null) {
            emit(OrderPlaced(updatedOrder));
          }
        }
      }
    });
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    int step = 1;
    final statuses = [
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.driverAssigned,
      OrderStatus.pickingUp,
      OrderStatus.onDelivery,
      OrderStatus.delivered,
    ];
    
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (step < statuses.length) {
        add(_UpdateOrderStatus(statuses[step]));
        step++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _simulationTimer?.cancel();
    return super.close();
  }
}
