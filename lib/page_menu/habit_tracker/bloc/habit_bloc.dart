import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/habit_model.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(_initialState()) {
    on<ToggleHabitStatus>(_onToggleHabit);
    on<AddHabit>(_onAddHabit);
    on<DeleteHabit>(_onDeleteHabit);
  }

  static HabitState _initialState() {
    final now = DateTime.now();
    return HabitState(
      habits: [
        HabitModel(
          id: '1',
          title: 'Morning Run',
          emoji: '🏃‍♂️',
          color: const Color(0xFF10B981), // Emerald
          targetDays: 30,
          completedDates: [
            now.subtract(const Duration(days: 1)),
            now.subtract(const Duration(days: 2)),
            now.subtract(const Duration(days: 3)),
            now.subtract(const Duration(days: 4)),
            now.subtract(const Duration(days: 5)),
            now.subtract(const Duration(days: 6)),
          ],
        ),
        HabitModel(
          id: '2',
          title: 'Read Books',
          emoji: '📚',
          color: const Color(0xFF6366F1), // Indigo
          targetDays: 20,
          completedDates: [
            now,
            now.subtract(const Duration(days: 1)),
            now.subtract(const Duration(days: 3)),
            now.subtract(const Duration(days: 5)),
          ],
        ),
        HabitModel(
          id: '3',
          title: 'Drink Water',
          emoji: '💧',
          color: const Color(0xFF3B82F6), // Blue
          targetDays: 30,
          completedDates: [
             now.subtract(const Duration(days: 1)),
             now.subtract(const Duration(days: 2)),
          ],
        ),
      ],
    );
  }

  void _onToggleHabit(ToggleHabitStatus event, Emitter<HabitState> emit) {
    final targetDate = event.date ?? DateTime.now();
    
    final updatedHabits = state.habits.map((habit) {
      if (habit.id == event.id) {
        final isCompleted = habit.isCompletedOn(targetDate);
        
        List<DateTime> newDates = List.from(habit.completedDates);
        if (isCompleted) {
          newDates.removeWhere((d) => 
            d.year == targetDate.year && d.month == targetDate.month && d.day == targetDate.day
          );
        } else {
          newDates.add(targetDate);
        }
        
        return habit.copyWith(completedDates: newDates);
      }
      return habit;
    }).toList();
    
    emit(state.copyWith(habits: updatedHabits));
  }

  void _onAddHabit(AddHabit event, Emitter<HabitState> emit) {
    final updatedHabits = List<HabitModel>.from(state.habits)..add(event.habit);
    emit(state.copyWith(habits: updatedHabits));
  }

  void _onDeleteHabit(DeleteHabit event, Emitter<HabitState> emit) {
    final updatedHabits = state.habits.where((h) => h.id != event.id).toList();
    emit(state.copyWith(habits: updatedHabits));
  }
}
