/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

/// [DeviceFeedback] is useful for a blind user to recognize process when
/// interact with an App
abstract class DeviceFeedback {
  Future<void> vibrate();

  bool get isHapticsEnable;
  bool get isVoiceAssistantEnable;

  /// Playing voice assistant based on [messages]
  void playVoiceAssistant(
    List<String> messages,
    BuildContext context, {
    bool immediately = false,
  });

  void playCallVibration();
  void stopCallVibration();
}

class DeviceFeedbackImpl implements DeviceFeedback {
  final SettingsRepository _settingsRepository = sl<SettingsRepository>();
  final FlutterTts _flutterTts = FlutterTts();

  DeviceLanguage? _tempLanguage;
  Timer? timerCallVibration;

  @override
  Future<void> vibrate() async {
    if (isHapticsEnable) {
      await HapticFeedback.vibrate();
    }
  }

  @override
  void playVoiceAssistant(
    List<String> messages,
    BuildContext context, {
    bool immediately = false,
  }) async {
    if (isVoiceAssistantEnable && messages.isNotEmpty) {
      DeviceLanguage? language = context.locale.toDeviceLanguage();

      if (immediately) {
        await _flutterTts.stop();
      }

      /// When language is changed we need to configure tts again before used it
      if (language != _tempLanguage) {
        String? lang;

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

        _tempLanguage = language;
      }

      double volume = 1;
      double rate = (language == DeviceLanguage.spanish) ? 0.35 : 0.4;
      double pitch = 1;

      await Future.wait([
        _flutterTts.setVolume(volume),
        _flutterTts.setSpeechRate(rate),
        _flutterTts.setPitch(pitch),
      ]);

      String newLang = "";
      for (String message in messages) {
        newLang += "$message,";
      }

      await _flutterTts.speak(newLang);
      await _flutterTts.awaitSpeakCompletion(true);
    }
  }

  @override
  bool get isHapticsEnable => _settingsRepository.isHapticsEnable;

  @override
  bool get isVoiceAssistantEnable => _settingsRepository.isVoiceAssistantEnable;

  @override
  void playCallVibration() async {
    Vibration.vibrate(
      pattern: [500, 1000, 500, 2000],
      intensities: [1, 255],
    );
    Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (timer.isActive) {
        timerCallVibration = timer;
        Vibration.vibrate(
          pattern: [500, 1000, 500, 2000],
          intensities: [1, 255],
        );
      }
    });
  }

  @override
  void stopCallVibration() {
    timerCallVibration?.cancel();
    Vibration.cancel();
  }
}
