import 'dart:convert';
import 'package:noviindus_task/core/api_client.dart';

abstract class PatientRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchPatients();
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient client;
  PatientRemoteDataSourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final res = await client.get('PatientList');
    // debug
    // print('PatientList status: ${res.statusCode}');
    // print('PatientList body: ${res.body}');
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      // API returns { status: true, message: "Success", patient: [ ... ] }
      if (decoded is Map && decoded['patient'] is List) {
        return List<Map<String, dynamic>>.from(decoded['patient']);
      }

      // fallback: maybe the API returns the array directly
      if (decoded is List) return List<Map<String, dynamic>>.from(decoded);

      // other fallback: `data` key
      if (decoded is Map && decoded['data'] is List) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      }

      return [];
    } else {
      throw Exception('Failed to fetch patients: ${res.statusCode}');
    }
  }
}
