/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../style/style.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    required this.icon,
    required this.label,
    this.primaryColor,
    this.onPrimaryColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final Widget icon;
  final Widget label;
  final Color? primaryColor;
  final Color? onPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ElevatedButton.icon(
        key: const Key("sign_in_button_elevated_button"),
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: FlatButtonStyle(
          expanded: true,
          size: ButtonSize.large,
          primary: primaryColor,
          onPrimary: onPrimaryColor,
        ),
      ),
    );
  }
}
