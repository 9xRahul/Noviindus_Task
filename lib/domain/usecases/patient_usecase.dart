import 'package:noviindus_task/data/repositories/patient_repository_impl.dart';

import 'package:noviindus_task/domain/repositories/patient_repository.dart';

import '../entities/patient.dart';

class GetPatientsUsecase {
  final PatientRepository repository;
  GetPatientsUsecase(this.repository);

  Future<List<Patient>> call() => repository.fetchPatients();
}
