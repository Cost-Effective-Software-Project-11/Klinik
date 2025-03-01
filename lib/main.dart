import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gp5/enums/authentication.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/auth/register/register_screen.dart';
import 'package:flutter_gp5/services/text_file_loader_service.dart';
import 'config/firebase_options.dart';
import 'config/service_locator.dart';
import 'locale/l10n/app_locale.dart';
import 'repos/authentication/authentication_repository.dart';
import 'screens/auth/bloc/authentication_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDependencyInjection();
  await TextFileLoaderService().preloadFiles();

  runApp(const KlinikApp());
}

class KlinikApp extends StatefulWidget {
  const KlinikApp({super.key});

  @override
  State<KlinikApp> createState() => _KlinikAppState();

  static Locale? locale = AppLocale.defaultSystemLocale;

  static void setLocale(BuildContext context, Locale newLocale) {
    _KlinikAppState? state = context.findAncestorStateOfType<_KlinikAppState>();
    state?.setLocale(newLocale);
  }
}

class _KlinikAppState extends State<KlinikApp> {
  void setLocale(Locale locale) {
    setState(() {
      KlinikApp.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authenticationRepository: getIt<AuthenticationRepository>(),
      ),
      child: klinik(),
    );
  }
}

MaterialApp klinik() {
  return MaterialApp(
    title: 'klinik',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
      ),
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: KlinikApp.locale,
    home: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == Authentication.authenticated) {
          context.showSuccessSnackBar('authenticated');
        }
        if (state.status == Authentication.unauthenticated) {
          context.showFailureSnackBar('unauthenticated');
        }
      },
      child: const RegisterScreen(),
    ),
  );
}