/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soca/core/core.dart';

import '../../injection.dart';
import 'app_colors.dart';

abstract class AppSystemOverlay {
  /// Set System UI Overlay based on Brightness
  /// * if [brightness] null, is set by platform Brightness
  void setSystemUIOverlayStyle([Brightness? brightness]);

  /// Set System UI Overlay for splash screen
  void setSystemUIOverlayStyleForSplash();

  /// Set System UI Overlay for calling screen
  void setSystemUIOverlayStyleForCall();
}

class AppSystemOverlayImpl implements AppSystemOverlay {
  final DeviceInfo _deviceInfo = sl<DeviceInfo>();

  @override
  void setSystemUIOverlayStyle([Brightness? brightness]) {
    final darkMode = (brightness == null)
        ? _deviceInfo.isDarkMode()
        : brightness == Brightness.dark;

    if (darkMode) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.black.withOpacity(.2),
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.black.withOpacity(.2),
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: const Color.fromRGBO(242, 242, 246, 1),
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  @override
  void setSystemUIOverlayStyleForCall() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.black.withOpacity(.1),
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void setSystemUIOverlayStyleForSplash() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.black.withOpacity(.1),
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.blue,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
