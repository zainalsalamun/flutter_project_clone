import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  const NavigationState({this.selectedTabIndex = 0});

  final int selectedTabIndex;

  NavigationState copyWith({int? selectedTabIndex}) {
    return NavigationState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex];
}
