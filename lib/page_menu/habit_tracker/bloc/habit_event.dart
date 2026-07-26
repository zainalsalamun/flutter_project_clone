import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class ToggleHabitStatus extends HabitEvent {
  final String id;
  final DateTime? date;

  const ToggleHabitStatus(this.id, {this.date});

  @override
  List<Object> get props => [id, date ?? DateTime.now()];
}

class AddHabit extends HabitEvent {
  final HabitModel habit;

  const AddHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final String id;

  const DeleteHabit(this.id);

  @override
  List<Object> get props => [id];
}
