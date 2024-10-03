part of 'trials_bloc.dart';

abstract class TrialEvent {}

// Event to load the form data (categories, conditions, medications)
class LoadTrialForm extends TrialEvent {}

// Event to create a new trial
class CreateTrial extends TrialEvent {
  final String title;
  final String category;
  final String? disease;
  final String? medication;
  final String duration;
  final String description;
  final List<String> eligibilityCriteria;
  final List<QuestionnaireSection> questionnaireSections;

  CreateTrial({
    required this.title,
    required this.category,
    this.disease,
    this.medication,
    required this.duration,
    required this.description,
    required this.eligibilityCriteria,
    required this.questionnaireSections, // Add the questionnaire sections
  });
}

// Event to fetch the list of trials
class FetchTrials extends TrialEvent {}
