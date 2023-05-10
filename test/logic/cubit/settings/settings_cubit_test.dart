/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockSettingsRepository settingsRepository;

  setUp(() {
    registerLocator();
    settingsRepository = getMockSettingsRepository();
  });

  tearDown(() => unregisterLocator());

  group(".()", () {
    blocTest<SettingsCubit, SettingsState>(
      'Should emits [SettingsValue] when initialize',
      build: () => SettingsCubit(),
      setUp: () {
        when(settingsRepository.isHapticsEnable).thenReturn(true);
        when(settingsRepository.isVoiceAssistantEnable).thenReturn(false);
      },
      verify: (bloc) {
        verifyInOrder([
          settingsRepository.isHapticsEnable,
          settingsRepository.isVoiceAssistantEnable,
        ]);

        expect(
          bloc.state,
          const SettingsValue(
            isHapticsEnable: true,
            isVoiceAssistantEnable: false,
          ),
        );
      },
    );
  });

  group(".setEnableHaptics()", () {
    blocTest<SettingsCubit, SettingsState>(
      'Should emits [SettingsLoading, SettingsValue]',
      build: () => SettingsCubit(),
      act: (settings) => settings.setEnableHaptics(true),
      setUp: () {
        when(settingsRepository.isHapticsEnable).thenReturn(true);
        when(settingsRepository.isVoiceAssistantEnable).thenReturn(false);
      },
      expect: () => const <SettingsState>[
        SettingsLoading(),
        SettingsValue(
          isHapticsEnable: true,
          isVoiceAssistantEnable: false,
        ),
      ],
      verify: (bloc) {
        verifyInOrder([
          settingsRepository.setEnableHaptics(true),
          settingsRepository.isHapticsEnable,
          settingsRepository.isVoiceAssistantEnable,
        ]);
      },
    );
  });

  group(".setEnableVoiceAssistant()", () {
    blocTest<SettingsCubit, SettingsState>(
      'Should emits [SettingsLoading, SettingsValue]',
      build: () => SettingsCubit(),
      act: (settings) => settings.setEnableVoiceAssistant(true),
      setUp: () {
        when(settingsRepository.isHapticsEnable).thenReturn(true);
        when(settingsRepository.isVoiceAssistantEnable).thenReturn(false);
      },
      expect: () => const <SettingsState>[
        SettingsLoading(),
        SettingsValue(
          isHapticsEnable: true,
          isVoiceAssistantEnable: false,
        ),
      ],
      verify: (bloc) {
        verifyInOrder([
          settingsRepository.setEnableVoiceAssistant(true),
          settingsRepository.isHapticsEnable,
          settingsRepository.isVoiceAssistantEnable,
        ]);
      },
    );
  });
}
