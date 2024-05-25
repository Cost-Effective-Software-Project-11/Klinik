import 'package:flutter_gp5/models/question_model.dart';

class TrialModel {
  String id;
  String name;
  List<QuestionModel> questions = [];

  TrialModel(
    this.id,
    this.name,
    this.questions,
  );

  //Getters
  String get getId => id;
  String get getName => name;
  List<QuestionModel> get getAllQuestions => questions;
  int get questionsCount => questions.length;

  //Setters
  set setId(String id) {
    this.id = id;
  }

  set setName(String name) {
    this.name = name;
  }

  set setSungleQuestion(QuestionModel question) {
    questions.add(question);
  }

  set setAllQuestions(List<QuestionModel> allQuestions) {
    questions = allQuestions;
  }

// Method to convert a TrialModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  // Method to create a TrialModel instance from JSON
  factory TrialModel.fromJson(Map<String, dynamic> json) {
    return TrialModel(
      json['id'],
      json['name'],
      (json['questions'] as List<dynamic>)
          .map((questionJson) => QuestionModel.fromJson(questionJson))
          .toList(),
    );
  }
}
