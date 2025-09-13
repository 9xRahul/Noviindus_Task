class PatientProfile {
  final String id;
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
  final String male;
  final String female;
  final String branch;
  final String treatments;

  PatientProfile({
    required this.id,
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
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });
}
