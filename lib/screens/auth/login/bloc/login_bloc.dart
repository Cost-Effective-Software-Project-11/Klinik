import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import '../../../../repos/authentication/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Bloc for managing login functionality.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  /// Constructs a LoginBloc which handles the login process using an AuthenticationRepository.
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  /// Handles the login submission, attempts login through the authentication repository,
  /// and resets state after handling results.
  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: StatusEnum.inProgress)); // Indicate that login is in progress

    try {
      await _authenticationRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: StatusEnum.success)); // Emit success state if login succeeds
      emit(const LoginState()); // Reset state after login success
    } catch (_) {
      emit(state.copyWith(status: StatusEnum.failure)); // Emit failure state on exception
      emit(const LoginState()); // Reset state after handling error
    }
  }
}
