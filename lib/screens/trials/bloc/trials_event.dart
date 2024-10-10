part of 'trials_bloc.dart';

abstract class TrialEvent {}

class LoadTrialForm extends TrialEvent {}

class CreateTrial extends TrialEvent {
  final String title;
  final String category;
  final String? disease;
  final String? medication;
  final String duration;
  final String description;
  final List<String> eligibilityCriteria;
  final List<QuestionnaireSection> questionnaireSections;
  final String doctorId;

  CreateTrial({
    required this.title,
    required this.category,
    this.disease,
    this.medication,
    required this.duration,
    required this.description,
    required this.eligibilityCriteria,
    required this.questionnaireSections,
    required this.doctorId,
  });
}

class FetchTrials extends TrialEvent {}

class PublishTrial extends TrialEvent {
  final String trialId;
  PublishTrial(this.trialId);
  List<Object> get props => [trialId];
}
