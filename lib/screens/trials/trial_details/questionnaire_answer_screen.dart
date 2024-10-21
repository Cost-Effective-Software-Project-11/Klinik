import 'package:flutter/material.dart';

import '../questionnaire.dart';

class QuestionnaireAnswerScreen extends StatelessWidget {
  final QuestionnaireSection questionnaireSection;
  final String trialTitle;

  const QuestionnaireAnswerScreen({
    super.key,
    required this.questionnaireSection,
    required this.trialTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trialTitle),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child:  Center(
          child: _buildSingleChoiceWidget(questionText: "Question?"),
        ),
      ),
    );
  }
}

// Single Choice
Widget _buildSingleChoiceWidget({
  required String questionText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        questionText,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      RadioListTile<String>(
        title: const Text('Yes'),
        value: "Yes",
        groupValue: null,
        onChanged: (value) {

        },
      ),
      RadioListTile<String>(
        title: const Text('No'),
        value: "No",
        groupValue: null,
        onChanged: (value) {

        },
      ),
    ],
  );
}

Widget _buildMultipleChoiceWidget() {
  // return your widget for multiple choice
  return Text("Multiple Choice Question");
}

Widget _buildMoodScaleWidget() {
  return Text("Mood Scale Question (1-5)");
}

Widget _buildIntensityScaleWidget() {
  return Text("Intensity Scale Question (1-10)");
}
