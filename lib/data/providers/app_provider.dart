/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../../injection.dart';
import 'functions_provider.dart';

abstract class AppProvider {
  /// {@template get_minimum_version}
  /// Get minimum version of current app
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getMinimumVersion();

  /// Get is outdated
  bool? getIsOutdated();

  /// Save is outdated
  Future<bool> setIsOutdated(bool value);
}

class AppProviderImpl implements AppProvider {
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final SharedPreferences _sharedPreferences = sl<SharedPreferences>();

  @override
  Future getMinimumVersion() {
    return _functionsProvider.call(
      functionsName: FunctionName.getMinimumVersionApp,
    );
  }

  @override
  bool? getIsOutdated() {
    return _sharedPreferences.getBool(LocalStoragePath.isOutdated);
  }

  @override
  Future<bool> setIsOutdated(bool value) {
    return _sharedPreferences.setBool(LocalStoragePath.isOutdated, value);
  }
}
