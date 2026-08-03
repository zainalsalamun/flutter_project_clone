import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      emit(const DashboardLoaded(
        userName: 'Zainal Salamun',
        balance: 25500000.0,
        accountNumber: '1234567890',
        isBalanceVisible: true,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onToggleBalanceVisibility(
    ToggleBalanceVisibility event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(
        isBalanceVisible: !currentState.isBalanceVisible,
      ));
    }
  }
}
