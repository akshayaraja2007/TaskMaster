import 'package:flutter/material.dart';
import '../../features/tasks/task_model.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        label = "LOW";
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = "MED";
        break;
      case TaskPriority.high:
        color = Colors.red;
        label = "HIGH";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
