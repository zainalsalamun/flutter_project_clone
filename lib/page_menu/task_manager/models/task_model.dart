import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String text;
  final bool completed;

  const TaskModel({
    required this.id,
    required this.text,
    this.completed = false,
  });

  TaskModel copyWith({
    String? id,
    String? text,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'completed': completed,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      text: json['text'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, text, completed];
}
