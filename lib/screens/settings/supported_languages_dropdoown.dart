import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';



class SupportedLanguagesDropdown extends StatelessWidget {
  final String selectedLanguageCode;
  final ValueChanged<String> onChanged;
  final List<Map<String, String>> supportedLanguages;

  const SupportedLanguagesDropdown({
    super.key,
    required this.selectedLanguageCode,
    required this.onChanged,
    required this.supportedLanguages,
  });

  @override
  Widget build(BuildContext context) {

    return DropdownButton<String>(
      value: selectedLanguageCode,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: supportedLanguages.map<DropdownMenuItem<String>>((language) {
        return DropdownMenuItem<String>(
          value: language['languageCode'],
          child: Row(
            children: [
              CountryFlag.fromLanguageCode(
                language['countryCode']!,
                height: 24,
                width: 32,
                shape: const Circle(),
              ),
              const SizedBox(width: 8),
              Text(language['languageName']!),
            ],
          ),
        );
      }).toList(),
    );
  }
}
