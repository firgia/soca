/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.dart';

String get _getMinimumVersionApp => "getMinimumVersionApp";
String get _isOutdated => LocalStoragePath.isOutdated;

void main() {
  late AppProvider appProvider;

  late MockSharedPreferences sharedPreferences;
  late MockFunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();

    sharedPreferences = getMockSharedPreferences();
    functionsProvider = getMockFunctionsProvider();
    appProvider = AppProviderImpl();
  });

  tearDown(() => unregisterLocator());

  group(".getMinimumVersion()", () {
    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(functionsName: _getMinimumVersionApp),
      ).thenAnswer((_) => Future.value({}));

      await appProvider.getMinimumVersion();
      verify(functionsProvider.call(functionsName: _getMinimumVersionApp));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(functionsName: _getMinimumVersionApp),
      ).thenThrow(exception);

      expect(
        () => appProvider.getMinimumVersion(),
        throwsA(exception),
      );
    });
  });

  group(".getIsOutdated()", () {
    test(
        "Should load from local storage by calling sharedPreferences.getString()",
        () async {
      when(sharedPreferences.getBool(_isOutdated)).thenReturn(true);

      bool? isOutdated = appProvider.getIsOutdated();

      expect(isOutdated, isTrue);
      verify(sharedPreferences.getBool(_isOutdated));
    });
  });

  group(".setLocale()", () {
    test(
        "Should save to local storage by calling sharedPreferences.setString()",
        () async {
      when(sharedPreferences.setBool(_isOutdated, false))
          .thenAnswer((_) => Future.value(true));

      bool? status = await appProvider.setIsOutdated(false);

      expect(status, isTrue);
      verify(sharedPreferences.setBool(_isOutdated, false));
    });
  });
}
