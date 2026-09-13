import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends NavigationEvent {
  const ChangeTabEvent(this.tabIndex);

  final int tabIndex;

  @override
  List<Object?> get props => [tabIndex];
}
