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
        PlatformInfo platformInfo = PlatformInfo(isIOS: false, isAndroid: true);
        expect(platformInfo.devicePlatform, DevicePlatform.android);
      });

      test("Should return PlatformDevice.iOS if is iOS", () {
        PlatformInfo platformInfo = PlatformInfo(isIOS: true, isAndroid: false);
        expect(platformInfo.devicePlatform, DevicePlatform.ios);
      });

      test("Should return null if is not android and iOS", () {
        PlatformInfo platformInfo =
            PlatformInfo(isIOS: false, isAndroid: false);
        expect(platformInfo.devicePlatform, null);
      });
    });
  });

  group("Functions", () {
    group("isAndroid", () {
      test("Should return true if is android", () {
        PlatformInfo platformInfo = PlatformInfo(isIOS: false, isAndroid: true);
        expect(platformInfo.isAndroid(), true);
      });

      test("Should return false if is not android", () {
        PlatformInfo platformInfo =
            PlatformInfo(isIOS: false, isAndroid: false);
        expect(platformInfo.isAndroid(), false);
      });
    });

    group("isIos", () {
      test("Should return true if is iOS", () {
        PlatformInfo platformInfo = PlatformInfo(isIOS: true, isAndroid: false);
        expect(platformInfo.isIOS(), true);
      });

      test("Should return false if is not iOS", () {
        PlatformInfo platformInfo =
            PlatformInfo(isIOS: false, isAndroid: false);
        expect(platformInfo.isIOS(), false);
      });
    });
  });
}
