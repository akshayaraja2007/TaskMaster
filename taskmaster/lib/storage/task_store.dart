import 'package:hive/hive.dart';
import '../features/tasks/task_model.dart';

class TaskStore {
  static late Box<Task> _taskBox;
  static late Box<Task> _completedBox;

  static Future<void> init() async {
    _taskBox = Hive.box<Task>('tasks');
    _completedBox = Hive.box<Task>('completed');
  }

  static List<Task> get allTasks => _taskBox.values.toList();
  static List<Task> get completed => _completedBox.values.toList();

  static void addTask(Task task) {
    _taskBox.put(task.id, task);
  }

  static void updateTask(Task task) {
    _taskBox.put(task.id, task);
  }

  static void deleteTask(Task task) {
    _taskBox.delete(task.id);
  }

  static void markCompleted(Task task) {
    _taskBox.delete(task.id);
    _completedBox.put(task.id, task);
  }

  static void undoComplete(Task task) {
    _completedBox.delete(task.id);
    task.status = TaskStatus.todo;
    _taskBox.put(task.id, task);
  }

  static void deleteCompleted(Task task) {
    _completedBox.delete(task.id);
  }

  static List<Task> byStatus(TaskStatus status) {
    return _taskBox.values.where((t) => t.status == status).toList();
  }
}
