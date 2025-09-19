import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String baseUrl = 'https://yourapi.com/api';

  Future<void> checkIn(String workerId, String token) async {
    await http.post(
      Uri.parse('$baseUrl/attendance/checkin'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'worker_id': workerId}),
    );
  }

  Future<void> checkOut(String workerId, String token) async {
    await http.post(
      Uri.parse('$baseUrl/attendance/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'worker_id': workerId}),
    );
  }
}
