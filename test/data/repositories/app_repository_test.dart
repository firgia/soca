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
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.dart';

void main() {
  late AppRepository appRepository;

  late MockAppProvider appProvider;
  late MockDeviceInfo deviceInfo;
  late MockPackageInfo packageInfo;

  setUp(() {
    registerLocator();

    appProvider = getMockAppProvider();
    deviceInfo = getMockDeviceInfo();
    packageInfo = getMockPackageInfo();
    appRepository = AppRepositoryImpl();
  });

  tearDown(() => unregisterLocator());

  group(".isOutdated", () {
    test("Should return value based on appProvider.getIsOutdated()", () async {
      when(
        appProvider.getIsOutdated(),
      ).thenReturn(true);

      expect(appRepository.isOutdated, isTrue);
      verify(appProvider.getIsOutdated());
    });

    test("Should return false when appProvider.getIsOutdated() data is null",
        () async {
      when(
        appProvider.getIsOutdated(),
      ).thenReturn(null);

      expect(appRepository.isOutdated, isFalse);
      verify(appProvider.getIsOutdated());
    });
  });

  group(".checkMinimumVersion", () {
    setUp(() {
      when(appProvider.getMinimumVersion()).thenAnswer(
        (_) => Future.value(
          {
            "android": {
              "build_number": 10,
              "version_name": "1.0.0",
            },
            "ios": {
              "build_number": 20,
              "version_name": "1.1.1",
            },
          },
        ),
      );
    });

    test("Should call appProvider.getMinimumVersion()", () async {
      await appRepository.checkMinimumVersion();

      verify(appProvider.getMinimumVersion());
    });

    group("android", () {
      test(
          'Should set isOutdated to true when current version app is under '
          'minimum version', () async {
        when(deviceInfo.isAndroid()).thenReturn(true);
        when(packageInfo.buildNumber).thenReturn("9");

        await appRepository.checkMinimumVersion();

        verify(appProvider.getMinimumVersion());
        verify(appProvider.setIsOutdated(true));
      });

      test(
          'Should set isOutdated to false when current version app is not under '
          'minimum version', () async {
        when(deviceInfo.isAndroid()).thenReturn(true);
        when(packageInfo.buildNumber).thenReturn("10");

        await appRepository.checkMinimumVersion();

        verify(appProvider.getMinimumVersion());
        verify(appProvider.setIsOutdated(false));
      });
    });

    group("iOS", () {
      test(
          'Should set isOutdated to true when current version app is under '
          'minimum version', () async {
        when(deviceInfo.isIOS()).thenReturn(true);
        when(packageInfo.buildNumber).thenReturn("19");

        await appRepository.checkMinimumVersion();

        verify(appProvider.getMinimumVersion());
        verify(appProvider.setIsOutdated(true));
      });

      test(
          'Should set isOutdated to false when current version app is not under '
          'minimum version', () async {
        when(deviceInfo.isIOS()).thenReturn(true);
        when(packageInfo.buildNumber).thenReturn("20");

        await appRepository.checkMinimumVersion();

        verify(appProvider.getMinimumVersion());
        verify(appProvider.setIsOutdated(false));
      });
    });
  });
}
