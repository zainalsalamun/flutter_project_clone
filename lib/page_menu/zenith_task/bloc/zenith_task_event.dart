import 'package:equatable/equatable.dart';
import '../models/zenith_task_model.dart';

abstract class ZenithTaskEvent extends Equatable {
  const ZenithTaskEvent();

  @override
  List<Object> get props => [];
}

class ToggleZenithTask extends ZenithTaskEvent {
  final String id;

  const ToggleZenithTask(this.id);

  @override
  List<Object> get props => [id];
}

class AddZenithTask extends ZenithTaskEvent {
  final ZenithTaskModel task;

  const AddZenithTask(this.task);

  @override
  List<Object> get props => [task];
}
