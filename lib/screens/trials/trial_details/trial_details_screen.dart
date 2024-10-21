import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/trials/models/trial_model.dart';
import 'package:flutter_gp5/screens/trials/trial_details/questionnaire_answer_screen.dart';

import '../questionnaire.dart';

class TrialDetailsScreen extends StatelessWidget {
  final Trial trial;
  final QuestionnaireSection questionnaireSection;

  const TrialDetailsScreen({super.key, required this.trial, required this.questionnaireSection,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trials'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(trial.title),
              SizedBox(height: context.setHeight(3),),
              _buildLabelValueRow('Category:', trial.category),
              SizedBox(height: context.setHeight(1.2),),
              if (trial.disease != null) ...[
                _buildLabelValueRow('Disease:', trial.disease!),
                SizedBox(height: context.setHeight(1.2)),
              ],
              if (trial.disease != null) ...[
                _buildLabelValueRow('Medication:', trial.medication!),
                SizedBox(height: context.setHeight(1.2)),
              ],
              _buildLabelValueRow('Duration:', trial.duration),
              SizedBox(height: context.setHeight(1.2),),
              _buildLabelValueRow('Author:', trial.doctorName),
              SizedBox(height: context.setHeight(1.2),),
              _buildDescription(trial.description),
              SizedBox(height: context.setHeight(1.2),),
              _buildEligibilityCriteria(trial.eligibilityCriteria,context),
              _buildQuestionnaireInfo(context),
              SizedBox(height: context.setHeight(4),),
              _buildButtonSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black),
        children: [
          TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.normal)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        description,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }


  Widget _buildEligibilityCriteria(List<String> criteria,BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border:  Border(bottom: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Eligibility Criteria:', style: TextStyle(fontSize: 14)),
          SizedBox(height: context.setHeight(1)),
          for (var item in criteria)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16, color: Colors.black)),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaireInfo(BuildContext context) {
    return  SizedBox(
      width: context.setWidth(90),
      child: const Text(
        'The questionnaire will be divided into different sections. Patients will be asked to fill this out daily or weekly, depending on the question type.',
        style: TextStyle(fontSize: 12, color: Colors.black),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildButtonSection(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBackButton(),
          const SizedBox(width: 20),
          _buildBeginTrialButton(context),
        ],
      ),
    );
  }

  ElevatedButton _buildBackButton() {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6750A4),
        side: const BorderSide(color: const Color(0xFF6750A4)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 45),
      ),
      child: const Text("Back", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  ElevatedButton _buildBeginTrialButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuestionnaireAnswerScreen(trialTitle: trial.title,questionnaireSection:questionnaireSection,)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      ),
      child: const Text("Begin Trial", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
