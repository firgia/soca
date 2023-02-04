/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import 'brightness_builder.dart';

class AppDialog {
  late BuildContext context;
  AppDialog(this.context);

  Future<void> show({
    required Widget Function(BuildContext context, Brightness brightness)
        childBuilder,
    bool isDismissible = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return BrightnessBuilder(builder: (context, brightness) {
          bool isDark = brightness == Brightness.dark;

          return Dialog(
            backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
            insetPadding: const EdgeInsets.all(kDefaultSpacing * 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: childBuilder(context, brightness),
          );
        });
      },
      barrierColor: AppColors.barrier,
      barrierDismissible: isDismissible,
    );
  }

  void close() => Navigator.of(context, rootNavigator: true).pop();
}
