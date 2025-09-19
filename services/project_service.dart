import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectService {
  final String baseUrl = 'https://yourapi.com/api';

  Future<List<Map<String, dynamic>>> getProjects(
    String workerId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects?worker_id=$workerId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch projects');
    }
  }
}
