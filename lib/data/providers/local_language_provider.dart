/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import '../../injection.dart';

class LocalLanguageProvider {
  LocalLanguageProvider();

  String get lastChangedKey => "language_last_changed";
  String get lastChangedOnesignalKey => "language_last_onesignal_key";

  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  final Logger _logger = Logger("Local Language Provider");

  /// Get the last saved changed language.
  Future<String?> getLastChanged() async {
    _logger.info("Getting $lastChangedKey data...");
    final value = await _secureStorage.read(key: lastChangedKey);

    _logger.fine("Successfully to getting $lastChangedKey data");
    return value;
  }

  /// Get the last saved changed Onesignal language.
  Future<String?> getLastChangedOnesignal() async {
    _logger.info("Getting $lastChangedOnesignalKey data...");
    final value = await _secureStorage.read(key: lastChangedOnesignalKey);

    _logger.fine("Successfully to getting $lastChangedOnesignalKey data");
    return value;
  }

  /// Update the last saved changed language.
  Future<void> updateLastChanged(String? language) async {
    _logger.info("Saving $lastChangedKey data..");

    await _secureStorage.write(
      key: lastChangedKey,
      value: language,
    );

    _logger.fine("Successfully to save $lastChangedKey data");
  }

  /// Update the last saved changed Onesignal language.
  Future<void> updateLastChangedOnesignal(String? language) async {
    _logger.info("Saving $lastChangedOnesignalKey data...");

    await _secureStorage.write(
      key: lastChangedOnesignalKey,
      value: language,
    );

    _logger.fine("Successfully to save $lastChangedOnesignalKey data");
  }
}
