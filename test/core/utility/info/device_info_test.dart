/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Fields", () {
    group("platformDevice", () {
      test("Should return PlatformDevice.android if is android", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: false, isAndroid: true);
        expect(deviceInfo.devicePlatform, DevicePlatform.android);
      });

      test("Should return PlatformDevice.iOS if is iOS", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: true, isAndroid: false);
        expect(deviceInfo.devicePlatform, DevicePlatform.ios);
      });

      test("Should return null if is not android and iOS", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: false, isAndroid: false);
        expect(deviceInfo.devicePlatform, null);
      });
    });
  });

  group("Functions", () {
    group("isAndroid", () {
      test("Should return true if is android", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: false, isAndroid: true);
        expect(deviceInfo.isAndroid(), true);
      });

      test("Should return false if is not android", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: false, isAndroid: false);
        expect(deviceInfo.isAndroid(), false);
      });
    });

    group("isIos", () {
      test("Should return true if is iOS", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: true, isAndroid: false);
        expect(deviceInfo.isIOS(), true);
      });

      test("Should return false if is not iOS", () {
        DeviceInfo deviceInfo = DeviceInfo(isIOS: false, isAndroid: false);
        expect(deviceInfo.isIOS(), false);
      });
    });
  });
}
