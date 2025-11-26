import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  static const String baseUrl = "http://10.0.2.2:8000";
  // 👆 For Android Emulator. Use your PC IPv4 when testing on real device.

  // 🔹 GET ALL TASKS
  Future<List<TaskModel>> getAllTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/tasks"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch tasks");
    }
  }

  // 🔹 GET TASKS BY PROJECT ID
  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/projects/$projectId/tasks"),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch tasks for project");
    }
  }

  // 🔹 CREATE TASK
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse("$baseUrl/tasks"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create task");
    }
  }

  // 🔹 UPDATE TASK
  Future<TaskModel> updateTask(String id, TaskModel task) async {
    final response = await http.put(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update task");
    }
  }

  // 🔹 DELETE TASK
  Future<bool> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/tasks/$id"),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete task");
    }
  }
}
