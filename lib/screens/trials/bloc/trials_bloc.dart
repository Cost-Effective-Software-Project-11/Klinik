import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/trial_model.dart';
import '../questionnaire.dart';
import '../repository/trials_repository.dart';

part 'trials_event.dart';
part 'trials_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  final TrialRepository repository;
  List<Trial> allTrials = [];
  String searchQuery = '';

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
          trialTitle:event.title ,
          trialId: trialId,
          questionnaireSections: event.questionnaireSections, // Pass questionnaire data
        );

        emit(TrialCreated());
      } catch (e) {
        emit(TrialFormError("Failed to create trial and questionnaire"));
      }
    });

    List<Trial> _filterTrials(String query, List<Trial> trials) {
      return trials.where((trial) {
        final matchesTitle = trial.title.toLowerCase().contains(query.toLowerCase());
        final matchesDescription = trial.description.toLowerCase().contains(query.toLowerCase());
        return matchesTitle || matchesDescription;
      }).toList();
    }

    on<UpdateTrialSearchQuery>((event, emit) {
      searchQuery = event.query;
      final filteredTrials = _filterTrials(searchQuery, allTrials);
      final currentState = state;

      if (currentState is TrialsLoaded) {
        emit(currentState.copyWith(trials: filteredTrials, searchQuery: searchQuery));
      } else {
        emit(TrialsLoaded(filteredTrials, searchQuery: searchQuery));
      }
    });

    on<ClearsFilters>((event, emit) {
      searchQuery = ''; // Clear the search query

      // Emit the state with all trials (i.e., reset to unfiltered)
      if (allTrials.isNotEmpty) {
        emit(TrialsLoaded(List.from(allTrials))); // Ensure all trials are reloaded
      } else {
        emit(TrialFormError("No trials available"));
      }
    });

    // Handle fetching all trials
    on<FetchTrials>((event, emit) async {
      emit(TrialLoading());
      try {
        final trials = await repository.fetchTrials();
        allTrials = trials;
        emit(TrialsLoaded(trials));
      } catch (e) {
        emit(TrialFormError("Failed to fetch trials"));
      }
    });

    on<PublishTrial>((event, emit) async {
      emit(TrialLoading());
      try {
        await repository.publishTrial(event.trialId);
        final updatedTrials = await repository.fetchTrials();
        emit(TrialsLoaded(updatedTrials));
      } catch (e) {
        emit(TrialFormError("Failed to publish trial"));
      }
    });
  }
}
