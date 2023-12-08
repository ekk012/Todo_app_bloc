import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  static const String tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? taskListString = prefs.getStringList(tasksKey);

      if (taskListString != null) {
        return taskListString.map((taskString) {
          return Task.fromMap(Task.decodeJson(taskString));
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Handle exceptions accordingly (logging, error reporting, etc.)
      print('Error loading tasks: $e');
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskListString =
        tasks.map((task) => task.encodeJson()).toList();

    await prefs.setStringList(tasksKey, taskListString);
  } catch (e) {
    // Handle save failures, e.g., log, report, or throw
    print('Error saving tasks: $e');
    throw Exception('Failed to save tasks');
  }
}

}
