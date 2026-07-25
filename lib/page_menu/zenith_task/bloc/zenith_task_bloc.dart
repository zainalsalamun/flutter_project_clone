import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/zenith_task_model.dart';
import 'zenith_task_event.dart';
import 'zenith_task_state.dart';

class ZenithTaskBloc extends Bloc<ZenithTaskEvent, ZenithTaskState> {
  ZenithTaskBloc() : super(_initialState()) {
    on<ToggleZenithTask>(_onToggleTask);
    on<AddZenithTask>(_onAddTask);
  }

  static ZenithTaskState _initialState() {
    return ZenithTaskState(
      tasks: [
        const ZenithTaskModel(
          id: '1',
          title: 'Design Neo-Brutalism UI',
          tag: 'WORK',
          color: Color(0xFFFEF08A),
          done: false,
        ),
        const ZenithTaskModel(
          id: '2',
          title: 'Buy groceries',
          tag: 'PERSONAL',
          color: Color(0xFFA7F3D0),
          done: true,
        ),
        const ZenithTaskModel(
          id: '3',
          title: 'Finish Flutter Project',
          tag: 'CODE',
          color: Color(0xFFDDD6FE),
          done: false,
        ),
      ],
    );
  }

  void _onToggleTask(ToggleZenithTask event, Emitter<ZenithTaskState> emit) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == event.id) {
        return task.copyWith(done: !task.done);
      }
      return task;
    }).toList();
    
    emit(state.copyWith(tasks: updatedTasks));
  }

  void _onAddTask(AddZenithTask event, Emitter<ZenithTaskState> emit) {
    final updatedTasks = List<ZenithTaskModel>.from(state.tasks)..add(event.task);
    emit(state.copyWith(tasks: updatedTasks));
  }
}
