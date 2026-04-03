import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../services/inventory_service.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryService _service = InventoryService();
  List<InventoryModel> _items = [];
  bool _loading = false;
  String? _error;

  List<InventoryModel> get items => List.unmodifiable(_items);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchItems() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // FIXED: call correct method
      _items = await _service.getInventory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addItem(InventoryModel item) async {
    _loading = true;
    notifyListeners();

    try {
      // FIXED: call correct method
      final created = await _service.createItem(item);
      _items.add(created);
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

  Future<bool> updateItem(String id, InventoryModel item) async {
    _loading = true;
    notifyListeners();

    try {
      // FIXED: call correct method
      final updated = await _service.updateItem(id, item);
      final idx = _items.indexWhere((i) => i.id == id);
      if (idx >= 0) _items[idx] = updated;
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

  Future<bool> deleteItem(String id) async {
    _loading = true;
    notifyListeners();

    try {
      // FIXED: call correct method
      final ok = await _service.deleteItem(id);
      if (ok) _items.removeWhere((i) => i.id == id);
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
