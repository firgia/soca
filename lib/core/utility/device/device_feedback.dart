/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/core.dart';

/// [DeviceFeedback] is useful for a blind user to recognize process when
/// interact with an App
abstract class DeviceFeedback {
  void vibrate();

  /// Playing voice assistant based on [message]
  void playVoiceAssistant(String message, BuildContext context);

  /// Set enable feedback
  ///
  /// The default of [enableHaptick] and [enableVoiceAssistant] is true
  void enableFeedback({
    bool? enableHaptick,
    bool? enableVoiceAssistant,
  });
}

class DeviceFeedbackImpl implements DeviceFeedback {
  bool _enableHaptick = true;
  bool _enableVoiceAssistant = true;
  final FlutterTts _flutterTts = FlutterTts();
  DeviceLanguage? _tempLanguage;

  @override
  void vibrate() {
    if (_enableHaptick) {
      HapticFeedback.vibrate();
    }
  }

  @override
  void playVoiceAssistant(String message, BuildContext context) async {
    if (_enableVoiceAssistant) {
      DeviceLanguage? language = context.locale.toDeviceLanguage();
      await _flutterTts.stop();

      /// When language is changed we need to configure tts again before used it
      if (language != _tempLanguage) {
        String? lang;
        double volume = 1;
        double rate = (language == DeviceLanguage.spanish) ? 0.35 : 0.4;
        double pitch = 1;

        dynamic ttsSupportedLanguage = await _flutterTts.getLanguages;
        List<String>? supportedLanguage =
            Parser.getListString(ttsSupportedLanguage);

        if (supportedLanguage?.isNotEmpty ?? false) {
          bool isAvailable(String language) =>
              supportedLanguage?.contains(language) ?? false;

          // Default english language
          if (isAvailable("en-US")) {
            lang = "en-US";
          } else if (isAvailable("en-GB")) {
            lang = "es-GB";
          } else if (isAvailable("en-AU")) {
            lang = "es-AU";
          }

          switch (language) {
            case DeviceLanguage.arabic:
              if (isAvailable("ar-001")) lang = "ar-001";
              break;
            case DeviceLanguage.chinese:
              if (isAvailable("zh-CN")) {
                lang = "zh-CN";
              } else if (isAvailable("zh-HK")) {
                lang = "zh-HK";
              }
              break;
            case DeviceLanguage.hindi:
              if (isAvailable("hi-IN")) lang = "hi-IN";
              break;
            case DeviceLanguage.indonesian:
              if (isAvailable("id-ID")) lang = "id-ID";
              break;
            case DeviceLanguage.russian:
              if (isAvailable("ru-RU")) lang = "ru-RU";
              break;
            case DeviceLanguage.spanish:
              if (isAvailable("es-ES")) {
                lang = "es-ES";
              } else if (isAvailable("es-MX")) {
                lang = "es-MX";
              }
              break;
            default:
          }
        }

        if (lang != null) {
          await _flutterTts.setLanguage(lang);
        }

        await Future.wait([
          _flutterTts.setVolume(volume),
          _flutterTts.setSpeechRate(rate),
          _flutterTts.setPitch(pitch),
        ]);

        _tempLanguage = language;
      }

      await _flutterTts.speak(message);
    }
  }

  @override
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
