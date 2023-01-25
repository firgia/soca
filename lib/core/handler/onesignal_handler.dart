import 'package:onesignal_flutter/onesignal_flutter.dart';

/// This Handler is used for handling OneSignal features.
///
/// Please call initialize to use this handler
abstract class OnesignalHandler {
  static bool _isInitialized = false;

  static Future<void> initialize({required bool showLog}) async {
    // TODO: Change this to bloc
    // final oneSignalController = Get.put(OneSignalController());

    if (_isInitialized != true) {
      if (showLog) {
        await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      }

      OneSignal.shared.setNotificationWillShowInForegroundHandler(
          (OSNotificationReceivedEvent event) {
        // Will be called whenever a notification is received in foreground
        // Display Notification, pass null param for not displaying the notification
        event.complete(event.notification);
      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        // Will be called whenever a notification is opened/button pressed.
        // TODO: Change this to bloc
        // oneSignalController.onNotificationOpenedHandler(result);
      });
    }
    _isInitialized = true;
  }
}
