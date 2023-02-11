/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import '../../core.dart';

extension StringExtension on String {
  Gender? toGender() {
    String value = this;

    final result =
        Gender.values.where((e) => e.name.toLowerCase() == value.toLowerCase());

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  UserType? toUserType() {
    String value = this;

    final result = UserType.values
        .where((e) => e.name.toLowerCase() == value.toLowerCase());

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
