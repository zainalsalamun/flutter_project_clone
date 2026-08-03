import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import 'task_manager_event.dart';
import 'task_manager_state.dart';

class TaskManagerBloc extends Bloc<TaskManagerEvent, TaskManagerState> {
  final TaskRepository _repository;

  TaskManagerBloc({required TaskRepository repository})
      : _repository = repository,
        super(const TaskManagerState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
    on<DeleteTask>(_onDeleteTask);
    on<ChangeFilter>(_onChangeFilter);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskManagerState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tasks = await _repository.getTasks();
    emit(state.copyWith(tasks: tasks, isLoading: false));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskManagerState> emit) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
    );
    final updatedTasks = List<TaskModel>.from(state.tasks)..insert(0, newTask);
    
    emit(state.copyWith(tasks: updatedTasks));
    await _repository.saveTasks(updatedTasks);
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatus event, Emitter<TaskManagerState> emit) async {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == event.id) {
        return task.copyWith(completed: !task.completed);
      }
      return task;
    }).toList();
    
    emit(state.copyWith(tasks: updatedTasks));
    await _repository.saveTasks(updatedTasks);
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskManagerState> emit) async {
    final updatedTasks = state.tasks.where((task) => task.id != event.id).toList();
    
    emit(state.copyWith(tasks: updatedTasks));
    await _repository.saveTasks(updatedTasks);
  }

  void _onChangeFilter(ChangeFilter event, Emitter<TaskManagerState> emit) {
    emit(state.copyWith(currentFilter: event.filter));
  }
}
