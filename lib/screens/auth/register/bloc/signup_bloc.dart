import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_gp5/screens/auth/enums/status_enum.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository authenticationRepository;

  SignupBloc({required this.authenticationRepository}) : super(const SignupState()) {
    on<SignupSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: StatusEnum.inProgress));
    try {
      await authenticationRepository.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: StatusEnum.success));
    } catch (_) {
      emit(state.copyWith(status: StatusEnum.failure));
    }
  }
}