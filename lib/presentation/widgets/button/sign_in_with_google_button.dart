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
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../utility/utility.dart';
import 'sign_in_button.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    required this.onPressed,
    this.reverseBrightnessColor = false,
    super.key,
  });

  final Function() onPressed;
  final bool reverseBrightnessColor;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, brightness) {
      final isDarkMode = brightness == Brightness.dark;

      Color? primaryColor = isDarkMode ? Colors.white : Colors.grey[900];
      Color? onPrimaryColor = isDarkMode ? Colors.grey[900] : Colors.white;

      return SignInButton(
        onPressed: onPressed,
        icon: Image.asset(
          ImageRaster.googleLogo,
          width: 26,
        ),
        label: const Text(LocaleKeys.sign_in_with_google).tr(),
        primaryColor: !reverseBrightnessColor ? primaryColor : onPrimaryColor,
        onPrimaryColor: !reverseBrightnessColor ? onPrimaryColor : primaryColor,
      );
    });
  }
}
