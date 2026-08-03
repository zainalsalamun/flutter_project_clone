import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _storageKey = 'tasks_data_bloc';

  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_storageKey);
    if (tasksString != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksString);
      return decodedTasks.map((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTasks = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encodedTasks);
  }
}
