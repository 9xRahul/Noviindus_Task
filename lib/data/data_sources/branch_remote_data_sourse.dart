
import 'dart:convert';
import 'package:noviindus_task/core/api_client.dart';

abstract class BranchRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchBranches();
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final ApiClient client;
  BranchRemoteDataSourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> fetchBranches() async {
    final res = await client.get('BranchList'); 
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch branches: ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);

    if (decoded is Map) {
      if (decoded['branches'] is List) {
        return List<Map<String, dynamic>>.from(decoded['branches']);
      }

      final firstList = decoded.values.firstWhere(
        (v) => v is List,
        orElse: () => null,
      );
      if (firstList is List) return List<Map<String, dynamic>>.from(firstList);
      return [];
    } else if (decoded is List) {
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      return [];
    }
  }
}
