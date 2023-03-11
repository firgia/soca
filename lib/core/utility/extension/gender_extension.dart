/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:soca/config/config.dart';

import '../../core.dart';

extension GenderExtension on Gender {
  String getName() {
    final val = this;

    switch (val) {
      case Gender.male:
        return LocaleKeys.male.tr();
      default:
        return LocaleKeys.female.tr();
    }
  }
}
