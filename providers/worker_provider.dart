import 'package:flutter/material.dart';
import '../models/worker_model.dart';
import '../services/worker_service.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();
  List<WorkerModel> _workers = [];
  bool _loading = false;
  String? _error;

  List<WorkerModel> get workers => List.unmodifiable(_workers);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchWorkers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _workers = await _service.getAllWorkers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addWorker(WorkerModel worker) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createWorker(worker);
      _workers.add(created);
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

  Future<bool> updateWorker(String id, WorkerModel worker) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateWorker(id, worker);
      final idx = _workers.indexWhere((w) => w.id == id);
      if (idx >= 0) _workers[idx] = updated;
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

  Future<bool> deleteWorker(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final ok = await _service.deleteWorker(id);
      if (ok) _workers.removeWhere((w) => w.id == id);
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
