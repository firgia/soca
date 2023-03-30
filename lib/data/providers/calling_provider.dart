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
  /// Cancel subscribtion call state data
  void cancelOnCallStateUpdated();

  /// {@template create_call}
  /// Create a call
  ///
  /// `Note`
  /// This function is only allowed if the user type is a blind user
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> createCall();

  /// {@template get_call}
  /// Get a call based on [callID]
  ///
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getCall(String callID);

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

  /// Fires when the call state data from [callID] is updated
  Stream<dynamic> onCallStateUpdated(String callID);

  /// Add call ID are declined to local storage.
  Future<void> setDeclinedCallID(String value);

  /// Add call ID are ended to local storage.
  Future<void> setEndedCallID(String value);
}

class CallingProviderImpl implements CallingProvider {
  final DatabaseProvider _databaseProvider = sl<DatabaseProvider>();
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();
  StreamDatabase? _streamCallState;

  String get _declinedCallIDKey => "declined_call_id";
  String get _endedCallIDKey => "ended_call_id";

  @override
  void cancelOnCallStateUpdated() {
    _streamCallState?.dispose();
  }

  @override
  Future<dynamic> createCall() async {
    return _functionsProvider.call(functionsName: FunctionName.createCall);
  }

  @override
  Future<dynamic> getCall(String callID) async {
    return _functionsProvider.call(
      functionsName: FunctionName.getCall,
      parameters: {"id": callID},
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
  Stream<dynamic> onCallStateUpdated(String callID) {
    StreamDatabase streamDatabase =
        _databaseProvider.onValue("calls/$callID/state");

    _streamCallState = streamDatabase;
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
}
