import 'package:noviindus_task/domain/entities/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> fetchPatients();
}
