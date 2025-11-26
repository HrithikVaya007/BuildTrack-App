import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();
  List<TaskModel> _tasks = [];
  bool _loading = false;
  String? _error;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchAllTasks() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _service.getAllTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTasksByProject(String projectId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _service.getTasksByProject(projectId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(TaskModel task) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createTask(task);
      _tasks.add(created);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  Future<bool> updateTask(String id, TaskModel task) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateTask(id, task);
      final idx = _tasks.indexWhere((t) => t.id == id);
      if (idx >= 0) _tasks[idx] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  Future<bool> deleteTask(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final ok = await _service.deleteTask(id);
      if (ok) _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return ok;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  // convenience: toggle status between Pending / In Progress / Completed
  Future<bool> toggleStatus(TaskModel task) async {
    final newStatus = task.status == "Completed"
        ? "Pending"
        : (task.status == "Pending" ? "In Progress" : "Completed");

    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      assignedTo: task.assignedTo,
      projectId: task.projectId,
      status: newStatus,
    );

    return updateTask(task.id, updatedTask);
  }
}
