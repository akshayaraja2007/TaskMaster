import 'package:flutter/material.dart';
import '../../storage/task_store.dart';
import '../tasks/task_model.dart';
import '../../core/widgets/priority_badge.dart';
import '../tasks/edit_task_screen.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key});

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  void _refresh() => setState(() {});

  void _completeTask(Task task) {
    TaskStore.markCompleted(task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task completed"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              TaskStore.undoComplete(task);
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete task?"),
        content: const Text("This action can be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                TaskStore.deleteTask(task);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Task deleted"),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      setState(() {
                        TaskStore.undoDelete();
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = TaskStore.byStatus(TaskStatus.todo);
    final inProgress = TaskStore.byStatus(TaskStatus.inProgress);

    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskMaster"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/completed')
                  .then((_) => _refresh());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-task');
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          _buildColumn("To Do", todo),
          _buildColumn("In Progress", inProgress),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<Task> tasks) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Dismissible(
                    key: ValueKey(task.id),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      setState(() {
                        if (direction == DismissDirection.startToEnd) {
                          if (task.status == TaskStatus.todo) {
                            task.status = TaskStatus.inProgress;
                            TaskStore.updateTask(task);
                          } else if (task.status ==
                              TaskStatus.inProgress) {
                            _completeTask(task);
                          }
                        } else {
                          if (task.status == TaskStatus.inProgress) {
                            task.status = TaskStatus.todo;
                            TaskStore.updateTask(task);
                          }
                        }
                      });
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.arrow_forward,
                          color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.orange,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child:
                          const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    child: Card(
                      child: ListTile(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text("Edit"),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditTaskScreen(task: task),
                                      ),
                                    );
                                    if (result == true) setState(() {});
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text("Delete"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _confirmDelete(task);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        title: Text(task.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.description?.isNotEmpty == true)
                              Text(task.description!),
                            const SizedBox(height: 4),
                            Text("Category: ${task.category}",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: PriorityBadge(priority: task.priority),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
