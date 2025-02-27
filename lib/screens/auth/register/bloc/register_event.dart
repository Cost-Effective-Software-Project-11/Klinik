part of 'register_bloc.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.onLoad() = _OnLoad;

  const factory RegisterEvent.onNameChanged(String name) = _OnNameChanged;

  const factory RegisterEvent.onEmailChanged(String email) = _OnEmailChanged;

  const factory RegisterEvent.onWorkplaceChanged(Workplace workplace) =
      _OnWorkplaceChanged;

  const factory RegisterEvent.onPhoneChanged(String phone) = _OnPhoneChanged;

  const factory RegisterEvent.onPasswordChanged(String password) =
      _OnPasswordChanged;

  const factory RegisterEvent.onRepeatPasswordChanged(String repeatPassword) =
      _OnRepeatPasswordChanged;

  const factory RegisterEvent.onSubmitted() = _OnSubmitted;
}
