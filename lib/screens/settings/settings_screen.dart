import 'package:flutter/material.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/main.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = MyApp.locale!.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocale.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.language,
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedLanguageCode,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'bg',
                  child: Text('Български'),
                ),
                DropdownMenuItem(
                  value: 'de',
                  child: Text('Deutsch'),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguageCode = newValue!;
                });
                MyApp.setLocale(context, Locale(_selectedLanguageCode));
              },
            ),
            const Divider(),
            //for testing
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('go to home')),
            // Add other settings items here for user info
          ],
        ),
      ),
    );
  }
}
