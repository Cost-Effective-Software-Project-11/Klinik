import 'package:flutter/material.dart';

class TrialQuestionnaireWidget extends StatefulWidget {
  final Function(List<QuestionnaireSection>) onSectionsChanged;

  const TrialQuestionnaireWidget({required this.onSectionsChanged});

  @override
  _TrialQuestionnaireWidgetState createState() => _TrialQuestionnaireWidgetState();
}

class _TrialQuestionnaireWidgetState extends State<TrialQuestionnaireWidget> {
  final List<QuestionnaireSection> sections = [];
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController customInputController = TextEditingController(); // Controller for custom count input

  List<String> frequencies = [
    'Daily',
    'Every # days',
    'Weekly',
    'Every # Weeks',
    'Monthly',
    'Every # Months',
    'At the end of the trial'
  ];

  void _addSection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedFrequency = 'Daily';
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Section'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    items: frequencies.map((frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFrequency = value ?? 'Daily';
                        sections.add(QuestionnaireSection(
                          title: 'Section ${sections.length + 1}',
                          frequency: 'Daily',
                          questions: [],
                        ));
                        widget.onSectionsChanged(sections);
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Fill frequency'),
                  ),
                  if (selectedFrequency.contains('#')) // If the frequency has a '#', show custom input
                    TextField(
                      controller: customInputController,
                      decoration: const InputDecoration(hintText: 'Enter count (e.g., 4 days)'),
                      keyboardType: TextInputType.number,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String finalFrequency = selectedFrequency.contains('#')
                        ? 'Every ${customInputController.text} ${selectedFrequency.split(' ')[2]}'
                        : selectedFrequency;
                    setState(() {
                      sections.add(QuestionnaireSection(
                        title: 'Section ${sections.length + 1}',
                        frequency: finalFrequency,
                        questions: [],
                      ));
                    });
                    customInputController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Section'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteSection(int index) {
    setState(() {
      sections.removeAt(index);
      widget.onSectionsChanged(sections);
    });
  }

  void _addQuestion(int sectionIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Question'),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(hintText: 'Enter question'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  sections[sectionIndex].questions.add(Question(text: questionController.text, answers: [], answerType: ''));
                  questionController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _deleteQuestion(int sectionIndex, int questionIndex) {
    setState(() {
      sections[sectionIndex].questions.removeAt(questionIndex);
    });
  }

  void _addAnswer(int sectionIndex, int questionIndex) {
    String selectedAnswerType = 'Single choice';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Answer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: answerController,
                decoration: const InputDecoration(hintText: 'Enter answer'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedAnswerType,
                items: ['Single choice', 'Multi choice', 'Text field']
                    .map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnswerType = value ?? 'Single choice';
                  });
                },
                decoration: const InputDecoration(labelText: 'Answer Type'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  sections[sectionIndex].questions[questionIndex].answers.add(Answer(
                    text: answerController.text,
                    answerType: selectedAnswerType,
                    isSelected: false,
                  ));
                  sections[sectionIndex].questions[questionIndex].answerType = selectedAnswerType;
                  answerController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _toggleAnswerSelection(int sectionIndex, int questionIndex, int answerIndex) {
    setState(() {
      Question question = sections[sectionIndex].questions[questionIndex];
      Answer answer = question.answers[answerIndex];

      if (question.answerType == 'Single choice') {
        for (var ans in question.answers) {
          ans.isSelected = false;
        }
        answer.isSelected = true;
      } else if (question.answerType == 'Multi choice') {
        answer.isSelected = !answer.isSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sections.length,
          itemBuilder: (context, sectionIndex) {
            final section = sections[sectionIndex];
            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${section.title}: ${section.frequency}'),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteSection(sectionIndex),
                  ),
                ],
              ),
              children: [
                ...section.questions.asMap().entries.map((entry) {
                  final questionIndex = entry.key;
                  final question = entry.value;
                  return ListTile(
                    title: Text(question.text),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: question.answers.asMap().entries.map((entry) {
                        final answerIndex = entry.key;
                        final answer = entry.value;

                        if (question.answerType == 'Text field') {
                          // Show text field for "Text field" answer type
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: answer.text,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  answer.text = value;
                                });
                              },
                            ),
                          );
                        } else {
                          // Show radio buttons for "Single choice" or checkboxes for "Multi choice"
                          return ListTile(
                            title: Text(answer.text),
                            leading: question.answerType == 'Single choice'
                                ? Radio<bool>(
                              value: true,
                              groupValue: answer.isSelected,
                              onChanged: (value) => _toggleAnswerSelection(sectionIndex, questionIndex, answerIndex),
                            )
                                : Checkbox(
                              value: answer.isSelected,
                              onChanged: (value) => _toggleAnswerSelection(sectionIndex, questionIndex, answerIndex),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  question.answers.removeAt(answerIndex);
                                });
                              },
                            ),
                          );
                        }
                      }).toList(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addAnswer(sectionIndex, questionIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteQuestion(sectionIndex, questionIndex), // Add delete question button here
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: () => _addQuestion(sectionIndex),
                  icon: const Icon(Icons.add),
                  label: const Text('Add question'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _addSection,
          icon: const Icon(Icons.add),
          label: const Text('Add section'),
        ),
      ],
    );
  }
}

class QuestionnaireSection {
  final String title;
  final String frequency;
  final List<Question> questions;

  QuestionnaireSection({
    required this.title,
    required this.frequency,
    required this.questions,
  });
}

class Question {
  final String text;
  final List<Answer> answers;
  String answerType;

  Question({
    required this.text,
    required this.answers,
    required this.answerType,
  });
}

class Answer {
  late final String text;
  final String answerType;
  bool isSelected;

  Answer({
    required this.text,
    required this.answerType,
    this.isSelected = false,
  });
}
