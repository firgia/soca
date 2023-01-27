/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Functions", () {
    group("getImage", () {
      test("Should return Saudi Arabia flag image when DeviceLanguage.arabic",
          () {
        expect(
          DeviceLanguage.arabic.getImage(),
          const AssetImage(ImageRaster.flagSaudiArabia),
        );
      });

      test("Should return United States flag image when DeviceLanguage.english",
          () {
        expect(
          DeviceLanguage.english.getImage(),
          const AssetImage(ImageRaster.flagUnitedStates),
        );
      });

      test("Should return Spain flag image when DeviceLanguage.spanish", () {
        expect(
          DeviceLanguage.spanish.getImage(),
          const AssetImage(ImageRaster.flagSpain),
        );
      });

      test("Should return Indian flag image when DeviceLanguage.hindi", () {
        expect(
          DeviceLanguage.hindi.getImage(),
          const AssetImage(ImageRaster.flagIndia),
        );
      });

      test("Should return Indonesian flag image when DeviceLanguage.indonesian",
          () {
        expect(
          DeviceLanguage.indonesian.getImage(),
          const AssetImage(ImageRaster.flagIndonesia),
        );
      });

      test("Should return Russian flag image when DeviceLanguage.russian", () {
        expect(
          DeviceLanguage.russian.getImage(),
          const AssetImage(ImageRaster.flagRussia),
        );
      });

      test("Should return Chinese flag image when DeviceLanguage.chinese", () {
        expect(
          DeviceLanguage.chinese.getImage(),
          const AssetImage(ImageRaster.flagChina),
        );
      });
    });

    group("getName", () {
      test("Should return 'Arabic' text when DeviceLanguage.arabic", () {
        expect(
          DeviceLanguage.arabic.getName(),
          "Arabic",
        );
      });

      test("Should return 'English' text when DeviceLanguage.english", () {
        expect(
          DeviceLanguage.english.getName(),
          "English",
        );
      });

      test("Should return 'Spanish' text when DeviceLanguage.spanish", () {
        expect(
          DeviceLanguage.spanish.getName(),
          "Spanish",
        );
      });

      test("Should return 'Hindi' text when DeviceLanguage.hindi", () {
        expect(
          DeviceLanguage.hindi.getName(),
          "Hindi",
        );
      });

      test("Should return 'Russian' text when DeviceLanguage.russian", () {
        expect(
          DeviceLanguage.russian.getName(),
          "Russian",
        );
      });

      test(
          "Should return 'Chinese, Simplified' text when DeviceLanguage.chinese",
          () {
        expect(
          DeviceLanguage.chinese.getName(),
          "Chinese, Simplified",
        );
      });
    });

    group("getNativeName", () {
      test("Should return 'عربي' text when DeviceLanguage.arabic", () {
        expect(
          DeviceLanguage.arabic.getNativeName(),
          "عربي",
        );
      });

      test("Should return 'English' text when DeviceLanguage.english", () {
        expect(
          DeviceLanguage.english.getNativeName(),
          "English",
        );
      });

      test("Should return 'Español' text when DeviceLanguage.spanish", () {
        expect(
          DeviceLanguage.spanish.getNativeName(),
          "Español",
        );
      });

      test("Should return 'हिन्दी' text when DeviceLanguage.hindi", () {
        expect(
          DeviceLanguage.hindi.getNativeName(),
          "हिन्दी",
        );
      });

      test("Should return 'Русский' text when DeviceLanguage.russian", () {
        expect(
          DeviceLanguage.russian.getNativeName(),
          "Русский",
        );
      });

      test("Should return '简体中文' text when DeviceLanguage.chinese", () {
        expect(
          DeviceLanguage.chinese.getNativeName(),
          "简体中文",
        );
      });
    });

    group("toLocale", () {
      test("Should return Locale(ar) when DeviceLanguage.arabic", () {
        expect(
          DeviceLanguage.arabic.toLocale(),
          const Locale("ar"),
        );
      });

      test("Should return Locale(en) when DeviceLanguage.english", () {
        expect(
          DeviceLanguage.english.toLocale(),
          const Locale("en"),
        );
      });

      test("Should return Locale(es) when DeviceLanguage.spanish", () {
        expect(
          DeviceLanguage.spanish.toLocale(),
          const Locale("es"),
        );
      });

      test("Should return Locale(hi) when DeviceLanguage.hindi", () {
        expect(
          DeviceLanguage.hindi.toLocale(),
          const Locale("hi"),
        );
      });

      test("Should return Locale(id) when DeviceLanguage.indonesian", () {
        expect(
          DeviceLanguage.indonesian.toLocale(),
          const Locale("id"),
        );
      });

      test("Should return Locale(ru) when DeviceLanguage.russian", () {
        expect(
          DeviceLanguage.russian.toLocale(),
          const Locale("ru"),
        );
      });

      test("Should return Locale(zh) when DeviceLanguage.chinese", () {
        expect(
          DeviceLanguage.chinese.toLocale(),
          const Locale("zh"),
        );
      });
    });
  });
}
