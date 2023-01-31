/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

class PlatformInfo {
  late final bool _isIOS;
  late final bool _isAndroid;

  bool get isIOS => _isIOS;
  bool get isAndroid => _isAndroid;

  PlatformInfo({
    required bool isIOS,
    required bool isAndroid,
  }) {
    _isIOS = isIOS;
    _isAndroid = isAndroid;
  }
}
