/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';

import '../../core/core.dart';
import '../../injection.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'auth_repository.dart';

abstract class CallingRepository {
  /// {@macro create_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call> createCall();

  /// {@macro decline_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call?> declineCall({
    required String callID,
    required String blindID,
  });

  /// {@template end_call}
  /// End a call based on [callID]
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call?> endCall(String callID);

  /// {@macro get_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call> getCall(String callID);

  /// {@macro get_rtc_credential}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<RTCCredential> getRTCCredential({
    required String channelName,
    required RTCRole role,
    required int uid,
  });

  /// Fires when the call state data is updated.
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Stream<CallState?> onCallStateUpdated(String callID);
}

class CallingRepositoryImpl implements CallingRepository {
  CallingRepositoryImpl() {
    _authRepository.onSignOut.listen((event) {
      _callingProvider.cancelOnCallStateUpdated();
    });
  }

  final AuthRepository _authRepository = sl<AuthRepository>();
  final CallingProvider _callingProvider = sl<CallingProvider>();
  final Logger _logger = Logger("Calling Repository");

  @override
  Future<Call> createCall() async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to create call, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Creating call...");
      dynamic response = await _callingProvider.createCall();

      if (response != null) {
        _logger.fine("Successfully to create a call");
        return Call.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }

  @override
  Future<Call?> declineCall({
    required String callID,
    required String blindID,
  }) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to decline call, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    List<String>? listDeclinedCallID = await _getDeclinedCallID();
    bool isHasBeenEnded = false;

    if (listDeclinedCallID?.isNotEmpty ?? false) {
      isHasBeenEnded = listDeclinedCallID!.contains(callID);
    }

    if (isHasBeenEnded) return null;

    try {
      _logger.info("Decline call...");
      dynamic response = await _callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      );

      if (response != null) {
        await _addDeclinedCallID(callID);

        _logger.fine("Successfully to decline call");
        return Call.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }

  @override
  Future<Call?> endCall(String callID) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to end call, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    List<String>? listEndedCallID = await _getEndedCallID();
    bool isHasBeenEnded = false;

    if (listEndedCallID?.isNotEmpty ?? false) {
      isHasBeenEnded = listEndedCallID!.contains(callID);
    }

    if (isHasBeenEnded) return null;

    try {
      _logger.info("End call...");
      dynamic response = await _callingProvider.endCall(callID);

      if (response != null) {
        await _addEndedCallID(callID);

        _logger.fine("Successfully to end call");
        return Call.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }

  @override
  Future<Call> getCall(String callID) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get call data, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Getting call data...");
      dynamic response = await _callingProvider.getCall(callID);

      if (response != null) {
        _logger.fine("Successfully to get call data");
        return Call.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }

  @override
  Future<RTCCredential> getRTCCredential({
    required String channelName,
    required RTCRole role,
    required int uid,
  }) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe(
          "Failed to get RTC Credential data, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Getting RTC Credential data...");
      dynamic response = await _callingProvider.getRTCCredential(
        channelName: channelName,
        role: role,
        uid: uid,
      );

      if (response != null) {
        _logger.fine("Successfully to get RTC Credential data");
        return RTCCredential.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }

  @override
  Stream<CallState?> onCallStateUpdated(String callID) {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get call state, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    } else {
      final controller = StreamController<CallState?>();
      _callingProvider.onCallStateUpdated(callID).listen((response) {
        if (response != null) {
          controller.sink.add(CallStateExtension.getFromName(response));
        } else {
          controller.sink.add(null);
        }
      });

      _logger.fine("Subscribe Call State data on Realtime Database");
      return controller.stream;
    }
  }

  /// Add call ID are declined to local storage.
  Future<void> _addDeclinedCallID(String callID) async {
    List<String>? listOfData = await _getDeclinedCallID();

    late List<String> stored;
    if (listOfData != null) {
      listOfData.add(callID);
      stored = listOfData;
    } else {
      stored = [callID];
    }

    await _callingProvider.setDeclinedCallID(jsonEncode(stored));
  }

  /// Add call ID are ended to local storage.
  Future<void> _addEndedCallID(String callID) async {
    List<String>? listOfData = await _getEndedCallID();

    late List<String> stored;
    if (listOfData != null) {
      listOfData.add(callID);
      stored = listOfData;
    } else {
      stored = [callID];
    }

    await _callingProvider.setEndedCallID(jsonEncode(stored));
  }

  /// Get list of declined Call ID
  Future<List<String>?> _getDeclinedCallID() async {
    String? data = await _callingProvider.getDeclinedCallID();

    if (data != null) {
      return Parser.getListString(jsonDecode(data));
    } else {
      return null;
    }
  }

  /// Get list of ended Call ID
  Future<List<String>?> _getEndedCallID() async {
    String? data = await _callingProvider.getEndedCallID();

    if (data != null) {
      return Parser.getListString(jsonDecode(data));
    } else {
      return null;
    }
  }
}
