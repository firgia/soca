/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import '../../../config/config.dart';

bool _isNotEmpty(String? value) {
  return value?.trim().isNotEmpty ?? false;
}

mixin ValidateName {
  /// Name should be 4 - 25 characters
  String? validateName(String? value) {
    RegExp validCharacter = RegExp(r'^[a-z A-Z]+$');

    if (_isNotEmpty(value) &&
        (value!.trim().length < 4 ||
            value.trim().length > 25 ||
            !validCharacter.hasMatch(value))) {
      return LocaleKeys.tf_name_change_conditions
          .tr(namedArgs: {'min': "4", 'max': '25'});
    }
    return null;
  }
}
