/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import 'brightness_builder.dart';

class AppSnackbar {
  late BuildContext context;
  AppSnackbar(this.context);

  DeviceFeedback deviceFeedback = sl<DeviceFeedback>();

  void showMessage(
    String msg, {
    SnacbarStyle style = SnacbarStyle.original,
  }) {
    Color? backgroundColor;
    Color? textColor;

    switch (style) {
      case SnacbarStyle.danger:
        backgroundColor = Colors.redAccent;
        textColor = Colors.white;
        break;
      case SnacbarStyle.success:
        backgroundColor = Colors.green[500];
        textColor = Colors.white;
        break;
      default:
    }

    final snackBar = SnackBar(
      content: BrightnessBuilder(builder: (context, brighness) {
        final isDark = brighness == Brightness.dark;

        return Text(
          msg,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor ??
                    (isDark
                        ? AppColors.fontPalletsLight[0]
                        : AppColors.fontPalletsDark[0]),
              ),
        );
      }),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    deviceFeedback.vibrate();
    deviceFeedback.playVoiceAssistant(
      [msg],
      context,
      immediately: true,
    );
  }
}
