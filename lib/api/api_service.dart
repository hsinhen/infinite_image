import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String _baseUrl = 'https://picsum.photos/v2';
  static final Map<String, String> _headers = {'Accept': 'application/json'};

  static Future<String?> get(String endpoint,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers ?? _headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }

  static Future<String?> post(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers ?? _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }

  static Future<String?> put(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers ?? _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
