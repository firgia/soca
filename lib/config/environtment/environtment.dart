/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/enum/environtment_type.dart';

/// This Environment is used for use Third Party Service
abstract class Environtment {
  static EnvirontmentType _current = EnvirontmentType.development;

  /// Set the current environtment
  ///
  /// Please set the environtment on the `main` before the app is loaded
  ///
  /// The default of current environtment is [EnvirontmentType.development]
  static setCurrentEnvirontment(EnvirontmentType type) => _current = type;

  /// Return oneSignal App ID to access
  static String get onesignalAppID => dotenv.env["ONESIGNAL_APP_ID"]!;

  /// Return current environtment used
  ///
  /// The default environtment is [EnvirontmentType.development]
  static EnvirontmentType get current => _current;

  /// Return true if current environtment is for `Production`
  static bool get isProduction => _current == EnvirontmentType.production;

  /// Return true if current environtment is for `Development`
  static bool get isDevelopment => _current == EnvirontmentType.development;

  /// Return true if current environtment is for `Staging`
  static bool get isStaging => _current == EnvirontmentType.staging;
}
