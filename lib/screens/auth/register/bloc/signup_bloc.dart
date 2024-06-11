import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';
import '../../../../models/username.dart';
import '../../../../models/email.dart';
import '../../../../models/password.dart';
import '../../../../models/confirm_password.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository authenticationRepository;

  SignupBloc({required this.authenticationRepository}) : super(const SignupState()) {
    on<SignupUsernameChanged>(_onUsernameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(SignupUsernameChanged event, Emitter<SignupState> emit) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      isValid: _validateForm(username, state.email, state.password, state.confirmPassword),
    ));
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: _validateForm(state.username, email, state.password, state.confirmPassword),
    ));
  }

  void _onPasswordChanged(SignupPasswordChanged event, Emitter<SignupState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: _validateForm(state.username, state.email, password, state.confirmPassword),
    ));
  }

  void _onConfirmPasswordChanged(SignupConfirmPasswordChanged event, Emitter<SignupState> emit) {
    final confirmPassword = ConfirmPassword.dirty(
        originalPassword: state.password.value,
        value: event.confirmPassword
    );
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isValid: _validateForm(state.username, state.email, state.password, confirmPassword),
    ));
  }

  bool _validateForm(Username username, Email email, Password password, ConfirmPassword confirmPassword) {
    return Formz.validate([username, email, password, confirmPassword]) == FormzSubmissionStatus.success;
  }

  Future<void> _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await authenticationRepository.signUp(
        username: state.username.value,
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}