/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Functions", () {
    group("toDeviceLanguage", () {
      test("Should return DeviceLanguage.arabic when Locale(ar)", () {
        expect(
          const Locale("ar").toDeviceLanguage(),
          DeviceLanguage.arabic,
        );
      });

      test("Should return DeviceLanguage.english when Locale(en)", () {
        expect(
          const Locale("en").toDeviceLanguage(),
          DeviceLanguage.english,
        );
      });

      test("Should return DeviceLanguage.spanish when Locale(es)", () {
        expect(
          const Locale("es").toDeviceLanguage(),
          DeviceLanguage.spanish,
        );
      });

      test("Should return DeviceLanguage.hindi when Locale(hi)", () {
        expect(
          const Locale("hi").toDeviceLanguage(),
          DeviceLanguage.hindi,
        );
      });

      test("Should return DeviceLanguage.indonesian when Locale(id)", () {
        expect(
          const Locale("id").toDeviceLanguage(),
          DeviceLanguage.indonesian,
        );
      });

      test("Should return DeviceLanguage.russian when Locale(ru)", () {
        expect(
          const Locale("ru").toDeviceLanguage(),
          DeviceLanguage.russian,
        );
      });

      test("Should return DeviceLanguage.chinese when Locale(zh)", () {
        expect(
          const Locale("zh").toDeviceLanguage(),
          DeviceLanguage.chinese,
        );
      });
    });
  });
}
