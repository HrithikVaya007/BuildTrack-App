import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../providers/project_provider.dart';
import '../../models/project_model.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  void initState() {
    super.initState();
    // load projects for current employer
    Future.microtask(
      () => context.read<ProjectProvider>().fetchProjects(),
    );
  }

  @override
  Widget build(BuildContext context) {
   final provider = context.watch<ProjectProvider>();
    final List<ProjectModel> projects = provider.projects;
    final loading = provider.loading;


    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Projects",
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
          : projects.isEmpty
              ? const Center(
                  child: Text(
                    "No projects yet.\nTap + to create one.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              project.description,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Start: ${project.startDate}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Icon(
                                  Icons.event,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "End: ${project.endDate}",
                                  style: const TextStyle(
                                    color: Colors.black54,
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
          Navigator.pushNamed(context, AppRoutes.createProject);
          if (!mounted) return;
          context.read<ProjectProvider>().fetchProjects();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
