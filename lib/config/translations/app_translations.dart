/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/core.dart';

abstract class AppTranslations {
  static const _ar = Locale('ar');
  static const _en = Locale('en');
  static const _es = Locale('es');
  static const _id = Locale('id');
  static const _hi = Locale('hi');
  static const _ru = Locale('ru');
  static const _zh = Locale('zh');

  /// Default locale when the unsupported locale is selected
  static Locale get fallbackLocale => _en;

  /// Location of i18n json file
  static String get path => "assets/json/i18n";

  /// List of supported locales for this app
  static List<Locale> get supportedLocales => const [
        _ar,
        _en,
        _es,
        _id,
        _hi,
        _ru,
        _zh,
      ];

  /// Change the current locale
  ///
  /// Return new locale
  static Locale change(DeviceLanguage language, BuildContext context) {
    late Locale newLocale;

    switch (language) {
      case DeviceLanguage.arabic:
        newLocale = _ar;
        break;

      case DeviceLanguage.chinese:
        newLocale = _zh;
        break;

      case DeviceLanguage.hindi:
        newLocale = _hi;
        break;

      case DeviceLanguage.indonesian:
        newLocale = _id;
        break;

      case DeviceLanguage.russian:
        newLocale = _ru;
        break;

      case DeviceLanguage.spanish:
        newLocale = _es;
        break;

      default:
        newLocale = _en;
        break;
    }

    context.setLocale(newLocale);
    return newLocale;
  }

  /// Return current device language
  static DeviceLanguage? getCurrentDeviceLanguage(BuildContext context) {
    final code = context.locale.languageCode;

    switch (code) {
      case "ar":
        return DeviceLanguage.arabic;

      case "en":
        return DeviceLanguage.english;

      case "es":
        return DeviceLanguage.spanish;

      case "hi":
        return DeviceLanguage.hindi;

      case "id":
        return DeviceLanguage.indonesian;

      case "ru":
        return DeviceLanguage.russian;

      case "zh":
        return DeviceLanguage.chinese;

      default:
        return null;
    }
  }
}
