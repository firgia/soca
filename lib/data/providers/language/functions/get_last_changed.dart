/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of '../language_provider.dart';

Future<String?> _getLastChanged(_LanguageProviderConfig config) async {
  final storage = config.secureStorage;
  return await storage.read(key: _LanguageProviderConfig.lastChangedKey);
}
