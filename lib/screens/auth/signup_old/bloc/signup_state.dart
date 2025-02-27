part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final Status status;
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String phone;
  final String specialty;
  final UserType type;
  final String workplace;
  final bool isValid;

  const SignupState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.name = '',
    this.phone = '',
    this.specialty = '',
    this.type = UserType.doctor,
    this.workplace = '',
    this.isValid = false,
  });

  SignupState copyWith({
    Status? status,
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? phone,
    String? specialty,
    UserType? type,
    String? workplace,
    bool? isValid,
  }) {
    return SignupState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      type: type ?? this.type,
      workplace: workplace ?? this.workplace,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [
    status,
    email,
    password,
    confirmPassword,
    name,
    phone,
    specialty,
    type,
    workplace,
    isValid
  ];
}