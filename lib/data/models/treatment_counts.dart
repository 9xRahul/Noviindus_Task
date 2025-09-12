

import 'package:noviindus_task/data/models/TreatmentModel.dart';

class TreatmentCounts {
  final Treatment treatment;
  int male;
  int female;

  TreatmentCounts({required this.treatment, this.male = 0, this.female = 0});

  Map<String, dynamic> toMap() => {
    'treatmentId': treatment.id,
    'male': male,
    'female': female,
  };

  @override
  String toString() => '${treatment.name} (M:$male F:$female)';
}
