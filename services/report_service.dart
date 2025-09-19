import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  final String baseUrl = 'https://yourapi.com/api';

  Future<void> uploadReport(
    String workerId,
    Map<String, dynamic> data,
    String token,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'worker_id': workerId, ...data}),
    );
  }
}
