import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
enum TaskStatus {
  @HiveField(0)
  todo,

  @HiveField(1)
  inProgress,
}

@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  TaskStatus status;

  @HiveField(4)
  TaskPriority priority;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.category = "General",
    required this.createdAt,
  });
}
