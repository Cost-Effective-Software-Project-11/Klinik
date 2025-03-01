part of 'register_bloc.dart';

@freezed
class RegisterState with _$RegisterState {
  factory RegisterState({
    @Default(Status.initial) Status status,
    @Default('') String name,
    @Default('') String email,
    @Default(UserType.unknown) UserType userType,
    @Default(Workplace(name: '', city: '')) Workplace workplace,
    @Default('') String phone,
    @Default('') String password,
    @Default('') String repeatPassword,
    @Default([]) List<Workplace> workplaces,
    String? errorMessage,
  }) = _RegisterState;
}

