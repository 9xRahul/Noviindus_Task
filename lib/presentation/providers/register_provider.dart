import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';

enum SubmitStatus { idle, submitting, success, failure }

class RegisterProvider extends ChangeNotifier {
  final ApiClient api;
  SubmitStatus status = SubmitStatus.idle;
  String? error;

  RegisterProvider(this.api);

  Future<bool> submit(Map<String, String> fields) async {
    status = SubmitStatus.submitting;
    error = null;
    notifyListeners();
    try {
      print("Reached provider");
      final res = await api.postForm('PatientUpdate', fields);
      if (res.statusCode == 200) {
        status = SubmitStatus.success;
        notifyListeners();
        return true;
      } else {
        print(res.body);
        error = 'Server responded ${res.statusCode}: ${res.body}';
        status = SubmitStatus.failure;
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = e.toString();
      status = SubmitStatus.failure;
      notifyListeners();
      return false;
    }
  }
}
