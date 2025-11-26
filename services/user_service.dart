import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = "http://10.0.2.2:8000";
  // Use 10.0.2.2 for Android emulator; replace with system IPv4 for real device.

  // 🔹 GET ALL USERS
  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch users");
    }
  }

  // 🔹 GET USER BY ID
  Future<UserModel> getUserById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("User not found");
    }
  }

  // 🔹 CREATE USER
  Future<UserModel> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create user");
    }
  }

  // 🔹 UPDATE USER
  Future<UserModel> updateUser(String id, UserModel user) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update user");
    }
  }

  // 🔹 DELETE USER
  Future<bool> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/users/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete user");
    }
  }
}
