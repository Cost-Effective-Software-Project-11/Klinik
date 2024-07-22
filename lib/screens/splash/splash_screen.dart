import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/screens/auth/bloc/authentication_bloc.dart';
import 'package:flutter_gp5/routes/app_routes.dart';

import '../../enums/authentication_status_enum.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
            // Navigate to home screen if authenticated
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              break;
            case AuthenticationStatus.unauthenticated:
            // Navigate to login screen if unauthenticated
              Navigator.of(context).pushReplacementNamed(AppRoutes.start);
              break;
            default:
            // Optional: Handle unknown state, perhaps stay on the splash screen
            // or navigate to an error page
              break;
          }
        });
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}