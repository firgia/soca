/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> pickImage({
    Function()? onTapCamera,
    Function()? onTapGallery,
  }) async {
    await show(childBuilder: (context, brightness) {
      bool isDark = brightness == Brightness.dark;

      final Color textColor =
          isDark ? AppColors.fontPalletsDark[1] : AppColors.fontPalletsLight[1];
      final Color iconColor =
          isDark ? AppColors.fontPalletsDark[2] : AppColors.fontPalletsLight[2];
      final textTheme = Theme.of(context).textTheme;

      return Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(kDefaultSpacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.choose_an_image,
              style: textTheme.titleLarge?.copyWith(color: textColor),
            ).tr(),
            const SizedBox(height: kDefaultSpacing * 2),
            Row(
              children: [
                const Spacer(flex: 1),
                Column(
                  children: [
                    IconButton(
                        key: const Key("dialog_pick_image_camera_icon_button"),
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          color: iconColor,
                        ),
                        onPressed: () {
                          close();
                          if (onTapCamera != null) onTapCamera();
                        }),
                    Text(
                      LocaleKeys.camera,
                      style: textTheme.bodyMedium?.copyWith(color: textColor),
                    ).tr(),
                  ],
                ),
                const Spacer(flex: 2),
                Column(
                  children: [
                    IconButton(
                        key: const Key("dialog_pick_image_gallery_icon_button"),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            FontAwesomeIcons.solidImages,
                            color: iconColor,
                          ),
                        ),
                        onPressed: () {
                          close();
                          if (onTapGallery != null) onTapGallery();
                        }),
                    Text(
                      LocaleKeys.gallery,
                      style: textTheme.bodyMedium?.copyWith(color: textColor),
                    ).tr(),
                  ],
                ),
                const Spacer(flex: 1),
              ],
            )
          ],
        ),
      );
    });
  }

  void close() => Navigator.of(context, rootNavigator: true).pop();
}
