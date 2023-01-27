/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({this.color, this.onPressed, Key? key})
      : super(key: key);

  final Color? color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    if (AppNavigator.canPop(context)) {
      return IconButton(
        onPressed: onPressed ?? () => AppNavigator.back(context),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: color,
        ),
        tooltip: LocaleKeys.back.tr(),
      );
    } else {
      return const SizedBox();
    }
  }
}
