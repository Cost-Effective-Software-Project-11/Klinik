part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String specialty;
  final String type;
  final String workplace;

  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.specialty,
    required this.type,
    required this.workplace,
  });

  @override
  List<Object> get props => [email, password, name, phone, specialty, type, workplace];
}