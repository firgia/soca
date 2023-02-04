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

class AppBottomSheet {
  late BuildContext context;
  AppBottomSheet(this.context);

  Future<void> show({
    required Widget Function(BuildContext context, Brightness brightness)
        childBuilder,
    double? height,
    bool isDismissible = true,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BrightnessBuilder(builder: (context, brightness) {
          bool isDark = brightness == Brightness.dark;

          return SafeArea(
            left: false,
            right: false,
            bottom: false,
            top: true,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    spreadRadius: 3,
                    blurRadius: 5,
                  )
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kBorderRadius),
                  topRight: Radius.circular(kBorderRadius),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: childBuilder(context, brightness),
              ),
            ),
          );
        });
      },
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      barrierColor: AppColors.barrier,
      isScrollControlled: height != null,
      useSafeArea: false,
    );
  }

  void close() => Navigator.of(context, rootNavigator: true).pop();
}
