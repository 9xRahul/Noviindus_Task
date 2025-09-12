// lib/presentation/providers/treatment_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:noviindus_task/data/models/TreatmentModel.dart';
import '../../core/api_client.dart';

class TreatmentProvider extends ChangeNotifier {
  final ApiClient api;
  List<Treatment> treatments = [];
  bool loading = false;
  String? error;

  TreatmentProvider(this.api);

  Future<void> loadTreatments() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await api.get('TreatmentList');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final list = <Treatment>[];
        if (decoded is List) {
          for (var e in decoded) {
            if (e is Map)
              list.add(Treatment.fromJson(Map<String, dynamic>.from(e)));
          }
        } else if (decoded is Map && decoded['treatments'] is List) {
          for (var e in decoded['treatments']) {
            if (e is Map)
              list.add(Treatment.fromJson(Map<String, dynamic>.from(e)));
          }
        }
        treatments = list;
      } else {
        error = 'Failed to load treatments: ${res.statusCode}';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
