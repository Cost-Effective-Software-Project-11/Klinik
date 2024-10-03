import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/trial_model.dart';
import '../questionnaire.dart';

class TrialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> fetchConditions() async {
    try {
      final querySnapshot = await _firestore.collection('diseases').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> fetchMedications() async {
    try {
      final querySnapshot = await _firestore.collection('medications').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  Future<DocumentReference> createTrial({
    required String title,
    required String category,
    String? disease,
    String? medication,
    required String duration,
    required String description,
    required List<String> eligibilityCriteria,
  }) async {
    return await _firestore.collection('trials').add({
      'title': title,
      'category': category,
      'disease': disease,
      'medication': medication,
      'duration': duration,
      'description': description,
      'eligibilityCriteria': eligibilityCriteria,
    });
  }

  Future<void> createQuestionnaire({
    required String trialId,
    required List<QuestionnaireSection> questionnaireSections,
  }) async {
    // Format the questionnaire sections and questions for Firebase
    List<Map<String, dynamic>> formattedSections = questionnaireSections.map((section) {
      return {
        'title': section.title,
        'frequency': section.frequency,
        'questions': section.questions.map((question) {
          return {
            'text': question.text,
            'answerType': question.answerType,
            'answers': question.answers.map((answer) => answer.text).toList(),
          };
        }).toList(),
      };
    }).toList();

    // Add the questionnaire to the "questionnaires" collection
    await FirebaseFirestore.instance.collection('questionnaires').add({
      'trialId': trialId, // Link it to the trial
      'sections': formattedSections,
    });
  }

  Future<List<Trial>> fetchTrials() async {
    final snapshot = await _firestore.collection('trials').get();
    return snapshot.docs.map((doc) => Trial.fromFirestore(doc)).toList();
  }
}