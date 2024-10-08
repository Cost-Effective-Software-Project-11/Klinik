import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gp5/repos/chat/chat_room_repository.dart';
import 'package:flutter_gp5/screens/home/bloc/home_bloc.dart';
import 'package:flutter_gp5/screens/home/repository/home_repository.dart';
import 'package:flutter_gp5/services/storage_service.dart';

import 'firebase_options.dart';
import 'locale/l10n/app_locale.dart';
import 'repos/authentication/authentication_repository.dart';
import 'repos/user/user_repository.dart';
import 'routes/app_routes.dart';
import 'screens/auth/bloc/authentication_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Locale? locale = AppLocale.defaultSystemLocale;

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  void setLocale(Locale locale) {
    setState(() {
      MyApp.locale = locale;
    });
  }

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
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(),
        ),
        RepositoryProvider<StorageService>(
          create: (_) => StorageService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => createAuthenticationBloc(context),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(HomeRepository())..add(LoadInitialData()),
          ),
        ],
        child: MaterialApp(
          title: 'GP5',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: MyApp.locale,
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