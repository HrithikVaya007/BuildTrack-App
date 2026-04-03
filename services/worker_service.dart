import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/worker_model.dart';

class WorkerService {
  static const String baseUrl = "http://10.0.2.2:8000";
  // Use 10.0.2.2 on Android emulator; replace with PC IPv4 for real device

  // 🔹 GET ALL WORKERS
  Future<List<WorkerModel>> getAllWorkers() async {
    final response = await http.get(Uri.parse("$baseUrl/workers"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => WorkerModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch workers");
    }
  }

  // 🔹 GET WORKER BY ID
  Future<WorkerModel> getWorkerById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/workers/$id"));

    if (response.statusCode == 200) {
      return WorkerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Worker not found");
    }
  }

  // 🔹 CREATE WORKER
  Future<WorkerModel> createWorker(WorkerModel worker) async {
    final response = await http.post(
      Uri.parse("$baseUrl/workers"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(worker.toJson()),
    );

    if (response.statusCode == 201) {
      return WorkerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create worker");
    }
  }

  // 🔹 UPDATE WORKER
  Future<WorkerModel> updateWorker(String id, WorkerModel worker) async {
    final response = await http.put(
      Uri.parse("$baseUrl/workers/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(worker.toJson()),
    );

    if (response.statusCode == 200) {
      return WorkerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update worker");
    }
  }

  // 🔹 DELETE WORKER
  Future<bool> deleteWorker(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/workers/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete worker");
    }
  }
}
