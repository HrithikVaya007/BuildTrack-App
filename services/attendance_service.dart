import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance_model.dart';

class AttendanceService {
  static const String baseUrl = "http://10.0.2.2:3000/api/attendance";
  // For physical device: replace 10.0.2.2 with your PC IPv4
  // Example: http://192.168.1.5:3000/api/attendance

  /// 🔹 Fetch all attendance records
  Future<List<AttendanceModel>> getAllAttendance() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch attendance records");
    }
  }

  /// 🔹 Fetch attendance for a specific worker
  Future<List<AttendanceModel>> getAttendanceByWorker(String workerId) async {
    final response = await http.get(Uri.parse("$baseUrl/worker/$workerId"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch worker attendance");
    }
  }

  /// 🔹 Mark attendance (create record)
  Future<AttendanceModel> createAttendance(AttendanceModel attendance) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(attendance.toJson()),
    );

    if (response.statusCode == 201) {
      return AttendanceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create attendance");
    }
  }

  /// 🔹 Update attendance record
  Future<AttendanceModel> updateAttendance(
      String id, AttendanceModel attendance) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(attendance.toJson()),
    );

    if (response.statusCode == 200) {
      return AttendanceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update attendance");
    }
  }

  /// 🔹 Delete attendance entry
  Future<bool> deleteAttendance(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete attendance");
    }
  }
}
