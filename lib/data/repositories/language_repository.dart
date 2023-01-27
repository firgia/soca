/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import '../../core/core.dart';
import '../providers/providers.dart';

class LanguageRepository {
  late final LocalLanguageProvider _localLanguageProvider;

  LanguageRepository({required LocalLanguageProvider localLanguageProvider}) {
    _localLanguageProvider = localLanguageProvider;
  }

  /// Get the last saved changed language.
  Future<DeviceLanguage?> getLastChanged() async {
    final data = await _localLanguageProvider.getLastChanged();

    if (data == null) {
      return null;
    } else {
      return _getDeviceLanguageFromName(data);
    }
  }

  /// Get the last saved changed Onesignal language.
  Future<DeviceLanguage?> getLastChangedOnesignal() async {
    final data = await _localLanguageProvider.getLastChangedOnesignal();

    if (data == null) {
      return null;
    } else {
      return _getDeviceLanguageFromName(data);
    }
  }

  /// Update the last saved changed language.
  Future<void> updateLastChanged(DeviceLanguage? language) async {
    return await _localLanguageProvider.updateLastChanged(language?.name);
  }

  /// Update the last saved changed Onesignal language.
  Future<void> updateLastChangedOnesignal(DeviceLanguage? language) async {
    return await _localLanguageProvider
        .updateLastChangedOnesignal(language?.name);
  }

  DeviceLanguage? _getDeviceLanguageFromName(String name) {
    final languages = DeviceLanguage.values.where((e) => e.name == name);

    if (languages.isNotEmpty) {
      return languages.first;
    } else {
      return null;
    }
  }
}
