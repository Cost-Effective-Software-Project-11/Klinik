import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String speciality;
  final String type;
  final String workplace;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.speciality,
    required this.type,
    required this.workplace,
  });

  @override
  List<Object?> get props => [
    id, email, name, phone, speciality, type, workplace
  ];

  // Using a factory constructor to create a User from a map.
  factory User.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError('Data must not be null');
    }
    return User(
      id: data['id'] as String? ?? '-',
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      speciality: data['speciality'] as String? ?? '',
      type: data['type'] as String? ?? '',
      workplace: data['workplace'] as String? ?? '',
    );
  }

  // Convert a User instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'speciality': speciality,
      'type': type,
      'workplace': workplace,
    };
  }

  // Define an empty User instance.
  static const empty = User(
      id: '-', email: '', name: '', phone: '', speciality: '', type: '', workplace: ''
  );
}