/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'app_locale.dart';

abstract class AppTranslations {
  /// Default locale when the unsupported locale is selected
  static Locale get fallbackLocale => AppLocale.en;

  /// Location of i18n json file
  static String get path => "assets/json/i18n";

  /// List of supported locales for this app
  static List<Locale> get supportedLocales => const [
        AppLocale.ar,
        AppLocale.en,
        AppLocale.es,
        AppLocale.id,
        AppLocale.hi,
        AppLocale.ru,
        AppLocale.zh,
      ];
}
