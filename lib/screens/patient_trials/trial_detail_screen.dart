import 'package:flutter/material.dart';
import 'package:flutter_gp5/models/question_model.dart';
import 'package:flutter_gp5/models/trial_model.dart';
import 'package:flutter_gp5/models/trial_user_model.dart';
import 'package:flutter_gp5/enums/question_enum.dart';
import 'package:flutter_gp5/screens/patient_trials/trial_completed_screen.dart';

class TrialDetailScreen extends StatefulWidget {
  final TrialModel trial;
  final String userId; // ID of the patient taking the trial

  const TrialDetailScreen(
      {super.key, required this.trial, required this.userId});

  @override
  State<TrialDetailScreen> createState() => _TrialDetailScreenState();
}

class _TrialDetailScreenState extends State<TrialDetailScreen> {
  int _currentQuestionIndex = -1; // Index of the current question
  final Map<int, dynamic> _answers =
      {}; // Map to store answers for each question
  final TextEditingController _textEditingController =
      TextEditingController(); // Controller for input text fields

  // Private method to start the trial by setting the first question
  void _startTrial() {
    setState(() {
      _currentQuestionIndex = 0;
      _textEditingController.clear();
    });
  }

  // Private method to store the answer for the current question
  void _answerQuestion(dynamic answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  // Private method to check if an answer has been provided for the current question
  bool _isAnswerProvided() {
    final currentAnswer = _answers[_currentQuestionIndex];
    final question = widget.trial.questions[_currentQuestionIndex];

    if (question.type == QuestionEnum.inputText) {
      return currentAnswer != null && currentAnswer.isNotEmpty;
    } else if (question.type == QuestionEnum.radioButton) {
      return currentAnswer != null;
    } else if (question.type == QuestionEnum.checkbox) {
      return currentAnswer != null && currentAnswer.isNotEmpty;
    }
    return false;
  }

  // Private method to move to the next question or submit the trial if it's the last question
  void _nextQuestion() {
    if (!_isAnswerProvided()) {
      ScaffoldMessenger.of(context).showSnackBar(
        //Message to display if no answer is selected
        const SnackBar(
            content: Text('Please provide an answer before proceeding.')),
      );
      return;
    }

    if (_currentQuestionIndex < widget.trial.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _textEditingController.clear();
      });
    } else {
      _submitTrial();
    }
  }

  // Private method to submit the trial and navigate to the completion screen
  void _submitTrial() {
    final questionsAndAnswers =
        widget.trial.questions.asMap().entries.map((entry) {
      final index = entry.key;
      final question = entry.value;
      final answer = _answers[index];
      return '${question.text} => $answer';
    }).toList();

    final completedTrial = TrialUserModel(
      widget.trial.getId,
      widget.trial.getName,
      widget.userId,
      questionsAndAnswers,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrialCompletedScreen(
          completedTrial: completedTrial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trial.getName,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentQuestionIndex == -1 ? _buildIntro() : _buildQuestion(),
      ),
    );
  }

  // Widget to display the introduction screen
  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.trial.getName,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.trial.description,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: ElevatedButton(
            onPressed: _startTrial,
            child: const Text('Start Trial'),
          ),
        ),
      ],
    );
  }

  // Widget to display the current question
  Widget _buildQuestion() {
    final question = widget.trial.questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Display the current question number and all questions count
        Text(
          'Question ${_currentQuestionIndex + 1}/${widget.trial.questions.length}',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Text(
          question.text,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 16.0),
        // Display the current question
        _buildQuestionWidget(question),
        const SizedBox(height: 16.0),
        Center(
          child: ElevatedButton(
            onPressed: _nextQuestion,
            child: Text(
                _currentQuestionIndex < widget.trial.questions.length - 1
                    ? 'Next Question'
                    : 'Submit'),
          ),
        ),
      ],
    );
  }

  // Widget to display the appropriate input widget based on the question type
  Widget _buildQuestionWidget(QuestionModel question) {
    if (question.type == QuestionEnum.inputText) {
      return TextField(
        controller: _textEditingController,
        keyboardAppearance: Brightness.dark,
        autocorrect: false,
        showCursor: true,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => _answerQuestion(value),
      );
    } else if (question.type == QuestionEnum.radioButton) {
      return Column(
        children: question.allAnswers
            .map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _answers[_currentQuestionIndex],
                  onChanged: (String? value) {
                    _answerQuestion(value);
                  },
                ))
            .toList(),
      );
    } else if (question.type == QuestionEnum.checkbox) {
      return Column(
        children: question.allAnswers
            .map((option) => CheckboxListTile(
                  title: Text(option),
                  value: _answers[_currentQuestionIndex]?.contains(option) ??
                      false,
                  onChanged: (bool? value) {
                    final answers =
                        _answers[_currentQuestionIndex] ?? <String>[];
                    if (value == true) {
                      answers.add(option);
                    } else {
                      answers.remove(option);
                    }
                    _answerQuestion(answers);
                  },
                ))
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
