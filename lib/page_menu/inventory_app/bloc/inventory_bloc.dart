import 'package:flutter_bloc/flutter_bloc.dart';
import '../inventory_models.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial()) {
    on<LoadInventoryEvent>(_onLoadInventoryEvent);
  }

  Future<void> _onLoadInventoryEvent(
    LoadInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Load dummy data
      final items = dummyInventory;
      
      emit(InventoryLoaded(items));
    } catch (e) {
      emit(InventoryError("Failed to load inventory: ${e.toString()}"));
    }
  }
}
