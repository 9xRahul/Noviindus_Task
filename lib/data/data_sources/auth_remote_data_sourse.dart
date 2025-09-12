import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await client.postForm('Login', {
      'username': username,
      'password': password,
    });

    print(res.statusCode);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;

      throw Exception('Unexpected login response format');
    }
    throw Exception('Login failed (${res.statusCode}): ${res.body}');
  }
}
