import 'package:equatable/equatable.dart';

abstract class TaskManagerEvent extends Equatable {
  const TaskManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskManagerEvent {}

class AddTask extends TaskManagerEvent {
  final String text;

  const AddTask(this.text);

  @override
  List<Object> get props => [text];
}

class ToggleTaskStatus extends TaskManagerEvent {
  final String id;

  const ToggleTaskStatus(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteTask extends TaskManagerEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeFilter extends TaskManagerEvent {
  final String filter; // all, pending, completed

  const ChangeFilter(this.filter);

  @override
  List<Object> get props => [filter];
}
