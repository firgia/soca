/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

import '../../injection.dart';

abstract class OneSignalProvider {
  /// Update the last saved changed UID.
  Future<void> deleteLastUpdateUID();

  /// Get the last saved changed OneSignal Tag.
  Future<Map<String, dynamic>?> getLastUpdateTag();

  /// Get the last saved changed OneSignal UID.
  Future<String?> getLastUpdateUID();

  /// Update the last saved changed Tag.
  Future<void> setLastUpdateTag(Map<String, dynamic> value);

  /// Update the last saved changed UID.
  Future<void> setLastUpdateUID(String? value);
}

class OneSignalProviderImpl implements OneSignalProvider {
  String get lastUpdateTag => "onesignal_last_tag";
  String get lastUpdateUID => "onesignal_last_uid";

  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  final Logger _logger = Logger("OneSignal Provider");

  @override
  Future<void> deleteLastUpdateUID() async {
    _logger.info("Delete $lastUpdateUID data..");

    await _secureStorage.delete(key: lastUpdateUID);

    _logger.fine("Successfully to delete $lastUpdateUID data");
  }

  @override
  Future<Map<String, dynamic>?> getLastUpdateTag() async {
    _logger.info("Getting $lastUpdateTag data...");

    final result = await _secureStorage.read(key: lastUpdateTag);

    _logger.fine("Successfully to getting $lastUpdateTag data");
    if (result == null) {
      return null;
    } else {
      return json.decode(result);
    }
  }

  @override
  Future<String?> getLastUpdateUID() async {
    _logger.info("Getting $lastUpdateUID data...");
    final value = await _secureStorage.read(key: lastUpdateUID);

    _logger.fine("Successfully to getting $lastUpdateUID data");
    return value;
  }

  @override
  Future<void> setLastUpdateTag(Map<String, dynamic> value) async {
    _logger.info("Saving $lastUpdateTag data..");

    final temp = await _secureStorage.read(key: lastUpdateTag);
    Map<String, dynamic>? newValue = temp == null ? null : json.decode(temp);

    if (newValue != null) {
      newValue.addAll(value);

      await _secureStorage.write(
        key: lastUpdateTag,
        value: json.encode(newValue),
      );
    } else {
      await _secureStorage.write(
        key: lastUpdateTag,
        value: json.encode(value),
      );
    }

    _logger.fine("Successfully to save $lastUpdateTag data");
  }

  @override
  Future<void> setLastUpdateUID(String? value) async {
    _logger.info("Saving $lastUpdateUID data..");

    await _secureStorage.write(
      key: lastUpdateUID,
      value: value,
    );

    _logger.fine("Successfully to save $lastUpdateUID data");
  }
}
