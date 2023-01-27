/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("LanguageSelected", () {
    group("Fields", () {
      group("language", () {
        test("Should return language value based on constructor", () {
          const lang1 = LanguageSelected(DeviceLanguage.english);
          const lang2 = LanguageSelected(DeviceLanguage.indonesian);

          expect(lang1.language, DeviceLanguage.english);
          expect(lang2.language, DeviceLanguage.indonesian);
        });
      });
    });
  });
}
