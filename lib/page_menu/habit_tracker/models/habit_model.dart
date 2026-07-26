import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class HabitModel extends Equatable {
  final String id;
  final String title;
  final String emoji;
  final Color color;
  final int targetDays;
  final String frequency; // 'Daily', 'Weekly'
  final List<DateTime> completedDates;

  const HabitModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    this.targetDays = 30,
    this.frequency = 'Daily',
    this.completedDates = const [],
  });

  HabitModel copyWith({
    String? id,
    String? title,
    String? emoji,
    Color? color,
    int? targetDays,
    String? frequency,
    List<DateTime>? completedDates,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      targetDays: targetDays ?? this.targetDays,
      frequency: frequency ?? this.frequency,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) => 
      d.year == date.year && d.month == date.month && d.day == date.day
    );
  }

  bool get isCompletedToday => isCompletedOn(DateTime.now());

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    
    // Sort descending
    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // If not completed today, start checking from yesterday
    if (!isCompletedToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      if (date.year == checkDate.year && date.month == checkDate.month && date.day == checkDate.day) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        // Gap detected
        break;
      }
    }
    return streak;
  }

  int get bestStreak {
     if (completedDates.isEmpty) return 0;
     final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => a.compareTo(b)); // Ascending

     int maxStreak = 1;
     int current = 1;
     for (int i = 1; i < sortedDates.length; i++) {
       final diff = sortedDates[i].difference(sortedDates[i-1]).inDays;
       if (diff == 1) {
         current++;
         if (current > maxStreak) maxStreak = current;
       } else if (diff > 0) {
         current = 1; // reset streak if gap is > 1 day. diff 0 means same day.
       }
     }
     return maxStreak;
  }

  double get progress => (completedDates.length / targetDays).clamp(0.0, 1.0);

  @override
  List<Object> get props => [id, title, emoji, color, targetDays, frequency, completedDates];
}
