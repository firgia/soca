/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/services.dart';

import '../../injection.dart';
import '../../logic/logic.dart';
import '../core.dart';

const EventChannel _siriEventChannel = EventChannel("com.firgia.soca/siri");

/// This Handler is used for handling siri features.
///
/// Please call initialize to use this handler
abstract class SiriHandler {
  static bool _isInitialized = false;

  static void initialize() async {
    if (_isInitialized != true) {
      DeviceInfo deviceInfo = sl<DeviceInfo>();

      if (deviceInfo.isIOS()) {
        _siriEventChannel.receiveBroadcastStream().listen(
          (event) {
            _onEvent(event);
          },
        );
      }
    }

    _isInitialized = true;
  }
}

@pragma('vm:entry-point')
Future<void> _onEvent(dynamic value) async {
  if (!sl.isRegistered<AssistantCommandBloc>()) {
    sl.registerSingleton<AssistantCommandBloc>(AssistantCommandBloc());
  }

  AssistantCommandBloc assistantCommandBloc = sl<AssistantCommandBloc>();

  switch (value.toString()) {
    case "com.firgia.soca.call_volunteer":
      assistantCommandBloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer));
      break;
  }
}
