import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AppProvider with ChangeNotifier {
  // -----------------------------
  // Check-in / Check-out
  // -----------------------------
  bool checkedIn = false;

  void toggleCheckIn() {
    checkedIn = !checkedIn;
    notifyListeners();
  }

  // -----------------------------
  // Profile Info
  // -----------------------------
  String name = 'Rajesh';
  String email = 'rajesh@example.com';
  String phone = '+91 9876543210';
  String address = 'Site A, Block 3';

  // -----------------------------
  // Tasks
  // -----------------------------
  List<Task> tasks = [
    Task(id: '1', title: 'Lay foundation'),
    Task(id: '2', title: 'Mix concrete'),
    Task(id: '3', title: 'Install scaffolding'),
  ];

  int get pendingCount => tasks.where((t) => !t.completed).length;

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void toggleComplete(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    task.completed = !task.completed;
    notifyListeners();
  }

  void removeTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // -----------------------------
  // Site Updates
  // -----------------------------
  List<String> siteUpdates = [
    'Site inspection completed',
    'Concrete delivery scheduled',
    'Safety meeting at 10 AM',
  ];

  void addSiteUpdate(String update) {
    siteUpdates.add(update);
    notifyListeners();
  }

  void removeSiteUpdate(int index) {
    if (index >= 0 && index < siteUpdates.length) {
      siteUpdates.removeAt(index);
      notifyListeners();
    }
  }

  // -----------------------------
  // Salary Info
  // -----------------------------
  double receivedSalary = 50000;
  double pendingPayment = 12000;

  void requestPayment(double amount) {
    if (amount > 0) {
      pendingPayment += amount;
      notifyListeners();
    }
  }

  void paySalary(double amount) {
    if (amount > 0 && amount <= pendingPayment) {
      pendingPayment -= amount;
      receivedSalary += amount;
      notifyListeners();
    }
  }

  // -----------------------------
  // Notifications
  // -----------------------------
  List<String> notifications = [
    'Safety drill at 3 PM',
    'New site report uploaded',
    'Meeting at 10 AM tomorrow',
  ];

  void addNotification(String message) {
    notifications.add(message);
    notifyListeners();
  }

  void removeNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
      notifyListeners();
    }
  }
}
