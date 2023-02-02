/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../injection.dart';

class DeviceProvider {
  String get deviceIDKey => "device_id_key";
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  final OneSignal _oneSignal = sl<OneSignal>();

  /// Get device ID
  ///
  /// The device id is only generated once, so each device has a unique ID.
  Future<String> getDeviceID() async {
    String? deviceID = await _secureStorage.read(key: deviceIDKey);
    if (deviceID == null) {
      const uuid = Uuid();
      String newDeviceID = uuid.v4();

      await _secureStorage.write(key: deviceIDKey, value: newDeviceID);
      return newDeviceID;
    } else {
      return deviceID;
    }
  }

  /// Get onesignal Player ID
  Future<String?> getOnesignalPlayerID() async {
    final deviceState = await _oneSignal.getDeviceState();
    return deviceState?.userId;
  }
}
