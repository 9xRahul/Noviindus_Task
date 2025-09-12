// lib/domain/entities/branch.dart
class Branch {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String address;

  const Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.address,
  });

  @override
  String toString() => 'Branch(id:$id, name:$name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Branch && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
