/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/enum/environtment_type.dart';

/// This Environment is used for use Third Party Service
abstract class Environtment {
  /// This dotEnv used for testing only
  static DotEnv? _dotEnvTest;

  /// Do not call this test in app
  ///
  /// This functions is only for testing
  @visibleForTesting
  static test(DotEnv testDotEnv) {
    _dotEnvTest = testDotEnv;
  }

  static EnvirontmentType _current = EnvirontmentType.development;

  /// Return OneSignal App ID to access OneSignal
  static String get onesignalAppID {
    return (_dotEnvTest ?? dotenv).env["ONESIGNAL_APP_ID"] ?? "";
  }

  /// Return Agora App ID to access Agora
  static String get agoraAppID {
    return (_dotEnvTest ?? dotenv).env["AGORA_APP_ID"] ?? "";
  }

  /// Return current environtment used
  ///
  /// The default environtment is [EnvirontmentType.development]
  static EnvirontmentType get current => _current;

  /// Set the current environtment
  ///
  /// Please set the environtment on the `main` before the app is loaded
  ///
  /// The default of current environtment is [EnvirontmentType.development]
  static setCurrentEnvirontment(EnvirontmentType type) => _current = type;

  /// Return true if current environtment is for `Production`
  static bool isProduction() => _current == EnvirontmentType.production;

  /// Return true if current environtment is for `Development`
  static bool isDevelopment() => _current == EnvirontmentType.development;

  /// Return true if current environtment is for `Staging`
  static bool isStaging() => _current == EnvirontmentType.staging;
}
