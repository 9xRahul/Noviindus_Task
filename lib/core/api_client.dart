import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noviindus_task/core/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiClient {
  final String baseUrl;
  ApiClient({this.baseUrl = BASE_URL});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return http.get(uri, headers: headers);
  }


  Future<http.Response> postForm(
    String path,
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse('$baseUrl$path');
    final req = http.MultipartRequest('POST', uri);
    req.fields.addAll(fields);
    final streamed = await req.send();
    return http.Response.fromStream(streamed);
  }
}
