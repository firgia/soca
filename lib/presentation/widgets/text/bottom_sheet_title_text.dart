/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:custom_icons/custom_icons.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../utility/utility.dart';

class BottomSheetTitleText extends StatelessWidget {
  const BottomSheetTitleText({
    required this.title,
    this.onClosePressed,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(
      builder: (context, brightness) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: Row(
            children: [
              const SizedBox(width: kDefaultSpacing),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.fontPallets[0],
                      ),
                ),
              ),
              (onClosePressed != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: IconButton(
                        key: const Key("bottom_sheet_title_text_close_button"),
                        onPressed: onClosePressed,
                        color: AppColors.fontPallets[0],
                        icon: const Icon(CustomIcons.arrow_down),
                        constraints: const BoxConstraints(),
                      ),
                    )
                  : const SizedBox(width: kDefaultSpacing),
            ],
          ),
        );
      },
    );
  }
}
