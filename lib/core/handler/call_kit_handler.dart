/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../../data/data.dart';
import '../../injection.dart';
import '../../logic/logic.dart';
import '../core.dart';

class CallKitHandler {
  static bool _isInitialized = false;

  static void initialize() async {
    if (_isInitialized != true) {
      FlutterCallkitIncoming.onEvent.listen(_onEvent);
    }

    _isInitialized = true;
  }
}

@pragma('vm:entry-point')
void _onEvent(CallEvent? callEvent) {
  if (!sl.isRegistered<IncomingCallBloc>()) {
    sl.registerSingleton<IncomingCallBloc>(IncomingCallBloc());
  }

  IncomingCallBloc incomingCallBloc = sl<IncomingCallBloc>();

  if (callEvent == null) return;

  CallKitData? data = CallKitData.getDataFromEvent(callEvent);
  if (data?.type != "incoming_video_call") return;

  switch (callEvent.event) {
    case Event.ACTION_CALL_ACCEPT:
      incomingCallBloc.add(IncomingCallEventAdded(callEvent));
      break;
    case Event.ACTION_CALL_DECLINE:
      // Declined an incoming call
      final callID = data?.uuid;
      final blindID = data?.userCaller?.uid;

      if (callID != null && blindID != null) {
        _declineCall(callID: callID, blindID: blindID);
      }
      break;
    case Event.ACTION_CALL_ENDED:
      // End an incoming call
      final callID = data?.uuid;

      if (callID != null) {
        _endCall(callID: callID);
      }
      break;
    case Event.ACTION_CALL_TIMEOUT:
      // Declined an incoming call
      final callID = data?.uuid;
      final blindID = data?.userCaller?.uid;

      if (callID != null && blindID != null) {
        _declineCall(callID: callID, blindID: blindID);
      }
      break;
    default:
      break;
  }
}

@pragma('vm:entry-point')
void _declineCall({
  required String callID,
  required String blindID,
}) async {
  if (!sl.isRegistered<CallActionBloc>()) {
    sl.registerFactory<CallActionBloc>(() => CallActionBloc());
  }

  CallActionBloc callActionBloc = sl<CallActionBloc>();

  try {
    callActionBloc.add(CallActionDeclined(blindID: blindID, callID: callID));
  } catch (e) {
    debugPrint(e.toString());
  }
}

@pragma('vm:entry-point')
void _endCall({required String callID}) {
  if (!sl.isRegistered<CallActionBloc>()) {
    sl.registerFactory<CallActionBloc>(() => CallActionBloc());
  }

  CallActionBloc callActionBloc = sl<CallActionBloc>();

  try {
    callActionBloc.add(CallActionEnded(callID));
  } catch (e) {
    debugPrint(e.toString());
  }
}
