import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_account.dart';
import 'abc_event.dart';
import 'abc_state.dart';

class AbcBloc extends Bloc<AbcEvent, AbcState> {
  AbcBloc() : super(AbcInitial()) {
    on<LoadAccountData>(_onLoadAccountData);
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
  }

  Future<void> _onLoadAccountData(
    LoadAccountData event,
    Emitter<AbcState> emit,
  ) async {
    emit(AbcLoading());
    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 1));
      
      // Use dummy data
      final account = UserAccount.dummyData;
      emit(AbcLoaded(account: account));
    } catch (e) {
      emit(AbcError("Failed to load account data"));
    }
  }

  void _onToggleBalanceVisibility(
    ToggleBalanceVisibility event,
    Emitter<AbcState> emit,
  ) {
    if (state is AbcLoaded) {
      final currentState = state as AbcLoaded;
      emit(currentState.copyWith(
        isBalanceVisible: !currentState.isBalanceVisible,
      ));
    }
  }
}
