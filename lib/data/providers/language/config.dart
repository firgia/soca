/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_provider.dart';

class _LanguageProviderConfig {
  static String get lastChangedKey => "language_last_changed";
  static String get lastChangedOnesignalKey => "language_last_onesignal_key";

  const _LanguageProviderConfig({
    required this.secureStorage,
  });

  final FlutterSecureStorage secureStorage;

  void dispose() {}
}
