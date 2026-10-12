import 'package:flutter/material.dart';

enum WidgetCategory {
  all(title: 'Semua', icon: Icons.grid_view_rounded, color: Color(0xFF6366F1)),
  buttons(
    title: 'Buttons',
    icon: Icons.smart_button_rounded,
    color: Color(0xFF3B82F6),
  ),
  inputs(
    title: 'Inputs & Forms',
    icon: Icons.text_fields_rounded,
    color: Color(0xFF10B981),
  ),
  cards(
    title: 'Cards & Surfaces',
    icon: Icons.dashboard_customize_rounded,
    color: Color(0xFF8B5CF6),
  ),
  navigation(
    title: 'Navigation',
    icon: Icons.navigation_rounded,
    color: Color(0xFFF59E0B),
  ),
  dialogs(
    title: 'Dialogs & Sheets',
    icon: Icons.chat_bubble_outline_rounded,
    color: Color(0xFFEC4899),
  ),
  loaders(
    title: 'Loaders & Shimmers',
    icon: Icons.hourglass_top_rounded,
    color: Color(0xFF06B6D4),
  ),
  badges(
    title: 'Badges & Chips',
    icon: Icons.label_rounded,
    color: Color(0xFF14B8A6),
  ),
  animations(
    title: 'Animations & Gestures',
    icon: Icons.animation_rounded,
    color: Color(0xFFEF4444),
  );

  final String title;
  final IconData icon;
  final Color color;

  const WidgetCategory({
    required this.title,
    required this.icon,
    required this.color,
  });
}
