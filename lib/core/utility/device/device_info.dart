/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

// We have to convert all static Fields and Functions to make it testable
abstract class DeviceInfo {
  /// Whether the operating system is a version of iOS.
  bool isIOS();

  /// Whether the operating system is a version of Android.
  bool isAndroid();

  /// Whether the device is using dark mode.
  bool isDarkMode();

  DevicePlatform? get platform;

  /// {@template get_apple_id_credential}
  /// Requests an Apple ID credential.
  ///
  /// Shows the native UI on Apple's platform, a Chrome Custom Tab on Android, and a popup on Websites.
  ///
  /// The returned [AuthorizationCredentialAppleID]'s `authorizationCode` should then be used to validate the token with Apple's servers and
  /// create a session in your system.
  ///
  /// Fields on the returned [AuthorizationCredentialAppleID] will be set based on the given scopes.
  ///
  /// User data fields (first name, last name, email) will only be set if this is the initial authentication between the current app and Apple ID.
  ///
  /// The returned Future will resolve in all cases on iOS and macOS, either with an exception if Sign in with Apple is not available,
  /// or as soon as the native UI goes away (either due cancellation or the completion of the authorization).
  ///
  /// On Android the returned Future will never resolve in case the user closes the Chrome Custom Tab without finishing the authentication flow.
  /// Any previous Future would be rejected if the [getAppleIDCredential] is called again, while an earlier one is still pending.
  ///
  /// Throws an [SignInWithAppleException] in case there was any error retrieving the credential.
  /// A specialized [SignInWithAppleAuthorizationException] is thrown in case of authorization errors, which contains
  /// further information about the failure.
  ///
  /// Throws an [SignInWithAppleNotSupportedException] in case Sign in with Apple is not available (e.g. iOS < 13, macOS < 10.15)
  /// {@endtemplate}
  Future<AuthorizationCredentialAppleID> getAppleIDCredential({
    required List<AppleIDAuthorizationScopes> scopes,
    WebAuthenticationOptions? webAuthenticationOptions,
    String? nonce,
    String? state,
  });

  /// {@template get_device_push_token_voip}
  /// Get device push token VoIP.
  /// On iOS: return deviceToken for VoIP.
  /// On Android: return Empty
  /// {@endtemplate}
  Future<String?> getDevicePushTokenVoIP();

  /// The current status of this permission.
  Future<PermissionStatus> getPermissionStatus(Permission permission);

  /// This method get the current system volume.
  Future<double> getVolume();

  /// Request the user for access to this [Permission], if access hasn't already
  /// been grant access before.
  ///
  /// Returns the new [PermissionStatus].
  Future<PermissionStatus> requestPermission(Permission permission);

  /// Requests the user for access to the supplied list of [Permission]s, if
  /// they have not already been granted before.
  ///
  /// Returns a [Map] containing the status per requested [Permission].
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions);

  /// Fires when the volume was changed.
  Stream<double> get onVolumeChanged;

  /// Fires when the volume changes to up and down or to down and up under 500
  /// milliseconds.
  Stream<double> get onVolumeUpAndDown;

  DateTime get localTime;
}

class DeviceInfoImpl implements DeviceInfo {
  @override
  bool isIOS() => Platform.isIOS;

  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isDarkMode() {
    final window = WidgetsBinding.instance.window;
    return window.platformBrightness == Brightness.dark;
  }

  @override
  DevicePlatform? get platform {
    if (isIOS()) return DevicePlatform.ios;
    if (isAndroid()) return DevicePlatform.android;
    return null;
  }

  @override
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

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    return await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }

  @override
  Future<PermissionStatus> getPermissionStatus(Permission permission) {
    return permission.status;
  }

  @override
  Future<double> getVolume() => PerfectVolumeControl.getVolume();

  @override
  Future<PermissionStatus> requestPermission(Permission permission) {
    return permission.request();
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    return permissions.request();
  }

  @override
  DateTime get localTime => DateTime.now();

  @override
  Stream<double> get onVolumeChanged => PerfectVolumeControl.stream;

  @override
  Stream<double> get onVolumeUpAndDown {
    final controller = StreamController<double>.broadcast();

    int intervalMilliSeconds = 500;

    PerfectVolumeControl.getVolume().then((value) {
      double currentvol = value;
      DateTime? lastVolumeUp;
      DateTime? lastVolumeDown;

      PerfectVolumeControl.stream.listen((volume) {
        if (volume != currentvol) {
          if (volume > currentvol) {
            lastVolumeUp = DateTime.now();

            if (lastVolumeDown != null) {
              if (lastVolumeUp!.difference(lastVolumeDown!).inMilliseconds <
                  intervalMilliSeconds) {
                controller.sink.add(volume);
              }
            }
          } else {
            lastVolumeDown = DateTime.now();

            if (lastVolumeUp != null) {
              if (lastVolumeDown!.difference(lastVolumeUp!).inMilliseconds <
                  intervalMilliSeconds) {
                controller.sink.add(volume);
              }
            }
          }
        }

        currentvol = volume;
      });
    });

    return controller.stream;
  }
}
