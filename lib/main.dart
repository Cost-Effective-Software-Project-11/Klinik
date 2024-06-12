import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login-screen.dart';
import 'package:flutter_gp5/screens/auth/signup-screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gp5/screens/settings/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('bg'); // Default language

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    return MaterialApp(
      title: 'GP5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/settings') {
          return MaterialPageRoute(
            builder: (context) => SettingsScreen(
              onLocaleChange: _setLocale,
            ),
          );
        }
        return null;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
    );
  }
}
