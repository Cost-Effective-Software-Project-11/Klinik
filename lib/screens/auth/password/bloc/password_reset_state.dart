part of 'password_reset_bloc.dart';

abstract class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object> get props => [];
}

class EmailInitial extends EmailState {}

class EmailLoading extends EmailState {}

class EmailSentSuccess extends EmailState {}

class EmailSentFailure extends EmailState {
  final String errorMessage;

  const EmailSentFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
