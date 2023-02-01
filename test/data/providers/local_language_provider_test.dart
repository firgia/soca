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
import 'package:soca/data/providers/local_language_provider.dart';
import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _lastChangedKey => "language_last_changed";
String get _lastChangedOnesignalKey => "language_last_onesignal_key";

void main() {
  late LocalLanguageProvider languageProvider;
  late MockFlutterSecureStorage secureStorage;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    languageProvider = LocalLanguageProvider();
  });

  tearDown(() => unregisterLocator());

  group("Functions", () {
    group("getLastChanged", () {
      test("Should return last language data based on storage data", () async {
        when(secureStorage.read(key: _lastChangedKey))
            .thenAnswer((_) => Future.value("id"));
        final result = await languageProvider.getLastChanged();
        expect(result, "id");
        verify(secureStorage.read(key: _lastChangedKey)).called(1);
      });

      test("Should return null when data is not found", () async {
        when(secureStorage.read(key: _lastChangedKey))
            .thenAnswer((_) => Future.value(null));
        final result = await languageProvider.getLastChanged();
        expect(result, null);
        verify(secureStorage.read(key: _lastChangedKey)).called(1);
      });
    });

    group("getLastChangedOnesignal", () {
      test("Should return last onesignal language data based on storage data",
          () async {
        when(secureStorage.read(key: _lastChangedOnesignalKey))
            .thenAnswer((_) => Future.value("id"));
        final result = await languageProvider.getLastChangedOnesignal();
        expect(result, "id");
        verify(secureStorage.read(key: _lastChangedOnesignalKey)).called(1);
      });

      test("Should return null when data is not found", () async {
        when(secureStorage.read(key: _lastChangedOnesignalKey))
            .thenAnswer((_) => Future.value(null));
        final result = await languageProvider.getLastChangedOnesignal();
        expect(result, null);
        verify(secureStorage.read(key: _lastChangedOnesignalKey)).called(1);
      });
    });

    group("updateLastChanged", () {
      test("Should save data to storage", () async {
        await languageProvider.updateLastChanged("test");
        verify(secureStorage.write(key: _lastChangedKey, value: "test"))
            .called(1);
      });
    });

    group("updateLastChangedOnesignal", () {
      test("Should save data to storage", () async {
        await languageProvider.updateLastChangedOnesignal("test");
        verify(secureStorage.write(
                key: _lastChangedOnesignalKey, value: "test"))
            .called(1);
      });
    });
  });
}
