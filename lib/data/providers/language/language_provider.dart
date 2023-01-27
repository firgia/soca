/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'functions/get_last_changed.dart';
part 'functions/get_last_changed_onesignal.dart';
part 'functions/set_last_changed.dart';
part 'functions/set_last_changed_onesignal.dart';

part 'config.dart';
part 'interface.dart';

class LanguageProvider extends _LanguageProviderInterface {
  late final _LanguageProviderConfig _config;

  LanguageProvider() {
    _config = const _LanguageProviderConfig(
      secureStorage: FlutterSecureStorage(),
    );
  }

  @visibleForTesting
  LanguageProvider.test({
    required FlutterSecureStorage secureStorage,
  }) {
    _config = _LanguageProviderConfig(secureStorage: secureStorage);
  }

  @override
  Future<String?> getLastChanged() {
    return _getLastChanged(_config);
  }

  @override
  Future<String?> getLastChangedOnesignal() {
    return _getLastChangedOnesignal(_config);
  }

  @override
  Future<void> setLastChanged(String language) {
    return _setLastChanged(_config, language: language);
  }

  @override
  Future<void> setLastChangedOnesignal(String language) {
    return _setLastChangedOnesignal(_config, language: language);
  }

  @override
  void dispose() {
    _config.dispose();
  }
}
