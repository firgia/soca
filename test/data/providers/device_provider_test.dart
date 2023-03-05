/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _deviceIDKey => "device_id_key";

void main() {
  late DeviceProvider deviceProvider;
  late MockFlutterSecureStorage secureStorage;
  late MockOneSignal oneSignal;
  late MockDeviceInfo deviceInfo;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    oneSignal = getMockOneSignal();
    deviceInfo = getMockDeviceInfo();
    deviceProvider = DeviceProvider();
  });

  tearDown(() => unregisterLocator());

  group(".getDeviceID()", () {
    test("Should not generate new device ID when device ID already exists",
        () async {
      when(secureStorage.read(key: _deviceIDKey))
          .thenAnswer((_) => Future.value("12345"));

      final deviceID = await deviceProvider.getDeviceID();

      expect(deviceID, "12345");
      verify(secureStorage.read(key: _deviceIDKey));
      verifyNever(
          secureStorage.write(key: _deviceIDKey, value: anyNamed("value")));
    });

    test("Should generate new device ID when device ID is empty", () async {
      when(secureStorage.read(key: _deviceIDKey))
          .thenAnswer((_) => Future.value(null));

      await deviceProvider.getDeviceID();

      verify(secureStorage.read(key: _deviceIDKey));
      verify(secureStorage.write(key: _deviceIDKey, value: anyNamed("value")));
    });
  });

  group(".getOnesignalPlayerID()", () {
    test("Should return onesignal player ID", () async {
      when(oneSignal.getDeviceState()).thenAnswer(
        (_) => Future.value(OSDeviceState({
          'hasNotificationPermission': false,
          'pushDisabled': false,
          'subscribed': false,
          'emailSubscribed': false,
          'smsSubscribed': false,
          'userId': "12345-12345",
        })),
      );

      final playerID = await deviceProvider.getOnesignalPlayerID();

      expect(playerID, "12345-12345");
      verify(oneSignal.getDeviceState());
    });
  });

  group(".getVoIP()", () {
    test("Should return voip from getDevicePushTokenVoIP()", () async {
      when(deviceInfo.getDevicePushTokenVoIP())
          .thenAnswer((_) => Future.value("1234"));

      final voip = await deviceProvider.getVoIP();
      expect(voip, "1234");
      verify(deviceInfo.getDevicePushTokenVoIP());
    });
  });
}
