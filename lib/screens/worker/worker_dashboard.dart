import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/task_tile.dart';
import 'my_tasks.dart';
import 'check_in_out.dart';
import '../shared/profile.dart';
import 'site_updates.dart';
import 'salary_screen.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final today = DateTime.now();
    final formattedDate = '${today.day}/${today.month}/${today.year}';
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Notifications'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: app.notifications
                        .map((n) => ListTile(title: Text(n)))
                        .toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue[50],
                      child: Icon(Icons.person, color: primary, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning, Rajesh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Site A — Block 3 • $formattedDate',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => app.toggleCheckIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: app.checkedIn ? Colors.green : primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(app.checkedIn ? 'Checked In' : 'Check In'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Dashboard cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardCard(
                  title: 'My Tasks',
                  icon: Icons.task_alt,
                  count: app.pendingCount,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTasks()),
                  ),
                ),
                DashboardCard(
                  title: 'Site Updates',
                  icon: Icons.announcement,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SiteUpdates()),
                  ),
                ),
                DashboardCard(
                  title: 'Profile',
                  icon: Icons.person,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
                DashboardCard(
                  title: 'Salary Info',
                  icon: Icons.payments,
                  count: app.pendingPayment.toInt(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SalaryScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Today's Tasks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            app.tasks.isEmpty
                ? const Center(child: Text('No tasks for today.'))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: app.tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final t = app.tasks[i];
                      return TaskTile(
                        task: t,
                        onToggle: () => app.toggleComplete(t.id),
                        onDelete: () => app.removeTask(t.id),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyTasks()),
        ),
      ),
    );
  }
}
