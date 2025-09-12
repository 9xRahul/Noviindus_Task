import 'package:noviindus_task/domain/entities/patient.dart';
import 'package:intl/intl.dart';

class PatientModel {
  final String id;
  final String name;
  final String packageName; // treatment name from patientdetails_set
  final DateTime date;
  final String executiveName;
  final String? phone;
  final double? totalAmount;
  final double? balanceAmount;

  PatientModel({
    required this.id,
    required this.name,
    required this.packageName,
    required this.date,
    required this.executiveName,
    this.phone,
    this.totalAmount,
    this.balanceAmount,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // id & name
    final id = (json['id'] ?? json['patient_id'])?.toString() ?? '';
    final name = (json['name'] ?? json['patient_name'])?.toString() ?? '';

    // phone
    final phone = (json['phone'] ?? json['mobile'])?.toString();

    // amounts (may be null)
    final totalAmount = json['total_amount'] != null
        ? double.tryParse(json['total_amount'].toString())
        : null;
    final balanceAmount = json['balance_amount'] != null
        ? double.tryParse(json['balance_amount'].toString())
        : null;

    // executive/user field (string)
    final executiveName = json['user']?.toString() ?? '';

    // created_at datetime (ISO format)
    DateTime parsedDate;
    final createdAt =
        (json['created_at'] ?? json['date_nd_time'] ?? '')?.toString() ?? '';
    if (createdAt.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(createdAt);
      } catch (_) {
        // try other formats or fallback to now
        try {
          parsedDate = DateFormat('dd/MM/yyyy-hh:mm a').parseLoose(createdAt);
        } catch (_) {
          parsedDate = DateTime.now();
        }
      }
    } else {
      parsedDate = DateTime.now();
    }

    // patientdetails_set: take first element's treatment_name if present
    String packageName = '';
    try {
      if (json['patientdetails_set'] is List &&
          (json['patientdetails_set'] as List).isNotEmpty) {
        final first = (json['patientdetails_set'] as List)[0];
        if (first is Map && first['treatment_name'] != null) {
          packageName = first['treatment_name'].toString();
        } else if (first is Map && first['treatment'] != null) {
          packageName = first['treatment'].toString();
        }
      }
    } catch (_) {
      packageName = '';
    }

    return PatientModel(
      id: id,
      name: name,
      packageName: packageName,
      date: parsedDate,
      executiveName: executiveName,
      phone: phone,
      totalAmount: totalAmount,
      balanceAmount: balanceAmount,
    );
  }

  Patient toEntity() => Patient(
    id: id,
    name: name,
    packageName: packageName,
    date: date,
    executiveName: executiveName,
  );
}
