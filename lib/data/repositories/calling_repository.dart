/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:logging/logging.dart';

import '../../core/core.dart';
import '../../injection.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'auth_repository.dart';

class CallingRepository {
  CallingRepository() {
    _authRepository.onSignOut.listen((event) {
      _callingProvider.cancelOnCallStateUpdated();
    });
  }

  final AuthRepository _authRepository = sl<AuthRepository>();
  final CallingProvider _callingProvider = sl<CallingProvider>();
  final Logger _logger = Logger("Calling Repository");

  /// {@macro create_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
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

  /// {@macro get_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
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

  /// {@macro get_rtc_credential}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
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

  /// Fires when the call state data is updated.
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
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
}
