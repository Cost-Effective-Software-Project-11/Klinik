part of 'trials_bloc.dart';

abstract class TrialState {}

// Initial state when the form is not yet loaded
class TrialInitial extends TrialState {}

// State when the form (categories, conditions, medications) is loaded
class TrialFormLoaded extends TrialState {
  final List<String> categories;
  final List<String> conditions;
  final List<String> medications;

  TrialFormLoaded({
    required this.categories,
    required this.conditions,
    required this.medications,
  });
}

// State when the trials are successfully loaded
class TrialsLoaded extends TrialState {
  final List<Trial> trials;

  TrialsLoaded(this.trials);
}

// State when a trial is successfully created
class TrialCreated extends TrialState {}

// State when something is loading (either creating or fetching)
class TrialLoading extends TrialState {}

// State when there is an error
class TrialFormError extends TrialState {
  final String message;

  TrialFormError(this.message);
}
