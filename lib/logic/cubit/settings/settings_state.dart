/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsValue extends SettingsState {
  final bool isHapticsEnable;
  final bool isVoiceAssistantEnable;

  const SettingsValue({
    required this.isHapticsEnable,
    required this.isVoiceAssistantEnable,
  });

  @override
  List<Object> get props => [
        isHapticsEnable,
        isVoiceAssistantEnable,
      ];
}
