/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../config/config.dart';

class CallVolunteerButton extends StatefulWidget {
  const CallVolunteerButton({required this.onPressed, Key? key})
      : super(key: key);

  final Function()? onPressed;

  @override
  State<CallVolunteerButton> createState() => _CallVolunteerButtonState();
}

class _CallVolunteerButtonState extends State<CallVolunteerButton> {
  bool animate = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadius),
          onTapDown: (details) {
            setState(() {
              animate = false;
            });
          },
          onTapCancel: () {
            setState(() {
              animate = true;
            });
          },
          onTap: () {
            setState(() {
              animate = true;
            });
            if (widget.onPressed != null) widget.onPressed!();
          },
          child: SizedBox(
            height: 250,
            width: double.maxFinite,
            child: Column(
              children: [
                AvatarGlow(
                  animate: animate,
                  endRadius: 100,
                  child: const Icon(
                    Icons.call,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
                Text(
                  LocaleKeys.call_volunteer.tr().capitalize,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ).copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
