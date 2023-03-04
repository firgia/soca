/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../style/style.dart';
import 'async_button.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AsyncButton(
      isLoading: isLoading,
      onPressed: onPressed,
      style: FlatButtonStyle(primary: AppColors.red, expanded: true),
      child: const Text(LocaleKeys.sign_out).tr(),
    );
  }
}
