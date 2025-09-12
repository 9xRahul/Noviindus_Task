// lib/data/models/branch_model.dart
import 'package:noviindus_task/domain/entities/branch.dart';

class BranchModel {
  final int id;
  final String name;
  final String? location;
  final String? phone;
  final String? address;

  BranchModel({
    required this.id,
    required this.name,
    this.location,
    this.phone,
    this.address,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
    );
  }

  Branch toEntity() {
    return Branch(
      id: id,
      name: name,
      location: location ?? '',
      phone: phone ?? '',
      address: address ?? '',
    );
  }

  @override
  String toString() => 'BranchModel(id:$id,name:$name)';
}
