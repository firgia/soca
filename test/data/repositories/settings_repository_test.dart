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
        'is unavailable', () async {
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
        'is unavailable', () async {
      when(settingsProvider.getEnableVoiceAssistant()).thenReturn(null);

      bool? isVoiceAssistantEnable = settingsRepository.isVoiceAssistantEnable;

      verify(settingsProvider.getEnableVoiceAssistant());
      expect(isVoiceAssistantEnable, isTrue);
    });
  });

  group(".hasPickLanguage", () {
    test(
        "Should load from settingsProvider.getHasPickLanguage() when available",
        () async {
      when(settingsProvider.getHasPickLanguage()).thenReturn(false);

      bool? hasPickLanguage = settingsRepository.hasPickLanguage;

      verify(settingsProvider.getHasPickLanguage());
      expect(hasPickLanguage, isFalse);
    });

    test(
        'Should return false when data from settingsProvider.getHasPickLanguage() '
        'is unavailable', () async {
      when(settingsProvider.getHasPickLanguage()).thenReturn(null);

      bool? hasPickLanguage = settingsRepository.hasPickLanguage;

      verify(settingsProvider.getHasPickLanguage());
      expect(hasPickLanguage, isFalse);
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

  group(".setHasPickLanguage()", () {
    test("Should update by calling settingsProvider.setHasPickLanguage()",
        () async {
      when(settingsProvider.setHasPickLanguage(true))
          .thenAnswer((_) => Future.value(true));

      await settingsRepository.setHasPickLanguage(true);

      verify(settingsProvider.setHasPickLanguage(true));
    });
  });
}
