import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/screens/settings/language_dropdown_button.dart';
import 'package:flutter_gp5/widgets/custom_circular_progress_indicator.dart';
import '../home/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocale.of(context)!;

    var height = context.setHeight(10);
    var width = context.setWidth(10);

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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height, width: width),
              const LanguageDropdownButton(),
            ],
          ),
          const Divider(),
          const CustomCircularProgressIndicator(),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreenWrapper()),
              );
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }
}
