import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const SettingsScreen({required this.onLocaleChange, super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale _selectedLocale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
            DropdownButton<Locale>(
              value: _selectedLocale,
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('bg'),
                  child: Text('Български'),
                ),
                DropdownMenuItem(
                  value: Locale('de'),
                  child: Text('Deutsch'),
                ),
              ],
              onChanged: (Locale? newValue) {
                setState(() {
                  _selectedLocale = newValue!;
                });
                widget.onLocaleChange(_selectedLocale);
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
