/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'language_repository.dart';
import '../../injection.dart';
import '../../core/core.dart';

class OnesignalRepository with InternetConnectionHandlerMixin {
  final OneSignal _oneSignal = sl<OneSignal>();
  final LanguageRepository _languageRepository = sl<LanguageRepository>();

  bool _failedToUpdateLanguage = false;

  OnesignalRepository() {
    listenInternetConnection();
  }

  /// Update oneSignal language based on last language selected by user
  ///
  /// Return true if successfully to update language
  Future<bool> updateLanguage() async {
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
    _failedToUpdateLanguage = isFailedToUpdate;
    return !isFailedToUpdate;
  }

  @override
  void onInternetConnected() {
    super.onInternetConnected();

    if (_failedToUpdateLanguage) {
      updateLanguage();
    }
  }

  void dispose() {
    cancelInternetConnectionListener();
  }
}
