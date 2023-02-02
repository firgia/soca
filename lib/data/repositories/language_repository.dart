/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';
import 'package:soca/injection.dart';

import '../../core/core.dart';
import '../providers/providers.dart';

class LanguageRepository {
  LanguageRepository();

  final LocalLanguageProvider _localLanguageProvider =
      sl<LocalLanguageProvider>();

  final Logger _logger = Logger("Language Repository");

  /// Get the last saved changed language.
  Future<DeviceLanguage?> getLastChanged() async {
    _logger.info("Getting last language changed data...");
    final data = await _localLanguageProvider.getLastChanged();

    if (data == null) {
      _logger.info("Last language changed data not found");
      return null;
    } else {
      _logger.info(
          "Successfully to get last language changed data. The last language changed is $data");
      return _getDeviceLanguageFromName(data);
    }
  }

  /// Get the last saved changed Onesignal language.
  Future<DeviceLanguage?> getLastChangedOnesignal() async {
    _logger.info("Getting last onesignal language changed data...");
    final data = await _localLanguageProvider.getLastChangedOnesignal();

    if (data == null) {
      _logger.info("Last onesignal language changed data not found");
      return null;
    } else {
      _logger.info(
          "Successfully to get last onesignal language changed data. The last onesignal language changed is $data");
      return _getDeviceLanguageFromName(data);
    }
  }

  /// Update the last saved changed language.
  Future<void> updateLastChanged(DeviceLanguage? language) async {
    _logger.info("Updating last language changed data...");
    final tempData = await _localLanguageProvider.getLastChangedOnesignal();

    if (tempData != null && _getDeviceLanguageFromName(tempData) == language) {
      _logger.info(
          "Update the last language changed data is ignored because the $language has been saved");
    } else {
      await _localLanguageProvider.updateLastChanged(language?.name);
      _logger.fine("Successfully to update last language changed");
    }
  }

  /// Update the last saved changed Onesignal language.
  Future<void> updateLastChangedOnesignal(DeviceLanguage? language) async {
    _logger.info("Updating the last onesignal language changed data...");
    final tempData = await _localLanguageProvider.getLastChangedOnesignal();

    if (tempData != null && _getDeviceLanguageFromName(tempData) == language) {
      _logger.info(
          "Update the last onesignal language changed data is ignored because the $language has been saved");
    } else {
      await _localLanguageProvider.updateLastChangedOnesignal(language?.name);
      _logger.fine("Successfully to update last onesignal language changed");
    }
  }

  DeviceLanguage? _getDeviceLanguageFromName(String name) {
    final languages = DeviceLanguage.values.where((e) => e.name == name);

    if (languages.isNotEmpty) {
      return languages.first;
    } else {
      _logger.warning("Device language not found");
      return null;
    }
  }
}
