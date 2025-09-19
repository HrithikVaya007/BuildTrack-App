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

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: app.tasks.isEmpty
          ? const Center(child: Text('No tasks assigned yet.'))
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
      // ❌ Removed FloatingActionButton (workers cannot add tasks)
    );
  }
}
