/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import '../../enum/enum.dart';

extension LocaleExtension on Locale {
  DeviceLanguage? toDeviceLanguage() {
    Locale locale = this;
    final code = locale.languageCode;

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
