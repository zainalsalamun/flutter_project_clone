import 'package:equatable/equatable.dart';
import '../models/zenith_task_model.dart';

class ZenithTaskState extends Equatable {
  final List<ZenithTaskModel> tasks;

  const ZenithTaskState({this.tasks = const []});

  ZenithTaskState copyWith({
    List<ZenithTaskModel>? tasks,
  }) {
    return ZenithTaskState(
      tasks: tasks ?? this.tasks,
    );
  }

  int get pendingTasksCount => tasks.where((t) => !t.done).length;
  int get totalTasksCount => tasks.length;
  double get completionPercentage => 
      totalTasksCount == 0 ? 0.0 : ((totalTasksCount - pendingTasksCount) / totalTasksCount);

  @override
  List<Object> get props => [tasks];
}
