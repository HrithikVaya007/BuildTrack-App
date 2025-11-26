import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // small global state shared across app
  final List<String> _notifications = [];
  bool _checkedIn = false;

  // Example placeholders (used by worker dashboard UI)
  List get notifications => List.unmodifiable(_notifications);
  bool get checkedIn => _checkedIn;

  // Some small "stats" used by UI placeholders
  int pendingCount = 0;
  double pendingPayment = 0;
  double receivedSalary = 0;
  List tasks = []; // UI can show simple list until TaskProvider used

  // Notifications
  void addNotification(String msg) {
    _notifications.insert(0, msg);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Check-in toggle
  void toggleCheckIn() {
    _checkedIn = !_checkedIn;
    // optionally record date/time to attendance provider later
    if (_checkedIn) {
      addNotification("Checked in at ${DateTime.now().toLocal()}");
    } else {
      addNotification("Checked out at ${DateTime.now().toLocal()}");
    }
    notifyListeners();
  }

  // Basic setters for dashboard stats (can be wired to providers)
  void setPendingCount(int n) {
    pendingCount = n;
    notifyListeners();
  }

  void setPendingPayment(double value) {
    pendingPayment = value;
    notifyListeners();
  }

  void setReceivedSalary(double value) {
    receivedSalary = value;
    notifyListeners();
  }
}
