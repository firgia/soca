/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';

// We have to convert all static Fields and Functions to make it testable
class DeviceInfo {
  bool isIOS() => Platform.isIOS;
  bool isAndroid() => Platform.isAndroid;

  DevicePlatform? get platform {
    if (isIOS()) return DevicePlatform.ios;
    if (isAndroid()) return DevicePlatform.android;
    return null;
  }

  Future<AuthorizationCredentialAppleID> getAppleIDCredential({
    required List<AppleIDAuthorizationScopes> scopes,
    WebAuthenticationOptions? webAuthenticationOptions,
    String? nonce,
    String? state,
  }) {
    return SignInWithApple.getAppleIDCredential(
      scopes: scopes,
      nonce: nonce,
      state: state,
      webAuthenticationOptions: webAuthenticationOptions,
    );
  }

  Future<String?> getDevicePushTokenVoIP() async {
    return await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }
}
