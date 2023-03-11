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
import 'package:soca/config/config.dart';
import 'sign_in_button.dart';
import '../utility/utility.dart';

class SignInWithAppleButton extends StatelessWidget {
  const SignInWithAppleButton({required this.onPressed, Key? key})
      : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, brightness) {
      final isDarkMode = brightness == Brightness.dark;

      return SignInButton(
        onPressed: onPressed,
        icon: Icon(
          FontAwesomeIcons.apple,
          size: 26,
          color: isDarkMode ? Colors.grey[900] : Colors.white,
        ),
        label: const Text(LocaleKeys.sign_in_with_apple).tr(),
        primaryColor: isDarkMode ? Colors.white : Colors.grey[900],
        onPrimaryColor: isDarkMode ? Colors.grey[900] : Colors.white,
      );
    });
  }
}
