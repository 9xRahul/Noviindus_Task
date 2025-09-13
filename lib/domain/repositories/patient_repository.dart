import '../entities/patient.dart';
import '../entities/patient_profile.dart';

abstract class PatientRepository {
  Future<List<Patient>> fetchPatients();

  Future<Map<String, dynamic>> savePatient(
    PatientProfile profile, {
    Map<String, List<int>>? files,
  });
}
