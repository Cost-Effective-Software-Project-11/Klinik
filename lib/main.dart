import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home/home_screen.dart';
import 'package:flutter_gp5/screens/auth/login-screen.dart';
import 'package:flutter_gp5/screens/auth/signup-screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/authentication/authentication.dart';
import 'package:flutter_gp5/authentication/bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationRepository>(
      create: (context) => AuthenticationRepository(),
      child: RepositoryProvider<UserRepository>(
        create: (context) => UserRepository(),
        child: BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
          child: MaterialApp(
            title: 'GP5',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                // Decide initial route based on authentication state
                String initialRoute = state.status == AuthenticationStatus.authenticated ? '/' : '/login';
                return Navigator(
                  initialRoute: initialRoute,
                  onGenerateRoute: (RouteSettings settings) {
                    switch (settings.name) {
                      case '/':
                        return MaterialPageRoute(builder: (_) => const HomeScreen());
                      case '/login':
                        return MaterialPageRoute(builder: (_) => const LoginScreen());
                      case '/signup':
                        return MaterialPageRoute(builder: (_) => const SignupScreen());
                      default:
                        return MaterialPageRoute(builder: (_) => const LoginScreen());
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Signup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}