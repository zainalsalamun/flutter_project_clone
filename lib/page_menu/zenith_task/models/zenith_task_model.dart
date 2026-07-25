import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ZenithTaskModel extends Equatable {
  final String id;
  final String title;
  final String tag;
  final Color color;
  final bool done;

  const ZenithTaskModel({
    required this.id,
    required this.title,
    required this.tag,
    required this.color,
    this.done = false,
  });

  ZenithTaskModel copyWith({
    String? id,
    String? title,
    String? tag,
    Color? color,
    bool? done,
  }) {
    return ZenithTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      color: color ?? this.color,
      done: done ?? this.done,
    );
  }

  @override
  List<Object> get props => [id, title, tag, color, done];
}
