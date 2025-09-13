import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
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
    final token = await _getToken();

    print("Auth token: $token");

    final authHeaders = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded', 
    };

    final response = await http.post(
      uri,
      body: fields,
      headers: authHeaders, 
    );

    log(response.body);

    return response;
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,

    Map<String, String>? fileNames,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest('POST', uri);

    final token = await _getToken();

    final authHeaders = <String, String>{};

    if (headers != null) authHeaders.addAll(headers);

    authHeaders['Authorization'] = 'Bearer $token';

    
    fields.forEach((k, v) {
      request.fields[k] = v;
    });

    

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    print(body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'status': response.statusCode, 'body': body};
    } else {
      throw ApiException(response.statusCode, body.toString());
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}
