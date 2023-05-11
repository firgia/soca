/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../data/data.dart';
import '../../../injection.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository = sl<SettingsRepository>();
  final Logger _logger = Logger("Settings Cubit");

  SettingsCubit() : super(const SettingsInitial()) {
    _updateValue();
  }

  void setEnableHaptics(bool enable) async {
    _logger.info("Updating enable haptics ...");
    emit(const SettingsLoading());
    await _settingsRepository.setEnableHaptics(enable);

    _logger.info("Successfully to update enable haptics");
    _updateValue();
  }

  void setEnableVoiceAssistant(bool enable) async {
    _logger.info("Updating enable voice assistant ...");
    emit(const SettingsLoading());
    await _settingsRepository.setEnableVoiceAssistant(enable);

    _logger.info("Successfully to update enable voice assistant");
    _updateValue();
  }

  void setHasPickLanguage(bool picked) async {
    _logger.info("Updating has pick language ...");
    emit(const SettingsLoading());
    await _settingsRepository.setHasPickLanguage(picked);

    _logger.info("Successfully to update pick language");
    _updateValue();
  }

  void _updateValue() {
    emit(SettingsValue(
      isHapticsEnable: _settingsRepository.isHapticsEnable,
      isVoiceAssistantEnable: _settingsRepository.isVoiceAssistantEnable,
    ));
  }
}
