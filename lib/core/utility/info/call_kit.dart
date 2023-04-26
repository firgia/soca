/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

export 'package:flutter_callkit_incoming/entities/entities.dart';

class CallKitArgument extends CallKitParams with EquatableMixin {
  const CallKitArgument({
    super.id,
    super.nameCaller,
    super.appName,
    super.avatar,
    super.handle,
    super.type,
    super.duration,
    super.textAccept,
    super.textDecline,
    super.textMissedCall,
    super.textCallback,
    super.extra,
    super.headers,
    super.android,
    super.ios,
  });

  @override
  List<Object?> get props => [
        id,
        nameCaller,
        appName,
        avatar,
        handle,
        type,
        duration,
        textAccept,
        textDecline,
        textMissedCall,
        textCallback,
        extra,
        headers,
        android,
        ios,
      ];
}

class CallKit {
  /// Show Callkit Incoming.
  /// On iOS, using Callkit. On Android, using a custom UI.
  Future showCallkitIncoming(CallKitParams params) {
    return FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// Show Miss Call Notification.
  /// Only Android
  Future showMissCallNotification(CallKitParams params) async {
    return FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// Start an Outgoing call.
  /// On iOS, using Callkit(create a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  Future startCall(CallKitParams params) async {
    return FlutterCallkitIncoming.startCall(params);
  }

  /// End an Incoming/Outgoing call.
  /// On iOS, using Callkit(update a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  Future endCall(String id) async {
    return FlutterCallkitIncoming.endCall(id);
  }

  /// End all calls.
  Future endAllCalls() async {
    return FlutterCallkitIncoming.endAllCalls();
  }

  /// Get active calls.
  /// On iOS: return active calls from Callkit.
  /// On Android: only return last call
  Future<dynamic> activeCalls() async {
    return FlutterCallkitIncoming.activeCalls();
  }

  /// Get device push token VoIP.
  /// On iOS: return deviceToken for VoIP.
  /// On Android: return Empty
  Future getDevicePushTokenVoIP() async {
    return FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }
}
