import 'package:flutter/material.dart';

class HabitItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool isCompleted;
  final int currentCount;
  final int targetCount;
  final String unit;

  const HabitItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.isCompleted = false,
    this.currentCount = 0,
    this.targetCount = 1,
    this.unit = '',
  });

  HabitItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? bgColor,
    bool? isCompleted,
    int? currentCount,
    int? targetCount,
    String? unit,
  }) {
    return HabitItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      bgColor: bgColor ?? this.bgColor,
      isCompleted: isCompleted ?? this.isCompleted,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      unit: unit ?? this.unit,
    );
  }
}
