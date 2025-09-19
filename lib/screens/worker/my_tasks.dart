import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/task_tile.dart';
import '../../models/task_model.dart';

class MyTasks extends StatelessWidget {
  const MyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();

    // Dialog to add a new task
    void addTaskDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final subtitle = subtitleController.text.trim();
                if (title.isNotEmpty) {
                  final newTask = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    subtitle: subtitle,
                  );
                  app.addTask(newTask); // add to provider
                  Navigator.pop(ctx);
                  titleController.clear();
                  subtitleController.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: app.tasks.isEmpty
          ? const Center(child: Text('No tasks added yet.'))
          : ListView.separated(
              itemCount: app.tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final task = app.tasks[i];
                return TaskTile(
                  task: task,
                  onToggle: () => app.toggleComplete(task.id),
                  onDelete: () => app.removeTask(task.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
