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
  /// {@macro answer_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call> answerCall({
    required String callID,
    required String blindID,
  });

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

  /// {@macro end_call}
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

  /// {@macro get_call_history}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<List<CallHistory>> getCallHistory();

  /// {@macro get_call_statistic}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<CallStatistic> getCallStatistic({
    required String year,
    String? locale,
  });

  /// {@macro get_rtc_credential}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<RTCCredential> getRTCCredential({
    required String channelName,
    required RTCRole role,
    required UserType userType,
  });

  /// Fires when the call setting data is updated.
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Stream<CallSetting?> onCallSettingUpdated(String callID);

  /// Fires when the call state data is updated.
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Stream<CallState?> onCallStateUpdated(String callID);

  /// Fires when the user call data is updated.
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Stream<UserCall?> onUserCallUpdated(String callID);

  /// {@macro update_call_setting}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<void> updateCallSettings({
    required String callID,
    required bool? enableFlashlight,
    required bool? enableFlip,
  });
}

class CallingRepositoryImpl implements CallingRepository {
  CallingRepositoryImpl() {
    _authRepository.onSignOut.listen((event) {
      _callingProvider.cancelOnCallSettingUpdated();
      _callingProvider.cancelOnCallStateUpdated();
      _callingProvider.cancelOnUserCallUpdated();
    });
  }

  final AuthRepository _authRepository = sl<AuthRepository>();
  final CallingProvider _callingProvider = sl<CallingProvider>();
  final Logger _logger = Logger("Calling Repository");

  int _getRtcUID(UserType type) {
    if (type == UserType.blind) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Future<Call> answerCall({
    required String callID,
    required String blindID,
  }) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to answer call, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Answering call...");
      dynamic response = await _callingProvider.answerCall(
        blindID: blindID,
        callID: callID,
      );

      if (response != null) {
        _logger.fine("Successfully to answer call");
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
  Future<List<CallHistory>> getCallHistory() async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get call history, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Get call history...");
      dynamic response = await _callingProvider.getCallHistory();

      if (response != null) {
        List<dynamic>? jsonObject = Parser.getListDynamic(response);
        List<CallHistory> result = [];

        if (jsonObject != null) {
          for (var item in jsonObject) {
            final map = Parser.getMap(item);

            if (map != null) {
              result.add(CallHistory.fromMap(map));
            }
          }
        }

        _logger.fine("Successfully to get call history");
        return result;
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
  Future<CallStatistic> getCallStatistic({
    required String year,
    String? locale,
  }) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe(
          "Failed to get call statistic data, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Getting call statistic data...");
      dynamic response = await _callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      );

      if (response != null) {
        _logger.fine("Successfully to get call statistic data");
        return CallStatistic.fromMap(response);
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
    required UserType userType,
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
        uid: _getRtcUID(userType),
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
  Stream<CallSetting?> onCallSettingUpdated(String callID) {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get call setting, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    } else {
      final controller = StreamController<CallSetting?>();
      _callingProvider.onCallSettingUpdated(callID).listen((response) {
        if (response != null) {
          controller.sink.add(CallSetting.fromMap(response));
        } else {
          controller.sink.add(null);
        }
      });

      _logger.fine("Subscribe call setting data on Realtime Database");
      return controller.stream;
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

      _logger.fine("Subscribe call state data on Realtime Database");
      return controller.stream;
    }
  }

  @override
  Stream<UserCall?> onUserCallUpdated(String callID) {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger
          .severe("Failed to get user call data, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    } else {
      final controller = StreamController<UserCall?>();
      _callingProvider.onUserCallUpdated(callID).listen((response) {
        if (response != null) {
          controller.sink.add(UserCall.fromMap(response));
        } else {
          controller.sink.add(null);
        }
      });

      _logger.fine("Subscribe user call data on Realtime Database");
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

  @override
  Future<void> updateCallSettings({
    required String callID,
    required bool? enableFlashlight,
    required bool? enableFlip,
  }) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger
          .severe("Failed to update call settings, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Updating call settings...");
      await _callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      );

      _logger.fine("Successfully to update call settings");
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }
}
