import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:flutter_gp5/screens/auth/signup/signup_screen.dart';

import '../main.dart';
import '../screens/create_trials/create_trials_screen.dart';
import '../screens/patient_trials/patient_trials_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String trials = '/trials';
  static const String appSettings = '/settings';
  static const String createTrials = '/create_trials';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case trials:
        return MaterialPageRoute(builder: (_) => const PatientTrialsScreen());
      case appSettings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case createTrials:
        return MaterialPageRoute(builder: (_) => const CreateTrialsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}