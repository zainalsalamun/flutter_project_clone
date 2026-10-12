import 'package:flutter/material.dart';

enum BasicWidgetCategory {
  all(
    title: 'Semua',
    icon: Icons.apps_rounded,
    color: Color(0xFF6366F1),
    description: 'Semua kumpulan widget dasar Flutter',
  ),
  layout(
    title: 'Layout & Struktur',
    icon: Icons.dashboard_rounded,
    color: Color(0xFF3B82F6),
    description: 'Container, Row, Column, Stack, Expanded, Wrap, Align, dll.',
  ),
  typography(
    title: 'Text & Media',
    icon: Icons.text_fields_rounded,
    color: Color(0xFF10B981),
    description: 'Text, RichText, Image, Icon, CircleAvatar, dll.',
  ),
  buttons(
    title: 'Tombol & Interaksi',
    icon: Icons.smart_button_rounded,
    color: Color(0xFFF59E0B),
    description: 'ElevatedButton, OutlinedButton, FAB, InkWell, Gestures, dll.',
  ),
  inputs(
    title: 'Form & Input',
    icon: Icons.edit_note_rounded,
    color: Color(0xFF8B5CF6),
    description: 'TextField, Checkbox, Switch, Radio, Slider, Dropdown, dll.',
  ),
  lists(
    title: 'List, Grid & Tabel',
    icon: Icons.view_agenda_rounded,
    color: Color(0xFF06B6D4),
    description: 'ListView, GridView, ListTile, Card, DataTable, Divider, dll.',
  ),
  feedback(
    title: 'Dialog & Feedback',
    icon: Icons.notifications_active_rounded,
    color: Color(0xFFEF4444),
    description: 'AlertDialog, SnackBar, BottomSheet, Progress, Tooltip, dll.',
  );

  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const BasicWidgetCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}
