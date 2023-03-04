/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockLocalLanguageProvider localLanguageProvider;
  late LanguageRepository languageProvider;

  setUp(() {
    registerLocator();
    localLanguageProvider = getMockLocalLanguageProvider();
    languageProvider = LanguageRepository();
  });

  tearDown(() => unregisterLocator());

  group("Functions", () {
    group("getLanguage", () {
      test("Should convert json to [List<Language>]", () async {
        when(localLanguageProvider.getLanguages()).thenAnswer(
          (_) => Future.value(
            json.decode(
              json.encode([
                {"code": "en", "name": "English", "nativeName": "English"},
                {
                  "code": "id",
                  "name": "Indonesian",
                  "nativeName": "Bahasa Indonesia"
                },
              ]),
            ),
          ),
        );

        final result = await languageProvider.getLanguages();
        expect(result, const [
          Language(
            code: "en",
            name: "English",
            nativeName: "English",
          ),
          Language(
            code: "id",
            name: "Indonesian",
            nativeName: "Bahasa Indonesia",
          )
        ]);
        verify(localLanguageProvider.getLanguages());
      });
    });

    group("getLastChanged", () {
      test("Should return last DeviceLanguage data based on storage data",
          () async {
        when(localLanguageProvider.getLastChanged()).thenAnswer(
          (_) => Future.value("indonesian"),
        );

        final result = await languageProvider.getLastChanged();
        expect(result, DeviceLanguage.indonesian);
        verify(localLanguageProvider.getLastChanged()).called(1);
      });

      test("Should return null when data is not found", () async {
        when(localLanguageProvider.getLastChanged()).thenAnswer(
          (_) => Future.value(null),
        );

        final result = await languageProvider.getLastChanged();
        expect(result, null);
        verify(localLanguageProvider.getLastChanged()).called(1);
      });
    });

    group("getLastChangedOnesignal", () {
      test("Should return last DeviceLanguage data based on storage data",
          () async {
        when(localLanguageProvider.getLastChangedOnesignal()).thenAnswer(
          (_) => Future.value("indonesian"),
        );

        final result = await languageProvider.getLastChangedOnesignal();
        expect(result, DeviceLanguage.indonesian);
        verify(localLanguageProvider.getLastChangedOnesignal()).called(1);
      });

      test("Should return null when data is not found", () async {
        when(localLanguageProvider.getLastChangedOnesignal()).thenAnswer(
          (_) => Future.value(null),
        );

        final result = await languageProvider.getLastChangedOnesignal();
        expect(result, null);
        verify(localLanguageProvider.getLastChangedOnesignal()).called(1);
      });
    });

    group("updateLastChanged", () {
      test("Should save DeviceLanguage data to storage", () async {
        await languageProvider.updateLastChanged(DeviceLanguage.indonesian);
        verify(localLanguageProvider.updateLastChanged("indonesian")).called(1);
      });
    });

    group("updateLastChangedOnesignal", () {
      test("Should save DeviceLanguage data to storage", () async {
        await languageProvider
            .updateLastChangedOnesignal(DeviceLanguage.indonesian);
        verify(localLanguageProvider.updateLastChangedOnesignal("indonesian"))
            .called(1);
      });
    });
  });
}
