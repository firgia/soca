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
  EasyLocalization.logger.enableLevels = [];

  group("Fields", () {
    group("fallbackLocale", () {
      test("Should return Locale(en)", () {
        expect(AppTranslations.fallbackLocale, const Locale("en"));
      });
    });

    group("path", () {
      test("Should return the correct i18n location files", () {
        expect(AppTranslations.path, "assets/json/i18n");
      });
    });

    group("supportedLocales", () {
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
  });

  group("Functions", () {
    runTranslationTest({
      required WidgetTester tester,
      required Future Function() body,
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

        await body();
        await tester.pump();
      });
    }

    group("change", () {
      executeTranslationsChangeTest({
        required WidgetTester tester,
        required DeviceLanguage language,
        required Locale expectedLocale,
      }) async {
        await runTranslationTest(
          tester: tester,
          body: () async {
            final newLocale = AppTranslations.change(language, _context);
            expect(newLocale, expectedLocale);
            expect(_context.locale, expectedLocale);
          },
        );
      }

      testWidgets(
        'Should change current Locale to Locale(ar) when DeviceLanguage.arabic',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("ar"),
            language: DeviceLanguage.arabic,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(en) when DeviceLanguage.english',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("en"),
            language: DeviceLanguage.english,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(es) when DeviceLanguage.spanish',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("es"),
            language: DeviceLanguage.spanish,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(hi) when DeviceLanguage.hindi',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("hi"),
            language: DeviceLanguage.hindi,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(id) when DeviceLanguage.indonesian',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("id"),
            language: DeviceLanguage.indonesian,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(ru) when DeviceLanguage.russian',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("ru"),
            language: DeviceLanguage.russian,
          );
        },
      );

      testWidgets(
        'Should change current Locale to Locale(zh) when DeviceLanguage.chinese',
        (tester) async {
          await executeTranslationsChangeTest(
            tester: tester,
            expectedLocale: const Locale("zh"),
            language: DeviceLanguage.chinese,
          );
        },
      );
    });

    group("getCurrentDeviceLanguage", () {
      executeGetCurrentDeviceLanguageTest({
        required WidgetTester tester,
        required DeviceLanguage expectedDeviceLanguage,
        required Locale locale,
      }) async {
        await runTranslationTest(
          tester: tester,
          body: () async {
            _context.setLocale(locale);
            expect(
              AppTranslations.getCurrentDeviceLanguage(_context),
              expectedDeviceLanguage,
            );
          },
        );
      }

      testWidgets(
        "Should return DeviceLanguage.arabic when Locale(ar)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.arabic,
            locale: const Locale("ar"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.english when Locale(en)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.english,
            locale: const Locale("en"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.spanish when Locale(es)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.spanish,
            locale: const Locale("es"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.hindi when Locale(hi)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.hindi,
            locale: const Locale("hi"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.indonesian when Locale(id)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.indonesian,
            locale: const Locale("id"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.russian when Locale(ru)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.russian,
            locale: const Locale("ru"),
          );
        },
      );

      testWidgets(
        "Should return DeviceLanguage.chinese when Locale(zh)",
        (tester) async {
          await executeGetCurrentDeviceLanguageTest(
            tester: tester,
            expectedDeviceLanguage: DeviceLanguage.chinese,
            locale: const Locale("zh"),
          );
        },
      );
    });
  });
}
