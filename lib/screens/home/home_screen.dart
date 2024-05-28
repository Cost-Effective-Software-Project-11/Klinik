import 'package:flutter/material.dart';
<<<<<<< CreateЕxtensionОnBuildContext
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
=======
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';
import 'package:flutter_gp5/screens/settings/settings_screen.dart';
>>>>>>> master

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double containerWidth = context.widthPercentage(60); // 50% of screen width
    double containerHeight = context.heightPercentage(30); // 30% of screen height

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
<<<<<<< CreateЕxtensionОnBuildContext
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          color: Colors.blue,
          child: const Center(
            child: Text(
              '50% width, 30% height',
              style: TextStyle(color: Colors.white),
            ),
=======
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrialsButton(context),
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
              _buildSettingsButton(context),
              _customDivider(
                thickness: _dividerThickness,
              ),
              // Add Info Button here:
              const Text("Info"),
            ],
>>>>>>> master
          ),
        ),
      ),
    );
  }
}

<<<<<<< CreateЕxtensionОnBuildContext
void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
=======
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
>>>>>>> master
}
