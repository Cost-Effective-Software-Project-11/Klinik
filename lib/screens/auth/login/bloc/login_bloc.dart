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
    // Event handlers for username and password input and submission.
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  /// Updates the state with the new username whenever the username is changed.
  void _onUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(username: event.username));
  }

  /// Updates the state with the new password whenever the password is changed.
  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  /// Handles the login submission, attempts login through the authentication repository,
  /// and emits states based on the outcome.
  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: StatusEnum.inProgress)); // Indicate that login is in progress
    try {
      await _authenticationRepository.logIn(
        username: state.username,
        password: state.password,
      );
      emit(state.copyWith(status: StatusEnum.success)); // Emit success state if login succeeds
    } catch (_) {
      emit(state.copyWith(status: StatusEnum.failure)); // Emit failure state on exception
    }
  }
}