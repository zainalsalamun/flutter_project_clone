import 'package:flutter/material.dart';
import 'widget_category.dart';

enum WidgetDifficulty {
  beginner(label: 'Beginner', color: Color(0xFF10B981)),
  intermediate(label: 'Intermediate', color: Color(0xFFF59E0B)),
  advanced(label: 'Advanced', color: Color(0xFFEF4444));

  final String label;
  final Color color;
  const WidgetDifficulty({required this.label, required this.color});
}

class WidgetItem {
  final String id;
  final String title;
  final String description;
  final WidgetCategory category;
  final WidgetDifficulty difficulty;
  final IconData icon;
  final List<String> tags;
  final String codeSnippet;
  final String? usageTips;
  final Widget Function(BuildContext context) previewBuilder;

  const WidgetItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = WidgetDifficulty.beginner,
    required this.icon,
    required this.tags,
    required this.codeSnippet,
    this.usageTips,
    required this.previewBuilder,
  });
}
