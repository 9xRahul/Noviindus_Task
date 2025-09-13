class PatientProfile {
  final String name;
  final String excecutive;
  final String payment;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateNdTime;
  final String id;
  final String male;
  final String female;
  final String branch;
  final String treatments;

  const PatientProfile({
    required this.name,
    required this.excecutive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    required this.id,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  PatientProfile copyWith({String? id}) {
    return PatientProfile(
      name: name,
      excecutive: excecutive,
      payment: payment,
      phone: phone,
      address: address,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      advanceAmount: advanceAmount,
      balanceAmount: balanceAmount,
      dateNdTime: dateNdTime,
      id: id ?? this.id,
      male: male,
      female: female,
      branch: branch,
      treatments: treatments,
    );
  }
}
