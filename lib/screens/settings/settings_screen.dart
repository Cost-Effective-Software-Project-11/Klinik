import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/main.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:country_flags/country_flags.dart';

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

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguageCode = languageCode;
    });
    MyApp.setLocale(context, Locale(_selectedLanguageCode));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocale.of(context)!;

    // List of supported languages
    final languages = [
      {'code': 'en', 'label': localizations.language_en, 'flag': 'en'},
      {'code': 'bg', 'label': localizations.language_bg, 'flag': 'bg'},
      {'code': 'de', 'label': localizations.language_de, 'flag': 'de'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                localizations.language,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: _selectedLanguageCode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _changeLanguage(newValue);
                  }
                },
                items: languages.map<DropdownMenuItem<String>>((language) {
                  return DropdownMenuItem<String>(
                    value: language['code'],
                    child: Row(
                      children: [
                        CountryFlag.fromLanguageCode(
                          language['flag']!,
                          height: 24,
                          width: 32,
                          //shape: const RoundedRectangle(6),
                          shape: const Circle(),
                        ),
                        const SizedBox(width: 8),
                        Text(language['label']!),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }
}
