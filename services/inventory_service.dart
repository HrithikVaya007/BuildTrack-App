import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryService {
  final String baseUrl = 'https://yourapi.com/api';

  Future<List<Map<String, dynamic>>> getInventory(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch inventory');
    }
  }
}
