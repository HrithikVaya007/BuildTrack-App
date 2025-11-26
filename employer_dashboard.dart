import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/worker_provider.dart';
import '../../providers/inventory_provider.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  @override
  void initState() {
    super.initState();

    // Preload some data for the dashboard
    Future.microtask(() {
      final ctx = context;
      ctx.read<ProjectProvider>().fetchProjects();
      ctx.read<WorkerProvider>().fetchWorkers();
      ctx.read<TaskProvider>().fetchEmployerTasks();
      ctx.read<InventoryProvider>().fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectCount = context.watch<ProjectProvider>().projects.length;
    final workerCount = context.watch<WorkerProvider>().workers.length;
    final taskCount = context.watch<TaskProvider>().tasks.length;
    final inventoryCount = context.watch<InventoryProvider>().items.length;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Employer Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE8EBF0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              children: [
                _DashboardCard(
                  title: "Add Worker",
                  icon: Icons.person_add,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.addWorker),
                ),
                _DashboardCard(
                  title: "Create Project",
                  icon: Icons.work_outline,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.createProject),
                ),
                _DashboardCard(
                  title: "Projects",
                  icon: Icons.folder_open,
                  badgeText: projectCount > 0 ? "$projectCount" : null,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.projectList),
                ),
                _DashboardCard(
                  title: "Tasks",
                  icon: Icons.task_alt,
                  badgeText: taskCount > 0 ? "$taskCount" : null,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.taskManagement),
                ),
                _DashboardCard(
                  title: "Workers",
                  icon: Icons.groups_2,
                  badgeText: workerCount > 0 ? "$workerCount" : null,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.addWorker),
                ),
                _DashboardCard(
                  title: "Inventory",
                  icon: Icons.inventory_2,
                  badgeText: inventoryCount > 0 ? "$inventoryCount" : null,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.inventory),
                ),
                _DashboardCard(
                  title: "Attendance",
                  icon: Icons.access_time,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.attendanceView),
                ),
                _DashboardCard(
                  title: "Find Dealer",
                  icon: Icons.store_mall_directory_rounded,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.findDealer),
                ),
                // If you still want "Recent Activity", you can replace one of above
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? badgeText; // 👈 NEW: optional count badge

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.badgeText,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          elevation: 10,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                        child: Icon(
                          widget.icon,
                          size: 50,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                      if (widget.badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.badgeText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E2E2E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
