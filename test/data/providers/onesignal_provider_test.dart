/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Mar 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _lastUpdateTag => "onesignal_last_tag";
String get _lastUpdateUID => "onesignal_last_uid";

void main() {
  late OneSignalProvider oneSignalProvider;
  late MockFlutterSecureStorage secureStorage;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    oneSignalProvider = OneSignalProviderImpl();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() => unregisterLocator());

  group(".deleteLastUpdateUID()", () {
    test("Should save data to storage", () async {
      await oneSignalProvider.deleteLastUpdateUID();
      verify(secureStorage.delete(key: _lastUpdateUID));
    });
  });

  group(".getLastUpdateTag()", () {
    test("Should return last OneSignal tag data based on storage data",
        () async {
      when(secureStorage.read(key: _lastUpdateTag))
          .thenAnswer((_) => Future.value(jsonEncode({"id": "123"})));
      final result = await oneSignalProvider.getLastUpdateTag();
      expect(result, {"id": "123"});
      verify(secureStorage.read(key: _lastUpdateTag));
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _lastUpdateTag))
          .thenAnswer((_) => Future.value(null));
      final result = await oneSignalProvider.getLastUpdateTag();
      expect(result, null);
      verify(secureStorage.read(key: _lastUpdateTag)).called(1);
    });
  });

  group(".getLastUpdateUID()", () {
    test("Should return last OneSignal uid data based on storage data",
        () async {
      when(secureStorage.read(key: _lastUpdateUID))
          .thenAnswer((_) => Future.value("12"));
      final result = await oneSignalProvider.getLastUpdateUID();
      expect(result, "12");
      verify(secureStorage.read(key: _lastUpdateUID));
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _lastUpdateUID))
          .thenAnswer((_) => Future.value(null));
      final result = await oneSignalProvider.getLastUpdateUID();
      expect(result, null);
      verify(secureStorage.read(key: _lastUpdateUID)).called(1);
    });
  });

  group(".setLastUpdateTag()", () {
    test("Should save data to storage", () async {
      await oneSignalProvider.setLastUpdateTag({"id": "1"});
      verify(
        secureStorage.write(
            key: _lastUpdateTag, value: jsonEncode({"id": "1"})),
      );
    });
  });

  group(".setLastUpdateUID()", () {
    test("Should save data to storage", () async {
      await oneSignalProvider.setLastUpdateUID("test");
      verify(secureStorage.write(key: _lastUpdateUID, value: "test"));
    });
  });
}
