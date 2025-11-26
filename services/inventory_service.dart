import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/inventory_model.dart';

class InventoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch inventory for logged-in employer
  Future<List<InventoryModel>> getInventory() async {
    final uid = _auth.currentUser!.uid;

    final snapshot = await _db
        .collection('inventory')
        .where('employerId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => InventoryModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  /// Add new inventory item
  Future<InventoryModel> createItem(InventoryModel item) async {
    final uid = _auth.currentUser!.uid;

    final doc = await _db.collection('inventory').add({
      ...item.toJson(),
      'employerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final snap = await doc.get();
    return InventoryModel.fromJson(snap.data()!, doc.id);
  }

  /// Update inventory item
  Future<InventoryModel> updateItem(String id, InventoryModel item) async {
    await _db.collection('inventory').doc(id).update(item.toJson());

    final snap = await _db.collection('inventory').doc(id).get();
    return InventoryModel.fromJson(snap.data()!, id);
  }

  /// Delete inventory item
  Future<bool> deleteItem(String id) async {
    await _db.collection('inventory').doc(id).delete();
    return true;
  }
}
