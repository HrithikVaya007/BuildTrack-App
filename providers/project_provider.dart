import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  List<ProjectModel> _projects = [];
  bool _loading = false;
  String? _error;

  List<ProjectModel> get projects => List.unmodifiable(_projects);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchProjects() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _projects = await _service.getProjects();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addProject(ProjectModel project) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createProject(project);
      // if backend returns object, add; else refetch
      _projects.add(created);
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

  Future<bool> updateProject(String id, ProjectModel project) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateProject(id, project);
      final idx = _projects.indexWhere((p) => p.id == id);
      if (idx >= 0) _projects[idx] = updated;
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

  Future<bool> deleteProject(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final ok = await _service.deleteProject(id);
      if (ok) _projects.removeWhere((p) => p.id == id);
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
}
