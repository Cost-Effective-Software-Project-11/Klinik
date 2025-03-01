import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gp5/enums/status.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/services/hospital_service.dart';
import 'package:flutter_gp5/utils/firebase_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(
    this._authenticationRepository,
    this._workplaceService,
    this.userType,
  ) : super(RegisterState()) {
    on<_OnLoad>(_onLoad);
    on<_OnNameChanged>(_onNameChanged);
    on<_OnEmailChanged>(_onEmailChanged);
    on<_OnWorkplaceChanged>(_onWorkplaceChanged);
    on<_OnPhoneChanged>(_onPhoneChanged);
    on<_OnPasswordChanged>(_onPasswordChanged);
    on<_OnRepeatPasswordChanged>(_onRepeatPasswordChanged);
    on<_OnSubmitted>(_onSubmitted);

    /// Register initial event
    add(const _OnLoad());
  }

  final AuthenticationRepository _authenticationRepository;
  final HospitalService _workplaceService;
  final UserType userType;

  Future<void> _onLoad(_OnLoad event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final workplaces = await _workplaceService.fetchWorkplaces();
      emit(state.copyWith(userType: userType, workplaces: workplaces, status: Status.success));
    } catch (error) {
      emit(state.copyWith(
          errorMessage: 'Failed to fetch hospitals: $error',
          status: Status.error));
    }
  }

  void _onNameChanged(_OnNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(_OnEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onWorkplaceChanged(
      _OnWorkplaceChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(workplace: event.workplace));
  }

  void _onPhoneChanged(_OnPhoneChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onPasswordChanged(_OnPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onRepeatPasswordChanged(_OnRepeatPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(repeatPassword: event.repeatPassword));
  }

  Future<void> _onSubmitted(_OnSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _authenticationRepository.register(
        email: state.email,
        password: state.password,
        name: state.name,
        phone: state.phone,
        workplace: state.workplace,
        userType: UserType.doctor
      );
      emit(state.copyWith(status: Status.success));
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseUtils.getErrorMessage(e);
      emit(state.copyWith(status: Status.error, errorMessage: errorMessage));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
