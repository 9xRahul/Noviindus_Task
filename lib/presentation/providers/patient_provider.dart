import 'package:flutter/foundation.dart';
import 'package:noviindus_task/domain/entities/patient.dart';

import 'package:noviindus_task/domain/usecases/patient_usecase.dart';

enum PatientStatus { initial, loading, loaded, empty, error }

class PatientProvider extends ChangeNotifier {
  final GetPatientsUsecase getPatients;
  PatientProvider({required this.getPatients});

  List<Patient> patients = [];
  PatientStatus status = PatientStatus.initial;
  String? errorMessage;

  Future<void> loadPatients({bool force = false}) async {
    if (status == PatientStatus.loading && !force) return;
    status = PatientStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final list = await getPatients.call();
      patients = list;
      status = patients.isEmpty ? PatientStatus.empty : PatientStatus.loaded;
      notifyListeners();
    } catch (e) {
      status = PatientStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() => loadPatients(force: true);
}
