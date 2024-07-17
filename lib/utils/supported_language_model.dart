class Language {
  final String languageCode;
  final String label;
  final String countryCode;

  Language({
    required this.languageCode,
    required this.label,
    required this.countryCode,
  });

  static List<Language> supportedLanguages() {
    return [
      Language(languageCode: 'en', label: 'English', countryCode: 'en'),
      Language(languageCode: 'bg', label: 'Български', countryCode: 'bg'),
      Language(languageCode: 'de', label: 'Deutsch', countryCode: 'de'),
    ];
  }
}
