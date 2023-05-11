/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.dart';

void main() {
  late MockSettingsProvider settingsProvider;
  late SettingsRepository settingsRepository;

  setUp(() {
    registerLocator();

    settingsProvider = getMockSettingsProvider();
    settingsRepository = SettingsRepositoryImpl();
  });

  tearDown(() => unregisterLocator());

  group(".isHapticsEnable", () {
    test("Should load from settingsProvider.getEnableHaptics() when available",
        () async {
      when(settingsProvider.getEnableHaptics()).thenReturn(false);

      bool? isHapticsEnable = settingsRepository.isHapticsEnable;

      verify(settingsProvider.getEnableHaptics());
      expect(isHapticsEnable, isFalse);
    });

    test(
        'Should return true when data from settingsProvider.getEnableHaptics() '
        'when unavailable', () async {
      when(settingsProvider.getEnableHaptics()).thenReturn(null);

      bool? isHapticsEnable = settingsRepository.isHapticsEnable;

      verify(settingsProvider.getEnableHaptics());
      expect(isHapticsEnable, isTrue);
    });
  });

  group(".isVoiceAssistantEnable", () {
    test(
        "Should load from settingsProvider.getEnableVoiceAssistant() when available",
        () async {
      when(settingsProvider.getEnableVoiceAssistant()).thenReturn(false);

      bool? isVoiceAssistantEnable = settingsRepository.isVoiceAssistantEnable;

      verify(settingsProvider.getEnableVoiceAssistant());
      expect(isVoiceAssistantEnable, isFalse);
    });

    test(
        'Should return true when data from settingsProvider.getEnableVoiceAssistant() '
        'when unavailable', () async {
      when(settingsProvider.getEnableVoiceAssistant()).thenReturn(null);

      bool? isVoiceAssistantEnable = settingsRepository.isVoiceAssistantEnable;

      verify(settingsProvider.getEnableVoiceAssistant());
      expect(isVoiceAssistantEnable, isTrue);
    });
  });

  group(".isFirstTimeUsed", () {
    test(
        "Should load from settingsProvider.getIsFirstTimeUsed() when available",
        () async {
      when(settingsProvider.getIsFirstTimeUsed()).thenReturn(false);

      bool? isFirstTimeUsed = settingsRepository.isFirstTimeUsed;

      verify(settingsProvider.getIsFirstTimeUsed());
      expect(isFirstTimeUsed, isFalse);
    });

    test(
        'Should return true when data from settingsProvider.getIsFirstTimeUsed() '
        'when unavailable', () async {
      when(settingsProvider.getIsFirstTimeUsed()).thenReturn(null);

      bool? isFirstTimeUsed = settingsRepository.isFirstTimeUsed;

      verify(settingsProvider.getIsFirstTimeUsed());
      expect(isFirstTimeUsed, isTrue);
    });
  });

  group(".setEnableHaptics()", () {
    test("Should update by calling settingsProvider.setEnableHaptics()",
        () async {
      when(settingsProvider.setEnableHaptics(true))
          .thenAnswer((_) => Future.value(true));

      await settingsRepository.setEnableHaptics(true);

      verify(settingsProvider.setEnableHaptics(true));
    });
  });

  group(".setEnableVoiceAssistant()", () {
    test("Should update by calling settingsProvider.setEnableVoiceAssistant()",
        () async {
      when(settingsProvider.setEnableVoiceAssistant(true))
          .thenAnswer((_) => Future.value(true));

      await settingsRepository.setEnableVoiceAssistant(true);

      verify(settingsProvider.setEnableVoiceAssistant(true));
    });
  });

  group(".setIsFirstTimeUsed()", () {
    test("Should update by calling settingsProvider.setIsFirstTimeUsed()",
        () async {
      when(settingsProvider.setIsFirstTimeUsed(true))
          .thenAnswer((_) => Future.value(true));

      await settingsRepository.setIsFirstTimeUsed(true);

      verify(settingsProvider.setIsFirstTimeUsed(true));
    });
  });
}
