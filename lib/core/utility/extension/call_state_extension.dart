/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import '../../enum/enum.dart';

extension CallStateExtension on CallState {
  static CallState? getFromName(String name) {
    switch (name) {
      case "waiting":
        return CallState.waiting;
      case "ongoing":
        return CallState.ongoing;
      case "ended_with_canceled":
        return CallState.endedWithCanceled;
      case "ended_with_unanswered":
        return CallState.endedWithUnanswered;
      case "ended":
        return CallState.ended;
      case "ended_with_declined":
        return CallState.endedWithDeclined;
      default:
        return null;
    }
  }
}
