/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../mock/mock.mocks.dart';

void main() {
  late LocalLanguageProvider localLanguageProvider;
  late LanguageRepository languageProvider;

  setUp(() {
    localLanguageProvider = MockLocalLanguageProvider();
    languageProvider = LanguageRepository(
      localLanguageProvider: localLanguageProvider,
    );
  });

  group("Functions", () {
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
