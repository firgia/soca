/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/core.dart';
import '../../injection.dart';

class DeviceProvider {
  String get deviceIDKey => "device_id_key";

  final DeviceInfo _deviceInfo = sl<DeviceInfo>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  final OneSignal _oneSignal = sl<OneSignal>();
  final Logger _logger = Logger("Device Provider");

  /// Get device ID
  ///
  /// The device id is only generated once, so each device has a unique ID.
  Future<String> getDeviceID() async {
    _logger.info("Getting device ID...");
    String? deviceID = await _secureStorage.read(key: deviceIDKey);
    if (deviceID == null) {
      _logger.info("Generate new device ID...");
      const uuid = Uuid();
      String newDeviceID = uuid.v4();

      await _secureStorage.write(key: deviceIDKey, value: newDeviceID);
      _logger.info("Successfully to generate new device ID");
      return newDeviceID;
    } else {
      _logger.info("Successfully to get device ID");
      return deviceID;
    }
  }

  /// Get onesignal Player ID
  Future<String?> getOnesignalPlayerID() async {
    _logger.info("Getting onesignal player ID...");
    final deviceState = await _oneSignal.getDeviceState();
    final playerID = deviceState?.userId;
    _logger.info("Successfully to get onesignal player ID");

    return playerID;
  }

  /// Get device push token VoIP
  ///
  /// Return null if platform is not iOS
  Future<String?> getVoIP() async {
    return _deviceInfo.getDevicePushTokenVoIP();
  }

  /// Get current device platform
  DevicePlatform? getPlatform() {
    return _deviceInfo.platform;
  }
}
