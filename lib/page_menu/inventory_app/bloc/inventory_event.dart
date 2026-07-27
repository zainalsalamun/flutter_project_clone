import 'package:equatable/equatable.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadInventoryEvent extends InventoryEvent {}
