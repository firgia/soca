/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../../data/data.dart';
import '../../injection.dart';
import '../../logic/logic.dart';
import '../core.dart';

/// This Handler is used for handling incoming call features.
///
/// Please call initialize to use this handler
abstract class CallKitHandler {
  static bool _isInitialized = false;

  static void initialize() async {
    if (_isInitialized != true) {
      FlutterCallkitIncoming.onEvent.listen(_onEvent);
    }

    _isInitialized = true;
  }

  static Future<void> showCallkitIncoming(RemoteMessage message) async {
    try {
      final data = message.data;
      final customData = jsonDecode(data["custom"]);

      final contentData = customData["a"] as Map<String, dynamic>;
      final type = contentData["type"] as String;
      final uuid = contentData["uuid"] as String;

      if (type == "missed_video_call") {
        await FlutterCallkitIncoming.endCall(uuid);
      } else if (type == "incoming_video_call") {
        // Make sure incoming call kit
        if (Platform.isAndroid) {
          List<dynamic> calls = await FlutterCallkitIncoming.activeCalls();

          // Check to make sure incoming call not called twice with same call ID
          // (uuid is mean call id)
          if (calls.isNotEmpty) {
            bool invalidUUID = false;
            try {
              final tempUuid = calls.where((call) {
                final extra = Parser.getMap(call["extra"]);
                if (extra == null) {
                  return false;
                } else {
                  final savedUuid = Parser.getString(extra["uuid"]);
                  return savedUuid == uuid;
                }
              }).toList();

              // The incoming call for this [uuid] has been shown before,
              // so we don't need to show the incoming call again
              invalidUUID = (tempUuid.isNotEmpty);
            } catch (_) {}

            if (invalidUUID) return;
          }
        }

        final userCaller = contentData["user_caller"] as Map<String, dynamic>;
        final avatar = userCaller["avatar"] as String;
        final name = userCaller["name"] as String;

        CallKitParams params = CallKitParams(
          id: uuid,
          nameCaller: name,
          appName: 'Soca',
          avatar: avatar,
          handle: '',
          type: 1,
          duration: 30000,
          textAccept: 'Accept',
          textDecline: 'Decline',
          textMissedCall: 'Missed call',
          textCallback: 'Call back',
          extra: contentData,
          android: const AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            isShowCallback: false,
            backgroundColor: '#3a82f7',
            actionColor: '#4CAF50',
            incomingCallNotificationChannelName: "Incoming Call",
            missedCallNotificationChannelName: "Missed Call",
          ),
          ios: IOSParams(
            iconName: 'AppIcon',
            handleType: '',
            supportsVideo: true,
            maximumCallGroups: 1,
            maximumCallsPerCallGroup: 1,
            audioSessionMode: 'default',
            audioSessionActive: true,
            audioSessionPreferredSampleRate: 44100.0,
            audioSessionPreferredIOBufferDuration: 0.005,
            supportsDTMF: true,
            supportsHolding: false,
            supportsGrouping: false,
            supportsUngrouping: false,
          ),
        );

        await FlutterCallkitIncoming.showCallkitIncoming(params);
      }
    } catch (e, s) {
      // ignore: avoid_print
      print(s);
    }
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
