import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service = UserService();
  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _loading = false;
  String? _error;

  List<UserModel> get users => List.unmodifiable(_users);
  UserModel? get currentUser => _currentUser;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _service.getAllUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(UserModel user) async {
    _loading = true;
    notifyListeners();
    try {
      final created = await _service.createUser(user);
      _users.add(created);
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

  Future<bool> updateUser(String id, UserModel user) async {
    _loading = true;
    notifyListeners();
    try {
      final updated = await _service.updateUser(id, user);
      final idx = _users.indexWhere((u) => u.id == id);
      if (idx >= 0) _users[idx] = updated;
      if (_currentUser?.id == id) _currentUser = updated;
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

  Future<bool> deleteUser(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final ok = await _service.deleteUser(id);
      if (ok) _users.removeWhere((u) => u.id == id);
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

  // local current user helpers (after login)
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
