import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/main.dart';

class LanguageDropdownButton extends StatefulWidget {
  const LanguageDropdownButton({super.key});

  @override
  LanguageDropdownButtonState createState() => LanguageDropdownButtonState();
}

class LanguageDropdownButtonState extends State<LanguageDropdownButton> {
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

    final supportedLanguages = [
      {'code': 'en', 'label': localizations.language_en, 'flag': 'en'},
      {'code': 'bg', 'label': localizations.language_bg, 'flag': 'bg'},
      {'code': 'de', 'label': localizations.language_de, 'flag': 'de'},
    ];

    return DropdownButton<String>(
      value: _selectedLanguageCode,
      onChanged: (String? newValue) {
        if (newValue != null) {
          _changeLanguage(newValue);
        }
      },
      items: supportedLanguages.map<DropdownMenuItem<String>>((language) {
        return DropdownMenuItem<String>(
          value: language['code'],
          child: Row(
            children: [
              CountryFlag.fromLanguageCode(
                language['flag']!,
                height: 24,
                width: 32,
                shape: const Circle(),
              ),
              const SizedBox(width: 8),
              Text(language['label']!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
