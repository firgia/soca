/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import '../../core/core.dart';
import '../../injection.dart';
import 'functions_provider.dart';

class CallingProvider {
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();

  /// {@template create_call}
  /// Create a call
  ///
  /// `Note`
  /// This function is only allowed if the user type is a blind user
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> createCall() async {
    return _functionsProvider.call(functionsName: FunctionName.createCall);
  }

  /// {@template get_call}
  /// Get a call based on [callID]
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getCall(String callID) async {
    return _functionsProvider.call(
      functionsName: FunctionName.getCall,
      parameters: {"id": callID},
    );
  }

  /// {@template get_rtc_credential}
  ///
  /// Get RTC credential to start calling
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getRTCCredential({
    required String channelName,
    required RTCRole role,
    required int uid,
  }) async {
    return _functionsProvider.call(
      functionsName: FunctionName.getRTCCredential,
      parameters: {
        "channel_name": channelName,
        "uid": uid,
        "role": role.name,
      },
    );
  }
}
