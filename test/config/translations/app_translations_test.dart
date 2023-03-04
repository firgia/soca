/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';

void main() async {
  group(".fallbackLocale", () {
    test("Should return Locale(en)", () {
      expect(AppTranslations.fallbackLocale, const Locale("en"));
    });
  });

  group(".path", () {
    test("Should return the correct i18n location files", () {
      expect(AppTranslations.path, "assets/json/i18n");
    });
  });

  group(".supportedLocales", () {
    test("Should return ar, en, es, id, hi, ru, zh Locales", () {
      expect(
        AppTranslations.supportedLocales,
        const [
          Locale('ar'),
          Locale('en'),
          Locale('es'),
          Locale('id'),
          Locale('hi'),
          Locale('ru'),
          Locale('zh'),
        ],
      );
    });
  });
}
