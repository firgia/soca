/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';

late BuildContext _context;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}

void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  group("Fields", () {
    group("fallbackLocale", () {
      test("Should return english locale", () {
        expect(AppTranslations.fallbackLocale, const Locale("en"));
      });
    });

    group("path", () {
      test("Should return the correct i18n location files", () {
        expect(AppTranslations.path, "assets/json/i18n");
      });
    });

    group("supportedLocales", () {
      test("Should return ar, en, es, id, hi, ru, zh locales", () {
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
  });

  group("Functions", () {
    runTranslationTest({
      required WidgetTester tester,
      required VoidCallback body,
    }) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(EasyLocalization(
          path: AppTranslations.path,
          supportedLocales: AppTranslations.supportedLocales,
          fallbackLocale: AppTranslations.fallbackLocale,
          useFallbackTranslations: true,
          useOnlyLangCode: true,
          child: const MyApp(),
        ));

        body();
        await tester.pump();
      });
    }

    group("change", () {
      executeTranslationsChangeTest({
        required WidgetTester tester,
        required DeviceLanguage language,
        required Locale expecetedLocale,
      }) async {
        await runTranslationTest(
          tester: tester,
          body: () async {
            final newLocale = AppTranslations.change(language, _context);
            expect(newLocale, expecetedLocale);
          },
        );
      }

      testWidgets(
        'Should change to ar locale when DeviceLanguage is arabic',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("ar"),
            language: DeviceLanguage.arabic,
          );
        },
      );

      testWidgets(
        'Should change to en locale when DeviceLanguage is english',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("en"),
            language: DeviceLanguage.english,
          );
        },
      );

      testWidgets(
        'Should change to es locale when DeviceLanguage is spanish',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("es"),
            language: DeviceLanguage.spanish,
          );
        },
      );

      testWidgets(
        'Should change to hi locale when DeviceLanguage is hindi',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("hi"),
            language: DeviceLanguage.hindi,
          );
        },
      );

      testWidgets(
        'Should change to id locale when DeviceLanguage is indonesian',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("id"),
            language: DeviceLanguage.indonesian,
          );
        },
      );

      testWidgets(
        'Should change to ru locale when DeviceLanguage is russian',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("ru"),
            language: DeviceLanguage.russian,
          );
        },
      );

      testWidgets(
        'Should change to zh locale when DeviceLanguage is chinese',
        (WidgetTester tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expecetedLocale: const Locale("zh"),
            language: DeviceLanguage.chinese,
          );
        },
      );
    });
  });
}
