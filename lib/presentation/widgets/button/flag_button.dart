/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class FlagButton extends StatelessWidget {
  const FlagButton({
    required this.language,
    required this.onTap,
    required this.selected,
    Key? key,
  }) : super(key: key);

  final DeviceLanguage language;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: selected ? .4 : 1,
          child: GestureDetector(
            onTap: selected ? null : onTap,
            child: AbsorbPointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    key: const Key("flag_button_image"),
                    image: language.getImage(),
                    width: 50,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    language.getNativeName(),
                    key: const Key("flag_button_text"),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selected)
          Positioned(
            key: const Key("flag_button_check_icon"),
            top: 45,
            right: 20,
            child: Icon(
              Icons.check,
              color: AppColors.green,
            ),
          ),
      ],
    );
  }
}
