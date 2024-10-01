import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import 'package:flutter_gp5/enums/user_type_enum.dart';
import '../../../../repos/authentication/authentication_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

/// Bloc to handle user sign-up process.
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository _authenticationRepository;

  /// Constructor that initializes the SignupBloc with a given [AuthenticationRepository].
  /// It starts with an initial state of [SignupState].
  SignupBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    // Register event handler for when a signup submission is triggered.
    on<SignupSubmitted>(_onSubmitted);
  }

  /// Handles the sign-up submission event.
  /// Emits different states based on the result of the sign-up attempt.
  Future<void> _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(status: StatusEnum.inProgress)); // Indicate that the sign-up process is underway

    try {
      await _authenticationRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        specialty: event.specialty,
        type: event.type.toString(),
        workplace: event.workplace,
      );
      emit(state.copyWith(status: StatusEnum.success)); // Emit success if signup is successful
    } catch (_) {
      emit(state.copyWith(status: StatusEnum.failure)); // Emit failure if an exception occurs
    }
  }
}