/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../enum/enum.dart';
import '../../path/path.dart';

extension DeviceLanguageExtension on DeviceLanguage {
  String getNativeName() {
    final language = this;
    switch (language) {
      case DeviceLanguage.arabic:
        return "عربي";

      case DeviceLanguage.chinese:
        return "简体中文";

      case DeviceLanguage.hindi:
        return "हिन्दी";

      case DeviceLanguage.indonesian:
        return "Bahasa Indonesia";

      case DeviceLanguage.russian:
        return "Русский";

      case DeviceLanguage.spanish:
        return "Español";

      default:
        return "English";
    }
  }

  String getName() {
    final language = this;

    switch (language) {
      case DeviceLanguage.arabic:
        return "Arabic";

      case DeviceLanguage.chinese:
        return "Chinese, Simplified";

      case DeviceLanguage.hindi:
        return "Hindi";

      case DeviceLanguage.indonesian:
        return "Indonesian";

      case DeviceLanguage.russian:
        return "Russian";

      case DeviceLanguage.spanish:
        return "Spanish";
      default:
        return "English";
    }
  }

  ImageProvider getImage() {
    final language = this;

    switch (language) {
      case DeviceLanguage.arabic:
        return const AssetImage(ImageRaster.flagSaudiArabia);
      case DeviceLanguage.chinese:
        return const AssetImage(ImageRaster.flagChina);
      case DeviceLanguage.hindi:
        return const AssetImage(ImageRaster.flagIndia);
      case DeviceLanguage.indonesian:
        return const AssetImage(ImageRaster.flagIndonesia);
      case DeviceLanguage.russian:
        return const AssetImage(ImageRaster.flagRussia);
      case DeviceLanguage.spanish:
        return const AssetImage(ImageRaster.flagSpain);
      default:
        return const AssetImage(ImageRaster.flagUnitedStates);
    }
  }
}
