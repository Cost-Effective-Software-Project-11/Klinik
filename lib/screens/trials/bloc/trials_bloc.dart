import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/trial_model.dart';
import '../questionnaire.dart';
import '../repository/trials_repository.dart';

part 'trials_event.dart';
part 'trials_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  final TrialRepository repository;

  TrialBloc(this.repository) : super(TrialInitial()) {
    on<LoadTrialForm>((event, emit) async {
      try {
        final categories = await repository.fetchCategories();
        final conditions = await repository.fetchConditions();
        final medications = await repository.fetchMedications();

        emit(TrialFormLoaded(categories: categories, conditions: conditions, medications: medications));
      } catch (e) {
        emit(TrialFormError("Failed to load form data"));
      }
    });

    String getLoggedInDoctorId() {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception('No user is logged in');
      }
    }

    // Handle creating a trial
    on<CreateTrial>((event, emit) async {
      emit(TrialLoading());

      final doctorId = getLoggedInDoctorId();

      try {
        // Step 1: Create the trial in Firebase and get the DocumentReference
        final trialDoc = await repository.createTrial(
          title: event.title,
          category: event.category,
          disease: event.disease,
          medication: event.medication,
          duration: event.duration,
          description: event.description,
          eligibilityCriteria: event.eligibilityCriteria,
          doctorId: doctorId,
          isPublished: false,
        );

        final trialId = trialDoc.id; // Get the trial ID from the DocumentReference

        // Step 2: Create the questionnaire, linked with the trialId
        await repository.createQuestionnaire(
          trialId: trialId,
          questionnaireSections: event.questionnaireSections, // Pass questionnaire data
        );

        emit(TrialCreated());
      } catch (e) {
        emit(TrialFormError("Failed to create trial and questionnaire"));
      }
    });

    // Handle fetching all trials
    on<FetchTrials>((event, emit) async {
      emit(TrialLoading());
      try {
        final trials = await repository.fetchTrials();
        emit(TrialsLoaded(trials));
      } catch (e) {
        emit(TrialFormError("Failed to fetch trials"));
      }
    });
  }
}
