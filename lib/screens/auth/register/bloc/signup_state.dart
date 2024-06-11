part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final FormzSubmissionStatus status;
  final Username username;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;  // You will need to define a ConfirmPassword input validation in Formz
  final bool isValid;

  const SignupState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.isValid = false,
  });

  SignupState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
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
