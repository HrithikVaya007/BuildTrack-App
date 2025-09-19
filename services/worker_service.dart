import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkerService {
  final String baseUrl = 'https://yourapi.com/api';

  Future<Map<String, dynamic>> getWorker(String workerId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workers/$workerId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch worker details');
    }
  }
}
