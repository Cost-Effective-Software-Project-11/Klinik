import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';  // Import the extensions

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _dividerThickness = 2.0;

  @override
  Widget build(BuildContext context) {
    // Example percentage values
    double buttonWidth = context.widthPercentage(80); // 80% of screen width
    double buttonHeight = context.heightPercentage(10); // 10% of screen height

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
          children: [
            _buildTrialsButton(context, buttonWidth, buttonHeight),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add validation if the user is a doctor to see this button:
            // Add CreateTrial Button here:
            const Text("Create Trial"),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Help Button here:
            const Text("Help"),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Setting Button here:
            const Text("Setting"),
            _customDivider(
              thickness: _dividerThickness,
            ),
            // Add Info Button here:
            const Text("Info"),
          ],
        ),
      ),
    );
  }

  // Patient Trials button
  Widget _buildTrialsButton(BuildContext context, double width, double height) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: width,
      height: height,
      child: TextButton(
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
      ),
    );
  }

  // Custom divider
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
