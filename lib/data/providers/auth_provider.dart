/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import '../../core/core.dart';
import '../../injection.dart';
import 'functions_provider.dart';

class AuthProvider {
  String get _signInOnProcessKey => "sign_in_on_process";
  String get _signInMethodKey => "sign_in_method";

  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  final Logger _logger = Logger("Local Language Provider");

  /// Check is on process to sign in
  ///
  /// Do not try to sign in when this functions return `true`
  Future<bool?> isSignInOnProcess() async {
    _logger.info("Getting $_signInOnProcessKey data...");
    final result = await _secureStorage.read(key: _signInOnProcessKey);

    _logger.fine("Successfully to getting $_signInOnProcessKey data");
    return (result == null) ? null : result == "true";
  }

  /// Set sign in is on process
  Future<void> setIsSignInOnProcess(bool value) async {
    _logger.info("Saving $_signInOnProcessKey data...");
    await _secureStorage.write(
      key: _signInOnProcessKey,
      value: value.toString(),
    );

    _logger.fine("Successfully to save $_signInOnProcessKey data");
  }

  /// Set authentication provider to sign in
  Future<void> setSignInMethod(AuthMethod? authMethod) async {
    _logger.info("Saving $_signInMethodKey data...");
    if (authMethod == null) {
      await _secureStorage.delete(key: _signInMethodKey);
    } else {
      await _secureStorage.write(key: _signInMethodKey, value: authMethod.name);
    }
    _logger.fine("Successfully to save $_signInMethodKey data");
  }

  /// Get authentication provider
  ///
  /// return `null` when user not signed in
  Future<AuthMethod?> getSignInMethod() async {
    _logger.info("Getting $_signInMethodKey data...");
    String? signInMethod = await _secureStorage.read(key: _signInMethodKey);

    if (signInMethod != null) {
      final result = AuthMethod.values.where((e) => e.name == signInMethod);

      if (result.isNotEmpty) {
        return result.single;
      }
    }

    _logger.fine("Successfully to getting $_signInMethodKey data");
    return null;
  }

  /// Notify to server when user has been sign in successfully
  ///
  /// {@macro firebase_functions_exception}
  Future<void> notifyIsSignInSuccessfully({
    required String deviceID,
    required String oneSignalPlayerID,
    required String? voipToken,
    required DevicePlatform devicePlatform,
  }) async {
    await _functionsProvider.call(
      functionsName: FunctionName.onSignIn,
      parameters: {
        "device_id": deviceID,
        "player_id": oneSignalPlayerID,
        "voip_token": voipToken,
        "platform": devicePlatform.name,
      },
    );
  }
}
