import 'package:flutter/material.dart';

class HabitMetric {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const HabitMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class DailySleepRecord {
  final String dayName;
  final double hours;
  final bool isHighlight;

  const DailySleepRecord({
    required this.dayName,
    required this.hours,
    this.isHighlight = false,
  });
}
