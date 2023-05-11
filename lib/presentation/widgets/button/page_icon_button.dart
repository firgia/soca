/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';

class PageIconButton extends StatelessWidget with UIMixin {
  const PageIconButton({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onPressed,
    this.borderRadius,
    this.padding,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
      ),
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
        onTap: onPressed,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(kDefaultSpacing),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              const SizedBox(width: kDefaultSpacing),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(width: kDefaultSpacing),
              Icon(
                isLTR(context) ? EvaIcons.chevronRight : EvaIcons.chevronLeft,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
