import 'package:flutter/material.dart';
import '../../storage/task_store.dart';
import '../tasks/task_model.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  void _delete(Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete permanently?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                TaskStore.deleteCompleted(task);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = TaskStore.completed;

    return Scaffold(
      appBar: AppBar(title: const Text("Completed Tasks")),
      body: completed.isEmpty
          ? const Center(child: Text("No completed tasks"))
          : ListView.builder(
              itemCount: completed.length,
              itemBuilder: (context, index) {
                final task = completed[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: task.description?.isNotEmpty == true
                      ? Text(task.description!)
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _delete(task),
                  ),
                );
              },
            ),
    );
  }
}
