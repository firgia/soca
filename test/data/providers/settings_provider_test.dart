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
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.dart';

void main() {
  late SettingsProvider settingsProvider;
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    registerLocator();

    sharedPreferences = getMockSharedPreferences();
    settingsProvider = SettingsProviderImpl();
  });

  tearDown(() => unregisterLocator());

  group(".getEnableHaptics()", () {
    test(
        "Should load from local storage by calling sharedPreferences.getBool()",
        () async {
      when(sharedPreferences.getBool(LocalStoragePath.enableHaptics))
          .thenReturn(true);

      bool? enable = settingsProvider.getEnableHaptics();

      expect(enable, isTrue);
      verify(sharedPreferences.getBool(LocalStoragePath.enableHaptics));
    });
  });

  group(".getEnableVoiceAssistant()", () {
    test(
        "Should load from local storage by calling sharedPreferences.getBool()",
        () async {
      when(sharedPreferences.getBool(LocalStoragePath.enableVoiceAssistant))
          .thenReturn(true);

      bool? enable = settingsProvider.getEnableVoiceAssistant();

      expect(enable, isTrue);
      verify(sharedPreferences.getBool(LocalStoragePath.enableVoiceAssistant));
    });
  });

  group(".getIsFirstTimeUsed()", () {
    test(
        "Should load from local storage by calling sharedPreferences.getBool()",
        () async {
      when(sharedPreferences.getBool(LocalStoragePath.isFirstTimeUsed))
          .thenReturn(true);

      bool? enable = settingsProvider.getIsFirstTimeUsed();

      expect(enable, isTrue);
      verify(sharedPreferences.getBool(LocalStoragePath.isFirstTimeUsed));
    });
  });

  group(".setEnableHaptics()", () {
    test("Should save to local storage by calling sharedPreferences.setBool()",
        () async {
      when(sharedPreferences.setBool(LocalStoragePath.enableHaptics, true))
          .thenAnswer((_) => Future.value(true));

      bool? status = await settingsProvider.setEnableHaptics(true);

      expect(status, isTrue);
      verify(sharedPreferences.setBool(LocalStoragePath.enableHaptics, true));
    });
  });

  group(".setEnableVoiceAssistant()", () {
    test("Should save to local storage by calling sharedPreferences.setBool()",
        () async {
      when(sharedPreferences.setBool(
              LocalStoragePath.enableVoiceAssistant, true))
          .thenAnswer((_) => Future.value(true));

      bool? status = await settingsProvider.setEnableVoiceAssistant(true);

      expect(status, isTrue);
      verify(sharedPreferences.setBool(
          LocalStoragePath.enableVoiceAssistant, true));
    });
  });

  group(".setIsFirstTimeUsed()", () {
    test("Should save to local storage by calling sharedPreferences.setBool()",
        () async {
      when(sharedPreferences.setBool(LocalStoragePath.isFirstTimeUsed, true))
          .thenAnswer((_) => Future.value(true));

      bool? status = await settingsProvider.setIsFirstTimeUsed(true);

      expect(status, isTrue);
      verify(sharedPreferences.setBool(LocalStoragePath.isFirstTimeUsed, true));
    });
  });
}
