import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:flutter_gp5/screens/auth/signup/signup_screen.dart';

import '../main.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}