import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

class TaskManagerState extends Equatable {
  final List<TaskModel> tasks;
  final String currentFilter;
  final bool isLoading;

  const TaskManagerState({
    this.tasks = const [],
    this.currentFilter = 'all',
    this.isLoading = false,
  });

  TaskManagerState copyWith({
    List<TaskModel>? tasks,
    String? currentFilter,
    bool? isLoading,
  }) {
    return TaskManagerState(
      tasks: tasks ?? this.tasks,
      currentFilter: currentFilter ?? this.currentFilter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((task) => task.completed).length;

  List<TaskModel> get filteredTasks {
    if (currentFilter == 'pending') {
      return tasks.where((task) => !task.completed).toList();
    } else if (currentFilter == 'completed') {
      return tasks.where((task) => task.completed).toList();
    }
    return tasks;
  }

  @override
  List<Object> get props => [tasks, currentFilter, isLoading];
}
