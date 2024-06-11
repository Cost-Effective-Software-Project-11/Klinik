import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/screens/auth/login/bloc/status_enum.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: StatusEnum.inProgress));
    try {
      await _authenticationRepository.logIn(
        username: state.username,
        password: state.password,
      );
      emit(state.copyWith(status: StatusEnum.success));
    } catch (_) {
      emit(state.copyWith(status: StatusEnum.failure));
    }
  }
}