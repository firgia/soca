/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'language_repository.dart';
import '../../injection.dart';
import '../../core/core.dart';

class OnesignalRepository with InternetConnectionHandlerMixin {
  OnesignalRepository() {
    listenInternetConnection();
  }

  final OneSignal _oneSignal = sl<OneSignal>();
  final LanguageRepository _languageRepository = sl<LanguageRepository>();

  bool _failedToUpdateLanguage = false;
  final Logger _logger = Logger("Onesignal Repository");

  /// Update oneSignal language based on last language selected by user
  ///
  /// Return true if successfully to update language
  Future<bool> updateLanguage() async {
    _logger.info("Updating the Language...");
    bool isFailedToUpdate = false;

    final lastLanguageChanged = await _languageRepository.getLastChanged();

    if (lastLanguageChanged != null) {
      final lastOnesignalLanguageChanged =
          await _languageRepository.getLastChangedOnesignal();

      if (lastOnesignalLanguageChanged != lastLanguageChanged) {
        try {
          final locale = lastLanguageChanged.toLocale();
          await _oneSignal.setLanguage(locale.languageCode);
          await _languageRepository
              .updateLastChangedOnesignal(lastLanguageChanged);
        } catch (_) {
          isFailedToUpdate = true;
        }
      }
    }

    if (_failedToUpdateLanguage) {
      _logger.warning(
          "Failed to update the language. The app will try to update the language automatically when the internet connection state has changed to connected.");
    } else {
      _logger.fine("Successfully to update the language");
    }

    _failedToUpdateLanguage = isFailedToUpdate;
    return !isFailedToUpdate;
  }

  @override
  void onInternetConnected() {
    super.onInternetConnected();

    if (_failedToUpdateLanguage) {
      _logger.info("Trying to update the language...");
      updateLanguage();
    }
  }

  void dispose() {
    cancelInternetConnectionListener();
  }
}
