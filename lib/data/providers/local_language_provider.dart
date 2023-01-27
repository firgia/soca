/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalLanguageProvider {
  String get lastChangedKey => "language_last_changed";
  String get lastChangedOnesignalKey => "language_last_onesignal_key";

  late final FlutterSecureStorage _secureStorage;

  LocalLanguageProvider({required FlutterSecureStorage secureStorage}) {
    _secureStorage = secureStorage;
  }

  /// Get the last saved changed language.
  Future<String?> getLastChanged() async {
    return await _secureStorage.read(key: lastChangedKey);
  }

  /// Get the last saved changed Onesignal language.
  Future<String?> getLastChangedOnesignal() async {
    return await _secureStorage.read(key: lastChangedOnesignalKey);
  }

  /// Update the last saved changed language.
  Future<void> updateLastChanged(String? language) async {
    return await _secureStorage.write(
      key: lastChangedKey,
      value: language,
    );
  }

  /// Update the last saved changed Onesignal language.
  Future<void> updateLastChangedOnesignal(String? language) async {
    return await _secureStorage.write(
      key: lastChangedOnesignalKey,
      value: language,
    );
  }
}
