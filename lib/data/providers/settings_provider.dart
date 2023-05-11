/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../injection.dart';

abstract class SettingsProvider {
  /// Get enable haptics from local storage
  bool? getEnableHaptics();

  /// Get enable voice assistant from local storage
  bool? getEnableVoiceAssistant();

  /// Get is first time used app from local storage
  bool? getIsFirstTimeUsed();

  /// Save enable haptics to local storage
  Future<bool> setEnableHaptics(bool value);

  /// Save enable voice assistant to local storage
  Future<bool> setEnableVoiceAssistant(bool value);

  /// Save is first time used app to local storage
  Future<bool> setIsFirstTimeUsed(bool value);
}

class SettingsProviderImpl implements SettingsProvider {
  SharedPreferences sharedPreferences = sl<SharedPreferences>();
  final Logger _logger = Logger("Settings Provider");

  String get enableHapticsKey => LocalStoragePath.enableHaptics;
  String get enableVoiceAssistantKey => LocalStoragePath.enableVoiceAssistant;
  String get isFirstTimeUsedKey => LocalStoragePath.isFirstTimeUsed;

  @override
  bool? getEnableHaptics() {
    _logger.info("Getting $enableHapticsKey data...");
    final locale = sharedPreferences.getBool(enableHapticsKey);

    _logger.fine("Successfully to getting $enableHapticsKey data");
    return locale;
  }

  @override
  bool? getEnableVoiceAssistant() {
    _logger.info("Getting $enableVoiceAssistantKey data...");
    final locale = sharedPreferences.getBool(enableVoiceAssistantKey);

    _logger.fine("Successfully to getting $enableVoiceAssistantKey data");
    return locale;
  }

  @override
  bool? getIsFirstTimeUsed() {
    _logger.info("Getting $isFirstTimeUsedKey data...");
    final locale = sharedPreferences.getBool(isFirstTimeUsedKey);

    _logger.fine("Successfully to getting $isFirstTimeUsedKey data");
    return locale;
  }

  @override
  Future<bool> setEnableHaptics(bool value) async {
    _logger.info("Saving $enableHapticsKey data..");
    bool result = await sharedPreferences.setBool(enableHapticsKey, value);

    _logger.fine("Successfully to save $enableHapticsKey data");
    return result;
  }

  @override
  Future<bool> setEnableVoiceAssistant(bool value) async {
    _logger.info("Saving $enableVoiceAssistantKey data..");
    bool result =
        await sharedPreferences.setBool(enableVoiceAssistantKey, value);

    _logger.fine("Successfully to save $enableVoiceAssistantKey data");
    return result;
  }

  @override
  Future<bool> setIsFirstTimeUsed(bool value) async {
    _logger.info("Saving $isFirstTimeUsedKey data..");
    bool result = await sharedPreferences.setBool(isFirstTimeUsedKey, value);

    _logger.fine("Successfully to save $isFirstTimeUsedKey data");
    return result;
  }
}
