import 'package:flutter/material.dart';
import '../features/kanban/kanban_screen.dart';
import '../features/tasks/add_task_screen.dart';
import '../features/completed/completed_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const KanbanScreen(),
    '/add-task': (context) => const AddTaskScreen(),
    '/completed': (context) => const CompletedScreen(),
  };
}
