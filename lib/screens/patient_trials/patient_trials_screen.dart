import 'package:flutter/material.dart';
import 'package:flutter_gp5/enums/question_enum.dart';
import 'package:flutter_gp5/models/question_model.dart';
import 'package:flutter_gp5/models/trial_model.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';

class PatientTrialsScreen extends StatefulWidget {
  const PatientTrialsScreen({super.key});

  @override
  State<PatientTrialsScreen> createState() => _PatientTrialsScreenState();
}

class _PatientTrialsScreenState extends State<PatientTrialsScreen> {
  List<TrialModel> _trials = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Here we have to get a collection of trials for this patient from the database
    _trials = _getTrials();
    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My trials',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.00,
      ),
      body: _isLoaded
          // If the data from the database has been loaded show this:
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _trials.length,
                      itemBuilder: (context, index) {
                        final trial = _trials[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // This will redirect to a page where the selected trial will be started
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  trial.getName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          // If the data from the database has not been loaded show this:
          : const Center(child: CircularProgressIndicator()),
    );
  }

  // Test data
  List<TrialModel> _getTrials() {
    QuestionModel question_1_1 =
        QuestionModel('text1', ['one', 'two'], QuestionEnum.singleChoise);
    QuestionModel question_1_2 =
        QuestionModel('text2', ['one', 'two'], QuestionEnum.singleChoise);
    TrialModel trial1 =
        TrialModel('id1', 'name1', [question_1_1, question_1_2]);

    QuestionModel question_2_1 =
        QuestionModel('text3', ['one', 'two'], QuestionEnum.singleChoise);
    QuestionModel question_2_2 =
        QuestionModel('text4', ['one', 'two'], QuestionEnum.singleChoise);
    TrialModel trial2 =
        TrialModel('id2', 'name2', [question_2_1, question_2_2]);

    QuestionModel question_3_1 = QuestionModel(
        'text5', ['one', 'two', 'three', 'four'], QuestionEnum.multipleChoice);
    QuestionModel question_3_2 = QuestionModel(
        'text6', ['one', 'two', 'three', 'four'], QuestionEnum.multipleChoice);
    TrialModel trial3 =
        TrialModel('id3', 'name3', [question_3_1, question_3_2]);

    QuestionModel question_4_1 =
        QuestionModel('text5', [], QuestionEnum.openAnswer);
    QuestionModel question_4_2 =
        QuestionModel('text6', [], QuestionEnum.openAnswer);
    TrialModel trial4 =
        TrialModel('id4', 'name4', [question_4_1, question_4_2]);

    return [trial1, trial2, trial3, trial4];
  }
}
