import 'package:flutter/material.dart';
import 'package:flutter_gp5/models/trial_user_model.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';

class TrialCompletedScreen extends StatelessWidget {
  final TrialUserModel completedTrial;

  const TrialCompletedScreen({super.key, required this.completedTrial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trial Completed'),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Trial Completed Successfully!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => print(completedTrial.toJson()),
                child: const Text('Export to PDF'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientTrialsScreen()),
                    );
                  },
                  child: const Text('Go back to My Trials'),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('go to home')),
          ],
        ),
      ),
    );
  }
}
