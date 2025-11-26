import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../routes/app_routes.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks created by the current employer
    Future.microtask(
      () => context.read<TaskProvider>().fetchEmployerTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final List<TaskModel> tasks = taskProvider.tasks;
    final loading = taskProvider.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Task Management",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text(
                    "No tasks yet.\nTap + to add / assign work.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    // Status color coding based on task.status
                    Color statusColor;
                    switch (task.status) {
                      case "Pending":
                        statusColor = Colors.orange;
                        break;
                      case "In Progress":
                        statusColor = Colors.blue;
                        break;
                      case "Completed":
                        statusColor = Colors.green;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              // currently we only have worker id in `assignedTo`
                              "Assigned to: ${task.assignedTo.isEmpty ? "Not assigned" : task.assignedTo}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task.status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 4,
        onPressed: () {
          // for now you asked this to open AddWorker
          // later we can change this to "CreateTaskScreen"
          Navigator.pushNamed(context, AppRoutes.addWorker);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
