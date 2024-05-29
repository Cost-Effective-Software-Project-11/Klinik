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
          ? ListView.builder(
              itemCount: _trials.length,
              itemBuilder: (context, index) {
                final trial = _trials[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    //Open the trial
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // This will redirect to a page where the selected trial will be started
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    //The trial info visualization
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
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
            )
          // If the data from the database has not been loaded show this:
          : const Center(child: CircularProgressIndicator()),
    );
  }

  // Test data
  List<TrialModel> _getTrials() {
    //One
    QuestionModel question_1_1 = QuestionModel(
        'Pain/stiffness during the day. How severe was your usual joint or muscle pain and/or stiffness overall during the day in the last 2 weeks?',
        [
          'Not at all',
          'Slightly',
          'Moderately',
          'Fairly severe',
          'Very severe'
        ],
        QuestionEnum.radioButton);
    QuestionModel question_1_2 = QuestionModel(
        'Pain/stiffness during the night.How severe was your usual joint or muscle pain and/or stiffness overall during the night in the last 2 weeks?',
        [
          'Not at all',
          'Slightly',
          'Moderately',
          'Fairly severe',
          'Very severe'
        ],
        QuestionEnum.radioButton);
    TrialModel trial1 = TrialModel(
        '1',
        'AR UK MUSCULOSKELETAL HEALTH QUESTIONNAIRE MSK-HQ (military)',
        'This questionnaire is about your joint, back, neck, bone and muscle symptoms such as aches, pains and/or stiffness. Please focus on the particular health problem(s) for which you sought treatment from this service. For each question tick (x) one box to indicate which statement best describes you over the last 2 weeks.',
        [question_1_1, question_1_2]);

    //Two
    QuestionModel question_2_1 = QuestionModel(
        'My back pain has spread down my leg(s) in the last 2 weeks',
        ['Yes', 'No'],
        QuestionEnum.radioButton);
    QuestionModel question_2_2 = QuestionModel(
        'I have had pain in the shoulder or neck at some time in the last 2 weeks',
        ['Yes', 'No'],
        QuestionEnum.radioButton);
    TrialModel trial2 = TrialModel(
        '2',
        'STarT BACK',
        'Thinking about the last 2 weeks tick your response to the following questions:',
        [question_2_1, question_2_2]);
    //Three
    QuestionModel question_3_1 = QuestionModel(
        'Pain Intensity',
        [
          'I have no pain at the moment.',
          'The pain is very mild at the moment.',
          'The pain is moderate at the moment.',
          'The pain is fairly severe at the moment.',
          'The pain is very severe at the moment.',
          'The pain is the worst imaginable at the moment.'
        ],
        QuestionEnum.radioButton);
    QuestionModel question_3_2 = QuestionModel(
        'Personal Care (Washing, Dressing, etc.) ',
        [
          'I can look after myself normally without causing extra pain.',
          'I can look after myself normally but it is very painful.',
          'It is painful to look after myself and I am slow and careful.',
          'I need some help but manage most of my personal care.',
          'I need help every day in most aspects in self care.',
          'I do not get dressed, wash with difficulty and stay in bed.'
        ],
        QuestionEnum.radioButton);
    TrialModel trial3 = TrialModel(
        '3',
        'THE OSWESTRY DISABILITY INDEX',
        'This questionnaire has been designed to give your therapists information as to how your back / leg pain has affected your ability to manage in everyday life. Please answer every question by placing a mark on the line that best describes your condition today. We realise you may feel that two of the statements may describe your condition, but please mark only the line which most closely describes your current condition.',
        [question_3_1, question_3_2]);
    //Four
    QuestionModel question_4_1 = QuestionModel(
        'Describe your emotional state in a few sentences',
        [],
        QuestionEnum.freeText);
    QuestionModel question_4_2 = QuestionModel(
        'Tell us about your last 2 weeks', [], QuestionEnum.freeText);
    TrialModel trial4 = TrialModel(
        '4',
        'Emotional well-being',
        'This questionnaire is about your Emotional well-being.',
        [question_4_1, question_4_2]);
    //Five
    QuestionModel question_5_1 = QuestionModel(
        'First question',
        ['checkbox 1', 'checkbox 2', 'checkbox 3', 'checkbox 4'],
        QuestionEnum.checkbox);
    QuestionModel question_5_2 = QuestionModel(
        'Second question',
        ['checkbox 1', 'checkbox 2', 'checkbox 3', 'checkbox 4'],
        QuestionEnum.checkbox);
    TrialModel trial5 = TrialModel('5', 'Example',
        'This questionnaire is an Example.', [question_5_1, question_5_2]);
    return [trial1, trial2, trial3, trial4, trial5];
  }
}
