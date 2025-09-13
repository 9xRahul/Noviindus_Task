import '../../domain/entities/patient_profile.dart';

class PatientProfileModel extends PatientProfile {
  PatientProfileModel({
    required super.id,
    required super.name,
    required super.excecutive,
    required super.payment,
    required super.phone,
    required super.address,
    required super.totalAmount,
    required super.discountAmount,
    required super.advanceAmount,
    required super.balanceAmount,
    required super.dateNdTime,
    required super.male,
    required super.female,
    required super.branch,
    required super.treatments,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      excecutive: json['excecutive'] ?? '',
      payment: json['payment'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      discountAmount:
          double.tryParse(json['discount_amount'].toString()) ?? 0.0,
      advanceAmount: double.tryParse(json['advance_amount'].toString()) ?? 0.0,
      balanceAmount: double.tryParse(json['balance_amount'].toString()) ?? 0.0,
      dateNdTime: json['date_nd_time'] ?? '',
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      branch: json['branch'] ?? '',
      treatments: json['treatments'] ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
      'excecutive': excecutive,
      'payment': payment,
      'phone': phone,
      'address': address,
      'total_amount': totalAmount.toString(),
      'discount_amount': discountAmount.toString(),
      'advance_amount': advanceAmount.toString(),
      'balance_amount': balanceAmount.toString(),
      'date_nd_time': dateNdTime,
      'male': male,
      'female': female,
      'branch': branch,
      'treatments': treatments,
    };
  }
}
