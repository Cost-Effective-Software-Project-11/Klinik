import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/main.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/settings/supported_languages_dropdoown.dart';  // Import the new widget

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

    var height = context.setHeight(10);
    var width = context.setWidth(10);

    // List of supported languages
    final supportedLanguages = [
      {'languageCode': 'en', 'languageName': localizations.language_en, 'countryCode': 'en'},
      {'languageCode': 'bg', 'languageName': localizations.language_bg, 'countryCode': 'bg'},
      {'languageCode': 'de', 'languageName': localizations.language_de, 'countryCode': 'de'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.language,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height, width: width),
              SupportedLanguagesDropdown(
                selectedLanguageCode: _selectedLanguageCode,
                onChanged: _changeLanguage,
                supportedLanguages: supportedLanguages,
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
