import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -----------------------------
  // SIGN UP
  // -----------------------------
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Create user account
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // Save user data in Firestore
      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "role": role,       // 🔥 SAVE ROLE
        "createdAt": DateTime.now(),
      });

      return {
        "success": true,
        "user": {
          "uid": uid,
          "name": name,
          "email": email,
          "role": role,
        }
      };
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      // Login user
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // Get user data
      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        return {"success": false, "error": "User record not found"};
      }

      final data = userDoc.data() as Map<String, dynamic>;

      return {
        "success": true,
        "user": data, // 🔥 includes role
      };
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }
}
