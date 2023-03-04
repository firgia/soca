/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/services.dart';

/// [DeviceFeedback] is useful for a blind user to recognize process when
/// interact with an App
class DeviceFeedback {
  bool _enableHaptick = true;
  bool _enableVoiceAssistant = true;

  void vibrate() {
    if (_enableHaptick) {
      HapticFeedback.vibrate();
    }
  }

  /// Playing voice assistant based on [message]
  void playVoiceAssistant(String message) {
    if (_enableVoiceAssistant) {
      // TODO: Implement this
    }
  }

  /// Set enable feedback
  ///
  /// The default of [enableHaptick] and [enableVoiceAssistant] is true
  void enableFeedback({
    bool? enableHaptick,
    bool? enableVoiceAssistant,
  }) {
    if (enableHaptick != null) {
      _enableHaptick = enableHaptick;
    }

    if (enableVoiceAssistant != null) {
      _enableVoiceAssistant = enableVoiceAssistant;
    }
  }
}
