/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soca/config/config.dart';

class TotalCallText extends StatelessWidget {
  const TotalCallText(this.total, {super.key});

  final int total;

  @override
  Widget build(BuildContext context) {
    final messages = LocaleKeys.total_call.tr().split(" ");
    final newMessages = LocaleKeys.total_call
        .tr(namedArgs: {"total": total.toString()}).split(" ");

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: newMessages.map((msg) {
          final isExists =
              messages.where((element) => element == msg).isNotEmpty;
          final isLast = newMessages.last == msg;

          return TextSpan(
            text: isLast ? msg : "$msg ",
            style: isExists
                ? null
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.fontPallets[0],
                      fontWeight: FontWeight.w600,
                    ),
          );
        }).toList(),
      ),
    );
  }
}
