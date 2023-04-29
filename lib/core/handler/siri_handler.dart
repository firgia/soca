/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

import '../../injection.dart';
import '../../logic/logic.dart';
import '../core.dart';

/// This Handler is used for handling siri features.
///
/// Please call initialize to use this handler
abstract class SiriHandler {
  static bool _isInitialized = false;

  static void initialize() async {
    if (_isInitialized != true) {
      DeviceInfo deviceInfo = sl<DeviceInfo>();

      if (deviceInfo.isIOS()) {
        await FlutterSiriSuggestions.instance.registerActivity(
          const FlutterSiriActivity(
            "Call a volunteer",
            "call_volunteer",
            isEligibleForSearch: true,
            isEligibleForPrediction: true,
            contentDescription: "Search and call a volunteer",
            suggestedInvocationPhrase: "Call a volunteer",
          ),
        );

        FlutterSiriSuggestions.instance.configure(onLaunch: _onLaunch);
      }
    }

    _isInitialized = true;
  }
}

@pragma('vm:entry-point')
Future<void> _onLaunch(Map<String, dynamic> message) async {
  if (!sl.isRegistered<AssistantCommandBloc>()) {
    sl.registerSingleton<AssistantCommandBloc>(AssistantCommandBloc());
  }

  AssistantCommandBloc assistantCommandBloc = sl<AssistantCommandBloc>();

  switch (message["key"]) {
    case "call_volunteer":
      assistantCommandBloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer));
      break;
  }
}
