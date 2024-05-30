import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';
import 'package:flutter_gp5/screens/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _dividerThickness = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.00,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTrialsButton(context),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add validation if the user is a doctor to see this button:
            // Add CreateTrial Button here:
            const Text(
              "Create Trial",
              textAlign: TextAlign.center,
            ),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Help Button here:
            const Text("Help", textAlign: TextAlign.center),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Setting Button here:
            _buildSettingsButton(context),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Info Button here:
            const Text("Info", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

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

  Widget _buildSettingsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      },
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 20,
          inherit: true,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

//Custom divider
  Divider _customDivider({
    double thickness = 0.0,
    Color color = Colors.black,
    double indent = 0.0,
    double endIndent = 0.0,
    double height = 0.0,
  }) {
    return Divider(
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}
