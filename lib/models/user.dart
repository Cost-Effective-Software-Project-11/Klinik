import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'package:meta/meta.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.speciality,
    required this.type,
    required this.workplace,
  });

  final String id;
  final String email;
  final String name;
  final String phone;
  final String speciality;
  final UserType type;
  final Workplace workplace;

  @override
  List<Object?> get props =>
      [id, email, name, phone, speciality, type, workplace];

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name, phone: $phone, speciality: $speciality, type: $type, workplace: $workplace}';
  }
}
