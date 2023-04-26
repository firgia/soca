/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import '../../core.dart';

extension CallRoleExtension on CallRole {
  static CallRole? getFromName(String name) {
    switch (name) {
      case "answerer":
        return CallRole.answerer;
      case "caller":
        return CallRole.caller;
      default:
        return null;
    }
  }
}
