import 'package:flutter/foundation.dart';
import 'package:noviindus_task/domain/entities/patient.dart';
import 'package:noviindus_task/domain/entities/patient_profile.dart';
import 'package:noviindus_task/domain/usecases/patient_usecase.dart';
import 'package:noviindus_task/domain/usecases/save_patient_use_case.dart';

enum PatientStatus { initial, loading, loaded, empty, error }

enum PatientSubmitStatus  { idle, submitting, success, failure }

class PatientProvider extends ChangeNotifier {
  final GetPatientsUsecase getPatients;
  final SavePatientUsecase savePatient;

  PatientProvider({required this.getPatients, required this.savePatient});

  
  List<Patient> patients = [];
  PatientStatus status = PatientStatus.initial;
  String? errorMessage;

  
  PatientSubmitStatus  submitStatus = PatientSubmitStatus.idle;
  String? submitError;

  
  Future<void> loadPatients({bool force = false}) async {
    if (status == PatientStatus.loading && !force) return;
    status = PatientStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final list = await getPatients.call();
      patients = list;
      status = patients.isEmpty ? PatientStatus.empty : PatientStatus.loaded;
    } catch (e) {
      status = PatientStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> refresh() => loadPatients(force: true);

  
  Future<bool> savePatientProfile(PatientProfile profile) async {
    submitStatus = PatientSubmitStatus.submitting;
    submitError = null;
    notifyListeners();

    try {
      await savePatient(profile);
      submitStatus = PatientSubmitStatus.success;

      
      await loadPatients(force: true);

      notifyListeners();
      return true;
    } catch (e) {
      submitStatus = PatientSubmitStatus.failure;
      submitError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
