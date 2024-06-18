import 'package:flutter/material.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';
import 'package:flutter_gp5/screens/create_trials/create_trials_screen.dart';
import 'package:flutter_gp5/screens/settings/settings_screen.dart'; //localization file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _dividerThickness = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //use localization
          'Home Screen: ${AppLocale.of(context)!.title}',
          style: const TextStyle(color: Colors.white),
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
            _buildCreateTrialsButton(context),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
      },
      child: Text(
        AppLocale.of(context)!.settingsTitle,
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

  Widget _buildCreateTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTrialsScreen()),
        );
      },
      child: Text(
        'Create Trials',
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
