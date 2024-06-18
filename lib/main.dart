import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/screens/auth/bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:flutter_gp5/screens/auth/register/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => createAuthenticationBloc(context),
        child: MaterialApp(
          title: 'GP5',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
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
          },
        ),
      ),
    );
  }
}

AuthenticationBloc createAuthenticationBloc(BuildContext context) {
  return AuthenticationBloc(
    authenticationRepository: context.read<AuthenticationRepository>(),
    userRepository: context.read<UserRepository>(),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _checkAuthentication(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/home');
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Future<bool> _checkAuthentication(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    var isLoggedIn = context.read<AuthenticationRepository>().isLoggedIn();
    return isLoggedIn;
  }
}