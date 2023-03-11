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
  String get capitalizeFirst {
    String val = this;

    if (val.trim().isEmpty) {
      return val;
    } else {
      return "${val[0].toUpperCase()}${val.substring(1).toLowerCase()}";
    }
  }

  String get capitalize {
    String val = this;

    if (val.trim().isEmpty) {
      return val;
    } else {
      String result = "";
      List<String> list = val.split(" ");
      for (String value in list) {
        result +=
            "${value[0].toUpperCase()}${value.substring(1).toLowerCase()} ";
      }
      return result.trim();
    }
  }

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
