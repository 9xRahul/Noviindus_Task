import '../entities/patient_profile.dart';
import '../repositories/patient_repository.dart';

class SavePatientUsecase {
  final PatientRepository repository;

  SavePatientUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    PatientProfile profile, {
    Map<String, List<int>>? files,
  }) async {
    return await repository.savePatient(profile, files: files);
  }
}
