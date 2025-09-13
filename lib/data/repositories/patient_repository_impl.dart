import 'dart:typed_data';

import 'package:noviindus_task/data/data_sources/patient_remote_data_sourse.dart';
import 'package:noviindus_task/data/models/PatientModel.dart';
import 'package:noviindus_task/data/models/PatientProfileModel.dart';

import 'package:noviindus_task/domain/entities/patient.dart';
import 'package:noviindus_task/domain/entities/patient_profile.dart';
import 'package:noviindus_task/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remote;

  PatientRepositoryImpl(this.remote);

  @override
  Future<List<Patient>> fetchPatients() async {
    final raw = await remote.fetchPatients();
    final models = raw.map((m) => PatientModel.fromJson(m)).toList();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> savePatient(
    PatientProfile profile, {
    Map<String, List<int>>? files,
  }) async {
    final model = PatientProfileModel(
      id: profile.id,
      name: profile.name,
      excecutive: profile.excecutive,
      payment: profile.payment,
      phone: profile.phone,
      address: profile.address,
      totalAmount: profile.totalAmount,
      discountAmount: profile.discountAmount,
      advanceAmount: profile.advanceAmount,
      balanceAmount: profile.balanceAmount,
      dateNdTime: profile.dateNdTime,
      male: profile.male,
      female: profile.female,
      branch: profile.branch,
      treatments: profile.treatments,
    );

    return await remote.savePatientMultipart(formFields: model.toJson());
  }
}
