import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

class HabitState extends Equatable {
  final List<HabitModel> habits;

  const HabitState({this.habits = const []});

  HabitState copyWith({
    List<HabitModel>? habits,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
    );
  }

  int get completedTodayCount => habits.where((h) => h.isCompletedToday).length;
  int get totalHabits => habits.length;

  @override
  List<Object> get props => [habits];
}
