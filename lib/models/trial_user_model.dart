class TrialUserModel {
  String id;
  String name;
  String userId;
  List<String> questionsAndAnswers = [];

  TrialUserModel(
    this.id,
    this.name,
    this.userId,
    this.questionsAndAnswers,
  );

  //Getters
  String get getId => id;
  String get getName => name;
  String get getUserId => userId;
  List<String> get getAllQuestionsAndAnswers => questionsAndAnswers;

  //Setters
  set setId(String id) {
    this.id = id;
  }

  set setName(String name) {
    this.name = name;
  }

  void setAnswerAndQuestion(String question, String answer) {
    String result = '$question => $answer';
    questionsAndAnswers.add(result);
  }

// Method to convert a TrialModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'questionsAndAnswers': questionsAndAnswers,
    };
  }

  // Method to create a TrialModel instance from JSON
  factory TrialUserModel.fromJson(Map<String, dynamic> json) {
    return TrialUserModel(
      json['id'],
      json['name'],
      json['userId'],
      List<String>.from(json['questionsAndAnswers']),
    );
  }
}
