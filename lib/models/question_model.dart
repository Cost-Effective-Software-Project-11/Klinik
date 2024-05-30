import 'package:flutter_gp5/enums/question_enum.dart';

class QuestionModel {
  String text;
  List<String> answers = [];
  QuestionEnum type;

  QuestionModel(this.text, this.answers, this.type);

  //Getters
  String get getText => text;
  List<String> get allAnswers => answers;
  QuestionEnum get questionType => type;

  //Setters
  set setQuestionText(String text) {
    text = text;
  }

  set setAnswer(String answer) {
    allAnswers.add(answer);
  }

  set setAllAnswers(List<String> allAnswers) {
    answers = allAnswers;
  }

  set setQuestionType(QuestionEnum enumType) {
    type = enumType;
  }

// Method to convert a Question instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'questionText': text,
      'answers': answers,
      'type': type.toString().split('.').last,
    };
  }

  // Method to create a Question instance from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      json['questionText'],
      List<String>.from(json['answers']),
      QuestionEnum.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
    );
  }
}
