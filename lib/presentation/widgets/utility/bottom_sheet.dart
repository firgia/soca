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

  Future<void> pickImage({
    VoidCallback? onTapCamera,
    VoidCallback? onTapGallery,
  }) async {
    await show(
      height: 160,
      childBuilder: (context, brightness) {
        bool isDark = brightness == Brightness.dark;

        final Color textColor = isDark
            ? AppColors.fontPalletsDark[1]
            : AppColors.fontPalletsLight[1];
        final Color iconColor = isDark
            ? AppColors.fontPalletsDark[2]
            : AppColors.fontPalletsLight[2];
        final textTheme = Theme.of(context).textTheme;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: kDefaultSpacing),
            Text(
              LocaleKeys.choose_an_image,
              style: textTheme.titleLarge?.copyWith(color: textColor),
            ).tr(),
            const SizedBox(height: kDefaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                        key: const Key(
                            "bottom_sheet_pick_image_camera_icon_button"),
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
                Column(
                  children: [
                    IconButton(
                        key: const Key(
                            "bottom_sheet_pick_image_gallery_icon_button"),
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
              ],
            )
          ],
        );
      },
    );
  }

  void close() => Navigator.of(context, rootNavigator: true).pop();
}
