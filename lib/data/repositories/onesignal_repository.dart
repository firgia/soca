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
import '../../core/core.dart';

class OnesignalRepository {
  late final OneSignal _oneSignal;
  late final LanguageRepository _languageRepository;

  OnesignalRepository({
    required OneSignal oneSignal,
    required LanguageRepository languageRepository,
  }) {
    _oneSignal = oneSignal;
    _languageRepository = languageRepository;
  }

  // TODO: This operation maybe will failed, please call this operation again when the operation failed because internet connection
  // HINT: use internet_connection_checker package

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

    return !isFailedToUpdate;
  }
}
