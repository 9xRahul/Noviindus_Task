import 'dart:convert';
import 'dart:typed_data';
import 'package:noviindus_task/core/api_client.dart';

abstract class PatientRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchPatients();
  Future<Map<String, dynamic>> savePatientMultipart({
    required Map<String, String> formFields,
    Map<String, Uint8List>? fileBytes,
    Map<String, String>? fileNames,
  });
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient client;
  PatientRemoteDataSourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final res = await client.get('PatientList');

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      if (decoded is Map && decoded['patient'] is List) {
        return List<Map<String, dynamic>>.from(decoded['patient']);
      }
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      }
      if (decoded is Map && decoded['data'] is List) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      }

      return [];
    } else {
      throw Exception('Failed to fetch patients: ${res.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> savePatientMultipart({
    required Map<String, String> formFields,
    Map<String, Uint8List>? fileBytes,
    Map<String, String>? fileNames,
  }) async {
    print("Hit button");
    const path = 'PatientUpdate';
    final res = await client.postMultipart(path, fields: formFields);
    return res['body'] as Map<String, dynamic>;
  }
}
