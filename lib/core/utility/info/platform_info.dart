/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:soca/core/core.dart';

class PlatformInfo {
  late final bool _isIOS;
  late final bool _isAndroid;

  bool isIOS() => _isIOS;
  bool isAndroid() => _isAndroid;

  DevicePlatform? get devicePlatform {
    if (_isIOS) return DevicePlatform.ios;
    if (_isAndroid) return DevicePlatform.android;
    return null;
  }

  PlatformInfo({
    required bool isIOS,
    required bool isAndroid,
  }) {
    _isIOS = isIOS;
    _isAndroid = isAndroid;
  }
}
