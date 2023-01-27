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

  // /// Change the current locale
  // ///
  // /// Return new locale
  // static Locale change(DeviceLanguage language, BuildContext context) {
  //   late Locale newLocale;

  //   switch (language) {
  //     case DeviceLanguage.arabic:
  //       newLocale = AppLocale.ar;
  //       break;

  //     case DeviceLanguage.chinese:
  //       newLocale = AppLocale.zh;
  //       break;

  //     case DeviceLanguage.hindi:
  //       newLocale = AppLocale.hi;
  //       break;

  //     case DeviceLanguage.indonesian:
  //       newLocale = AppLocale.id;
  //       break;

  //     case DeviceLanguage.russian:
  //       newLocale = AppLocale.ru;
  //       break;

  //     case DeviceLanguage.spanish:
  //       newLocale = AppLocale.es;
  //       break;

  //     default:
  //       newLocale = AppLocale.en;
  //       break;
  //   }

  //   context.setLocale(newLocale);
  //   return newLocale;
  // }

  // /// Return current device language
  // static DeviceLanguage? getCurrentDeviceLanguage(BuildContext context) {
  //   final code = context.locale.languageCode;

  //   switch (code) {
  //     case "ar":
  //       return DeviceLanguage.arabic;

  //     case "en":
  //       return DeviceLanguage.english;

  //     case "es":
  //       return DeviceLanguage.spanish;

  //     case "hi":
  //       return DeviceLanguage.hindi;

  //     case "id":
  //       return DeviceLanguage.indonesian;

  //     case "ru":
  //       return DeviceLanguage.russian;

  //     case "zh":
  //       return DeviceLanguage.chinese;

  //     default:
  //       return null;
  //   }
  // }
}
