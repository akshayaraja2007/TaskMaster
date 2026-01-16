import 'package:flutter/material.dart';
import '../../storage/task_store.dart';
import 'task_model.dart';
import 'dart:math';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  String _category = "General";

  void _saveTask() {
    if (_titleController.text.isEmpty) return;

    final task = Task(
      id: Random().nextInt(100000).toString(),
      title: _titleController.text,
      description: _descController.text,
      priority: _priority,
      category: _category,
      createdAt: DateTime.now(),
    );

    TaskStore.addTask(task);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration:
                  const InputDecoration(labelText: "Description (optional)"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              items: const [
                DropdownMenuItem(value: TaskPriority.low, child: Text("Low")),
                DropdownMenuItem(value: TaskPriority.medium, child: Text("Medium")),
                DropdownMenuItem(value: TaskPriority.high, child: Text("High")),
              ],
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Priority"),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: "Category"),
              onChanged: (value) {
                _category = value.isEmpty ? "General" : value;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
