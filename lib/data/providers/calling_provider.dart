/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/core.dart';
import '../../injection.dart';
import '../models/models.dart';
import 'database_provider.dart';
import 'functions_provider.dart';

abstract class CallingProvider {
  /// {@template answer_call}
  /// Answer call
  ///
  /// `Note`
  /// This function is only allowed if the user type is a volunteer user,
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> answerCall({
    required String callID,
    required String blindID,
  });

  /// Cancel subscribtion call setting data
  void cancelOnCallSettingUpdated();

  /// Cancel subscribtion call state data
  void cancelOnCallStateUpdated();

  /// Cancel subscribtion user call data
  void cancelOnUserCallUpdated();

  /// {@template create_call}
  /// Create a call
  ///
  /// `Note`
  /// This function is only allowed if the user type is a blind user
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> createCall();

  /// {@template decline_call}
  /// Decline a call
  ///
  /// `Note`
  /// This function is only allowed if the user type is a volunteer user,
  /// this functions will ignored if call id has been declined
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> declineCall({
    required String callID,
    required String blindID,
  });

  /// {@template end_call}
  /// End a call based on [callID]
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> endCall(String callID);

  /// {@template get_call}
  /// Get a call based on [callID]
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getCall(String callID);

  /// {@template get_call_history}
  /// Get call history
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getCallHistory();

  /// {@template get_call_statistic}
  /// Get call statistic
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getCallStatistic({
    required String year,
    String? locale,
  });

  /// Get list of declined Call ID
  Future<String?> getDeclinedCallID();

  /// Get list of ended Call ID
  Future<String?> getEndedCallID();

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
  });

  /// Fires when the call setting data from [callID] is updated
  Stream<dynamic> onCallSettingUpdated(String callID);

  /// Fires when the call state data from [callID] is updated
  Stream<dynamic> onCallStateUpdated(String callID);

  /// Fires when the user call data from [callID] is updated
  Stream<dynamic> onUserCallUpdated(String callID);

  /// Add call ID are declined to local storage.
  Future<void> setDeclinedCallID(String value);

  /// Add call ID are ended to local storage.
  Future<void> setEndedCallID(String value);

  /// {@template update_call_setting}
  /// Update call settings
  ///
  /// `Note`
  /// this functions will ignored if [callID] has been declined
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<void> updateCallSettings({
    required String callID,
    required bool? enableFlashlight,
    required bool? enableFlip,
  });
}

class CallingProviderImpl implements CallingProvider {
  final DatabaseProvider _databaseProvider = sl<DatabaseProvider>();
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  StreamDatabase? _streamCallSetting;
  StreamDatabase? _streamCallState;
  StreamDatabase? _streamUserCall;

  String get _declinedCallIDKey => "declined_call_id";
  String get _endedCallIDKey => "ended_call_id";

  @override
  Future answerCall({
    required String callID,
    required String blindID,
  }) {
    return _functionsProvider.call(
      functionsName: FunctionName.answerCall,
      parameters: {
        "id": callID,
        "blind_id": blindID,
      },
    );
  }

  @override
  void cancelOnCallSettingUpdated() {
    _streamCallSetting?.dispose();
  }

  @override
  void cancelOnCallStateUpdated() {
    _streamCallState?.dispose();
  }

  @override
  void cancelOnUserCallUpdated() {
    _streamUserCall?.dispose();
  }

  @override
  Future<dynamic> createCall() async {
    return _functionsProvider.call(functionsName: FunctionName.createCall);
  }

  @override
  Future declineCall({
    required String callID,
    required String blindID,
  }) {
    return _functionsProvider.call(
      functionsName: FunctionName.declineCall,
      parameters: {
        "id": callID,
        "blind_id": blindID,
      },
    );
  }

  @override
  Future endCall(String callID) {
    return _functionsProvider.call(
      functionsName: FunctionName.endCall,
      parameters: {"id": callID},
    );
  }

  @override
  Future<dynamic> getCall(String callID) async {
    return _functionsProvider.call(
      functionsName: FunctionName.getCall,
      parameters: {"id": callID},
    );
  }

  @override
  Future<dynamic> getCallHistory() async {
    return _functionsProvider.call(functionsName: FunctionName.getCallHistory);
  }

  @override
  Future<dynamic> getCallStatistic({
    required String year,
    String? locale,
  }) {
    return _functionsProvider.call(
      functionsName: FunctionName.getCallStatistic,
      parameters: {
        "year": year,
        "locale": locale,
      },
    );
  }

  @override
  Future<String?> getDeclinedCallID() async {
    return _secureStorage.read(key: _declinedCallIDKey);
  }

  @override
  Future<String?> getEndedCallID() async {
    return _secureStorage.read(key: _endedCallIDKey);
  }

  @override
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

  @override
  Stream<dynamic> onCallSettingUpdated(String callID) {
    StreamDatabase streamDatabase =
        _databaseProvider.onValue("calls/$callID/settings");

    _streamCallSetting = streamDatabase;
    return streamDatabase.streamController.stream;
  }

  @override
  Stream<dynamic> onCallStateUpdated(String callID) {
    StreamDatabase streamDatabase =
        _databaseProvider.onValue("calls/$callID/state");

    _streamCallState = streamDatabase;
    return streamDatabase.streamController.stream;
  }

  @override
  Stream<dynamic> onUserCallUpdated(String callID) {
    StreamDatabase streamDatabase =
        _databaseProvider.onValue("calls/$callID/users");

    _streamUserCall = streamDatabase;
    return streamDatabase.streamController.stream;
  }

  @override
  Future<void> setDeclinedCallID(String value) async {
    await _secureStorage.write(
      key: _declinedCallIDKey,
      value: value,
    );
  }

  @override
  Future<void> setEndedCallID(String value) async {
    await _secureStorage.write(
      key: _endedCallIDKey,
      value: value,
    );
  }

  @override
  Future<void> updateCallSettings({
    required String callID,
    required bool? enableFlashlight,
    required bool? enableFlip,
  }) async {
    await _functionsProvider.call(
      functionsName: FunctionName.updateCallSettings,
      parameters: {
        "id": callID,
        if (enableFlashlight != null) "enable_flashlight": enableFlashlight,
        if (enableFlip != null) "enable_flip": enableFlip,
      },
    );
  }
}
