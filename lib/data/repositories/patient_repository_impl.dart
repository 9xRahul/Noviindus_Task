import 'package:noviindus_task/data/data_sources/patient_remote_data_sourse.dart';
import 'package:noviindus_task/data/models/PatientModel.dart';

import 'package:noviindus_task/domain/entities/patient.dart';
import 'package:noviindus_task/domain/repositories/booking_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remote;
  PatientRepositoryImpl(this.remote);

  @override
  Future<List<Patient>> fetchPatients() async {
    final raw = await remote.fetchPatients();
    final models = raw.map((m) => PatientModel.fromJson(m)).toList();
    return models.map((m) => m.toEntity()).toList();
  }
}
