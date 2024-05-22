import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/patient_trials_screen/patient_trials_screen.dart';
import 'package:flutter_gp5/widgets/custom_app_bar.dart';
import 'package:flutter_gp5/widgets/custom_divider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _dividerThickness = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home Screen',
        backgroundColor: Colors.teal.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrialsButton(context),
              const CustomDivider(
                thickness: _dividerThickness,
              ),
              // Add validation if the user is a doctor to see this button:
              // Add CreateTrial Button here:
              const Text("Create Trial"),
              const CustomDivider(
                thickness: _dividerThickness,
              ),
              // Add Help Button here:
              const Text("Help"),
              const CustomDivider(
                thickness: _dividerThickness,
              ),
              // Add Setting Button here:
              const Text("Setting"),
              const CustomDivider(
                thickness: _dividerThickness,
              ),
              // Add Info Button here:
              const Text("Info"),
            ],
          ),
        ),
      ),
    );
  }

//Patient Trials button
  Widget _buildTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatientTrialsScreen()),
        );
      },
      child: Text(
        'Trials',
        style: TextStyle(
          fontSize: 20,
          inherit: true,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
