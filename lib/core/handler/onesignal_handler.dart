/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:onesignal_flutter/onesignal_flutter.dart';

/// This Handler is used for handling OneSignal features.
///
/// Please call initialize to use this handler
abstract class OnesignalHandler {
  static bool _isInitialized = false;

  static void initialize() async {
    if (_isInitialized != true) {
      OneSignal.shared.setNotificationWillShowInForegroundHandler(
          (OSNotificationReceivedEvent event) {
        // Will be called whenever a notification is received in foreground
        // Display Notification, pass null param for not displaying the notification
        event.complete(event.notification);
      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        // Will be called whenever a notification is opened/button pressed.
      });
    }
    _isInitialized = true;
  }
}
