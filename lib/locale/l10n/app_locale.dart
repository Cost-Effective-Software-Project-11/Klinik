import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLocale {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  static Locale get defaultSystemLocale => PlatformDispatcher.instance.locale;
}
