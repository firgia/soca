/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:app_settings/app_settings.dart';

abstract class DeviceSettings {
  /// Future async method call to open app specific settings screen.
  Future<void> openAppSettings({
    bool asAnotherTask = false,
    Function? callback,
  });

  /// Future async method call to open notification settings.
  Future<void> openNotificationSettings({
    bool asAnotherTask = false,
    Function? callback,
  });
}

class DeviceSettingsImpl implements DeviceSettings {
  @override
  Future<void> openAppSettings({
    bool asAnotherTask = false,
    Function? callback,
  }) {
    return AppSettings.openAppSettings(
      asAnotherTask: asAnotherTask,
      callback: callback,
    );
  }

  @override
  Future<void> openNotificationSettings({
    bool asAnotherTask = false,
    Function? callback,
  }) {
    return AppSettings.openNotificationSettings(
      asAnotherTask: asAnotherTask,
      callback: callback,
    );
  }
}
