/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';
import 'package:soca/data/data.dart';

import '../../injection.dart';

abstract class SettingsRepository {
  /// Return true if haptics settings is enable
  bool get isHapticsEnable;

  /// Return true if voice assistant settings is enable
  bool get isVoiceAssistantEnable;

  /// Return true if user has pick language app
  bool get hasPickLanguage;

  /// Set enable haptics
  /// * `true` is enable
  /// * `false` is disable
  Future<void> setEnableHaptics(bool enable);

  /// Set enable voice assistant
  /// * `true` is enable
  /// * `false` is disable
  Future<void> setEnableVoiceAssistant(bool enable);

  /// Set has pick language
  /// * `true` if has pick language
  /// * `false` if not pick language yet
  Future<void> setHasPickLanguage(bool hasPicked);
}

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsProvider _settingsProvider = sl<SettingsProvider>();

  final Logger _logger = Logger("Settings Repository");

  @override
  bool get isHapticsEnable {
    _logger.info("Getting haptics settings ...");
    return _settingsProvider.getEnableHaptics() ?? true;
  }

  @override
  bool get isVoiceAssistantEnable {
    _logger.info("Getting voice assistant settings ...");
    return _settingsProvider.getEnableVoiceAssistant() ?? true;
  }

  @override
  bool get hasPickLanguage {
    _logger.info("Getting has pick language ...");
    return _settingsProvider.getHasPickLanguage() ?? false;
  }

  @override
  Future<void> setEnableHaptics(bool enable) async {
    _logger.info("Set haptics settings...");
    await _settingsProvider.setEnableHaptics(enable);
  }

  @override
  Future<void> setEnableVoiceAssistant(bool enable) async {
    _logger.info("Set voice assistant settings...");
    await _settingsProvider.setEnableVoiceAssistant(enable);
  }

  @override
  Future<void> setHasPickLanguage(bool hasPicked) async {
    _logger.info("Set has pick language...");
    await _settingsProvider.setHasPickLanguage(hasPicked);
  }
}
