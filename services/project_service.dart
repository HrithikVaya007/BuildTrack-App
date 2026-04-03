import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class ProjectService {
  static const String baseUrl = "http://10.0.2.2:8000";  
  // For Android Emulator.  
  // If you use a real device, replace with your laptop IPv4.

  // 🚀 GET ALL PROJECTS
  Future<List<ProjectModel>> getProjects() async {
    final response = await http.get(Uri.parse("$baseUrl/projects"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ProjectModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch projects");
    }
  }

  // ➕ CREATE A PROJECT
  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await http.post(
      Uri.parse("$baseUrl/projects"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return ProjectModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create project");
    }
  }

  // ✏️ UPDATE PROJECT
  Future<ProjectModel> updateProject(String id, ProjectModel project) async {
    final response = await http.put(
      Uri.parse("$baseUrl/projects/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode == 200) {
      return ProjectModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update project");
    }
  }

  // ❌ DELETE PROJECT
  Future<bool> deleteProject(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/projects/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete project");
    }
  }
}
