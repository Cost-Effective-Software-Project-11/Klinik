import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';

import '../screens/auth/signup/doctor-signup_screen.dart';
import '../screens/auth/signup/patient-signup_screen.dart';
import '../screens/home/home_screen2.dart';
import '../screens/starting_screen/starting_screen.dart';
import '../screens/create_trials/create_trials_screen.dart';
import '../screens/patient_trials/patient_trials_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String start = '/starting';
  static const String login = '/login';
  static const String trials = '/trials';
  static const String appSettings = '/settings';
  static const String createTrials = '/create_trials';
  static const String signupDoctor = '/signup_doctor';
  static const String signupPatient = '/signup_patient';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen2());
      case start:
        return MaterialPageRoute(builder: (_) => const StartingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case trials:
        return MaterialPageRoute(builder: (_) => const PatientTrialsScreen());
      case appSettings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case createTrials:
        return MaterialPageRoute(builder: (_) => const CreateTrialsScreen());
      case signupDoctor:
        return MaterialPageRoute(builder: (_) => const DoctorSignUpScreen());
       case signupPatient:
         return MaterialPageRoute(builder: (_) => const PatientSignUpScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}