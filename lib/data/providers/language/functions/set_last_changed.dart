/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of '../language_provider.dart';

Future<void> _setLastChanged(
  _LanguageProviderConfig config, {
  required String language,
}) async {
  final storage = config.secureStorage;

  return await storage.write(
    key: _LanguageProviderConfig.lastChangedKey,
    value: language,
  );
}
