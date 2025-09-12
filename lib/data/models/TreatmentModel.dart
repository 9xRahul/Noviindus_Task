// lib/models/treatment_model.dart
class Treatment {
  final int id;
  final String name;
  final String? duration;
  final String? price;
  final bool isActive;

  Treatment({
    required this.id,
    required this.name,
    this.duration,
    this.price,
    this.isActive = true,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      duration: json['duration']?.toString(),
      price: json['price']?.toString(),
      isActive: json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration': duration,
    'price': price,
    'is_active': isActive,
  };

  @override
  String toString() => 'Treatment(id:$id, name:$name)';
}
