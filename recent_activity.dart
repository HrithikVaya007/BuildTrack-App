import 'package:flutter/material.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy activity data (replace with API or DB later)
    final List<Map<String, String>> activities = [
      {
        "message": "Worker A checked in at 7:00 AM",
        "time": "2025-09-18 07:00 AM",
        "icon": "check",
      },
      {
        "message": "Project B marked as completed",
        "time": "2025-09-17 05:30 PM",
        "icon": "done",
      },
      {
        "message": "Inventory updated: 20 bags of cement",
        "time": "2025-09-16 02:15 PM",
        "icon": "inventory",
      },
      {
        "message": "New worker added: John Smith",
        "time": "2025-09-15 11:45 AM",
        "icon": "person",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Recent Activity",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          IconData activityIcon;

          switch (activity["icon"]) {
            case "check":
              activityIcon = Icons.login; // check-in
              break;
            case "done":
              activityIcon = Icons.check_circle; // completed
              break;
            case "inventory":
              activityIcon = Icons.inventory; // inventory
              break;
            case "person":
              activityIcon = Icons.person_add; // new worker
              break;
            default:
              activityIcon = Icons.notifications;
          }

          return Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFFE0E0E0)), // light border
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(activityIcon, color: Colors.blue[800]),
              ),
              title: Text(
                activity["message"]!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                activity["time"]!,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }
}
