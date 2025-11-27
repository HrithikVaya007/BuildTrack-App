import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';
import '../../providers/task_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/attendance_model.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TaskProvider>().fetchWorkerTasks();
      context.read<AttendanceProvider>().fetchAttendanceByWorker(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();

    final taskCount = taskProvider.tasks.length;
    final List<AttendanceModel> records = attendanceProvider.attendanceList;
    final daysWorked = records.length;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final checkedInToday = records.any(
      (a) => a.date == today && a.checkInTime.isNotEmpty,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Worker Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: "Profile",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profilePage);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.task_alt,
              title: "My Tasks",
              subtitle: taskCount == 0 ? "No tasks yet" : "$taskCount tasks",
              route: AppRoutes.myTasks,
            ),
            _buildDashboardCard(
              context,
              icon: Icons.access_time,
              title: "Check In / Out",
              subtitle: checkedInToday ? "Checked in today" : "Not checked in",
              route: AppRoutes.checkInOut,
            ),
            _buildDashboardCard(
              context,
              icon: Icons.attach_money,
              title: "Salary",
              subtitle: "Days worked: $daysWorked",
              route: AppRoutes.salaryScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
