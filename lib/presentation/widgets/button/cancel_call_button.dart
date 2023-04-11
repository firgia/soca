/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../loading/loading.dart';

class CancelCallButton extends StatelessWidget {
  const CancelCallButton({
    required this.onPressed,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AvatarGlow(
          endRadius: 100,
          glowColor: Colors.red,
          child: Transform.scale(
            scale: 1.4,
            child: FloatingActionButton(
              onPressed: isLoading ? null : onPressed,
              heroTag: null,
              backgroundColor: Colors.red,
              child: isLoading
                  ? const AdaptiveLoading(
                      color: Colors.white,
                      radius: 14,
                    )
                  : const Icon(
                      Icons.call_end_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(top: 120),
          child: const Text(
            LocaleKeys.cancel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ).tr(),
        ),
      ],
    );
  }
}
