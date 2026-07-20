import 'package:flutter/material.dart';

class SoundPresetEntity {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final Color glowColor;
  final Gradient backgroundGradient;
  final double volume; // 0.0 to 1.0

  const SoundPresetEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.glowColor,
    required this.backgroundGradient,
    this.volume = 0.0,
  });

  SoundPresetEntity copyWith({
    String? id,
    String? name,
    String? category,
    IconData? icon,
    Color? glowColor,
    Gradient? backgroundGradient,
    double? volume,
  }) {
    return SoundPresetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      glowColor: glowColor ?? this.glowColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      volume: volume ?? this.volume,
    );
  }
}
