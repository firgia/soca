/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue May 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/services.dart';

import '../../injection.dart';
import '../../logic/logic.dart';
import '../core.dart';

const EventChannel _assistantEventChannel =
    EventChannel("com.firgia.soca/assistant");

/// This Handler is used for handling assistant features.
///
/// Please call initialize to use this handler
abstract class AssistantHandler {
  static bool _isInitialized = false;

  static void initialize() {
    if (_isInitialized != true) {
      DeviceInfo deviceInfo = sl<DeviceInfo>();

      if (deviceInfo.isAndroid()) {
        _assistantEventChannel.receiveBroadcastStream().listen(
          (event) {
            _onAssistantEvent(event);
          },
        );
      }
    }

    _isInitialized = true;
  }
}

@pragma('vm:entry-point')
void _onAssistantEvent(dynamic value) {
  if (!sl.isRegistered<AssistantCommandBloc>()) {
    sl.registerSingleton<AssistantCommandBloc>(AssistantCommandBloc());
  }

  AssistantCommandBloc assistantCommandBloc = sl<AssistantCommandBloc>();

  switch (value.toString()) {
    case "call_volunteer":
      assistantCommandBloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer));
      break;
  }
}
