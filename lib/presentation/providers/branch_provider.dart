// lib/presentation/providers/branch_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:noviindus_task/core/api_client.dart';
import 'package:noviindus_task/data/models/BranchModel.dart';

import 'package:noviindus_task/domain/entities/branch.dart';

class BranchProvider extends ChangeNotifier {
  final ApiClient api;
  BranchProvider(this.api);

  List<BranchModel> _models = [];
  bool loading = false;
  String? error;

  /// Expose domain entities to UI
  List<Branch> get branches => _models.map((m) => m.toEntity()).toList();

  Future<void> loadBranches() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await api.get('BranchList');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final tmp = <BranchModel>[];

        if (decoded is List) {
          for (var item in decoded) {
            if (item is Map)
              tmp.add(BranchModel.fromJson(Map<String, dynamic>.from(item)));
          }
        } else if (decoded is Map && decoded['data'] is List) {
          for (var item in decoded['data']) {
            if (item is Map)
              tmp.add(BranchModel.fromJson(Map<String, dynamic>.from(item)));
          }
        } else if (decoded is Map && decoded['branches'] is List) {
          for (var item in decoded['branches']) {
            if (item is Map)
              tmp.add(BranchModel.fromJson(Map<String, dynamic>.from(item)));
          }
        } else if (decoded is Map && decoded.containsKey('id')) {
          // single object response
          tmp.add(BranchModel.fromJson(Map<String, dynamic>.from(decoded)));
        }

        // Deduplicate by id (keep first occurrence)
        final Map<int, BranchModel> unique = {};
        for (final m in tmp) {
          if (!unique.containsKey(m.id)) unique[m.id] = m;
        }
        _models = unique.values.toList();

        if (kDebugMode) {
          debugPrint(
            'BranchProvider: loaded ${_models.length} branches: ${_models.map((m) => m.name).toList()}',
          );
        }
      } else {
        error = 'Server ${res.statusCode}: ${res.body}';
        if (kDebugMode) debugPrint('BranchProvider load error: $error');
      }
    } catch (e, st) {
      error = e.toString();
      if (kDebugMode) {
        debugPrint('BranchProvider exception: $e');
        debugPrint(st.toString());
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
