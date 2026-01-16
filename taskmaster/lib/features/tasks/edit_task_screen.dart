import 'package:flutter/material.dart';
import '../../storage/task_store.dart';
import 'task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TaskPriority _priority;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController =
        TextEditingController(text: widget.task.description ?? "");
    _priority = widget.task.priority;
    _category = widget.task.category;
  }

  void _save() {
    widget.task.title = _titleController.text;
    widget.task.description = _descController.text;
    widget.task.priority = _priority;
    widget.task.category = _category;

    TaskStore.updateTask(widget.task);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
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
              controller: TextEditingController(text: _category),
              onChanged: (value) {
                _category = value.isEmpty ? "General" : value;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
