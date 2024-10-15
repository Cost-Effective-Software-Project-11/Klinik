import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import '../../../widgets/bottom_nav_bar.dart' as custom;
import '../bloc/trials_bloc.dart';
import '../questionnaire.dart';
import '../repository/trials_repository.dart';

class CreateTrialScreen extends StatefulWidget {
  const CreateTrialScreen({Key? key}) : super(key: key);

  @override
  _CreateTrialScreenState createState() => _CreateTrialScreenState();
}

class _CreateTrialScreenState extends State<CreateTrialScreen> {
  final List<String> eligibilityCriteria = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController criteriaController = TextEditingController();
  String? selectedCategory;
  String? selectedCondition;
  String? selectedMedication;
  List<QuestionnaireSection> questionnaireSections = [];

  @override
  void dispose() {
    titleController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    criteriaController.dispose();
    super.dispose();
  }

  void _addCriteria() {
    if (criteriaController.text.isNotEmpty) {
      setState(() {
        eligibilityCriteria.add(criteriaController.text);
        criteriaController.clear();
      });
      Navigator.of(context).pop(); // Close dialog
    }
  }

  void _showAddCriteriaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Criteria'),
          content: TextField(
            controller: criteriaController,
            decoration: const InputDecoration(
              hintText: 'Enter criteria',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _addCriteria,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _createTrial(BuildContext context) {
    final title = titleController.text;
    final duration = durationController.text;
    final description = descriptionController.text;

    if (title.isEmpty || selectedCategory == null || duration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the required fields')),
      );
      return;
    }

    final doctorId = getLoggedInDoctorId();

    // Dispatch the CreateTrial event
    BlocProvider.of<TrialBloc>(context).add(
      CreateTrial(
        title: title,
        category: selectedCategory!,
        disease: selectedCondition,
        medication: selectedMedication,
        duration: duration,
        description: description,
        eligibilityCriteria: eligibilityCriteria,
        questionnaireSections: questionnaireSections,
        doctorId: doctorId,
      ),
    );
  }

  String getLoggedInDoctorId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrialBloc(TrialRepository())..add(LoadTrialForm()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(context.setHeight(7)),
          child: Padding(
            padding: EdgeInsets.only(top: context.setHeight(3)),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.navigate_before, color: Color(0xFF1D1B20)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Create New Trial',
                style: TextStyle(
                  color: const Color(0xFF1D1B20),
                  fontSize: context.setWidth(5), // Set uniform font size for title
                  fontWeight: FontWeight.w400,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),
        body: Stack(
          children: [
            backgroundDecoration(),
            BlocConsumer<TrialBloc, TrialState>(
              listener: (context, state) {
                if (state is TrialCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trial successfully created')),
                  );
                  Navigator.of(context).pop();
                } else if (state is TrialFormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is TrialFormLoaded) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Trial title',
                                labelStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              items: state.categories
                                  .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              items: state.conditions
                                  .map((condition) => DropdownMenuItem(
                                value: condition,
                                child: Text(
                                  condition,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCondition = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Disease/Condition',
                                hintText: 'optional',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              items: state.medications
                                  .map((medication) => DropdownMenuItem(
                                value: medication,
                                child: Text(
                                  medication,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMedication = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Medication',
                                hintText: 'optional',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            TextField(
                              controller: durationController,
                              decoration: InputDecoration(
                                labelText: 'Duration',
                                labelStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 16),
                            Container(
                              width: context.setWidth(100),
                              height: 140,
                              padding: const EdgeInsets.all(14),
                              decoration: ShapeDecoration(
                                color: const Color(0x7FFEF7FF),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFFA59FA6)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: TextField(
                                controller: descriptionController,
                                maxLines: null,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Add trial description...',
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF49454F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildEligibilityCriteria(),
                            const SizedBox(height: 16),
                            Text(
                              'Trial questionnaire:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.setWidth(4),
                              ),
                            ),
                            TrialQuestionnaireWidget(
                              onSectionsChanged: (sections) {
                                setState(() {
                                  questionnaireSections = sections;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            buildActionButtons(context),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is TrialFormError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
        bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 0),
      ),
    );
  }

  Widget backgroundDecoration() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildFieldContainer({
    required String label,
    required TextEditingController controller,
    required Color hintTextColor,
  }) {
    return Container(
      width: 312,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                hintStyle: TextStyle(
                  color: hintTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownContainer({
    required String label,
    String? hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: 312,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(width: 1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint ?? label),
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 16)),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildEligibilityCriteria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eligibility Criteria:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.setWidth(4),
          ),
        ),
        const SizedBox(height: 8),

        // Display each criteria with a delete button
        for (var i = 0; i < eligibilityCriteria.length; i++)
          Row(
            children: [
              const Text('• '),
              Expanded(
                child: Text(
                  eligibilityCriteria[i],
                  style: TextStyle(
                    fontSize: context.setWidth(4),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Remove the selected criteria from the list
                  setState(() {
                    eligibilityCriteria.removeAt(i);
                  });
                },
              ),
            ],
          ),

        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _showAddCriteriaDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add criteria'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _createTrial(context),
          child: const Text('Create Trial'),
        ),
      ],
    );
  }
}
