/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("SettingsValue", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const settingsValue1 = SettingsValue(
          isHapticsEnable: true,
          isVoiceAssistantEnable: true,
        );

        const settingsValue2 = SettingsValue(
          isHapticsEnable: false,
          isVoiceAssistantEnable: false,
        );

        expect(settingsValue1.isHapticsEnable, isTrue);
        expect(settingsValue1.isVoiceAssistantEnable, isTrue);
        expect(settingsValue2.isHapticsEnable, isFalse);
        expect(settingsValue2.isVoiceAssistantEnable, isFalse);
      });
    });
  });
}
