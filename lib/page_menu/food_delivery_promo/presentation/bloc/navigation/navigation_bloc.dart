import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<ChangeTabEvent>(_onChangeTab);
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<NavigationState> emit) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }
}
