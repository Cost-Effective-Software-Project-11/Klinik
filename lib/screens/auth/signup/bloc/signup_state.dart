part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final StatusEnum status;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isValid;

  const SignupState({
    this.status = StatusEnum.initial,
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isValid = false,
  });

  SignupState copyWith({
    StatusEnum? status,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isValid,
  }) {
    return SignupState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [status, username, email, password, confirmPassword, isValid];
}
