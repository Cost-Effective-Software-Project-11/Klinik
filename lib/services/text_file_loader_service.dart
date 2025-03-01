import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gp5/config/log.dart';

class TextFileLoaderService {
  static final TextFileLoaderService _instance = TextFileLoaderService._internal();
  factory TextFileLoaderService() => _instance;
  TextFileLoaderService._internal();

  String _termsOfService = '';
  String _privacyPolicy = '';

  static const termsOfServicePath = 'assets/terms_of_use.txt';
  static const privacyPolicyPath = 'assets/privacy_policy.txt';

  Future<void> preloadFiles() async {
    _termsOfService = await _loadFile(termsOfServicePath);
    _privacyPolicy = await _loadFile(privacyPolicyPath);
  }

  Future<String> _loadFile(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      Log.error(e.toString());
      return "Failed to load content.";
    } finally {
      Log.info('Asset: $path loaded successfully.');
    }
  }

  String getTermsOfService() => _termsOfService;
  String getPrivacyPolicy() => _privacyPolicy;
}
