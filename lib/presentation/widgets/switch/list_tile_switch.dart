/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue May 09 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';

class ListTileSwitch extends StatelessWidget with UIMixin {
  const ListTileSwitch({
    required this.icon,
    required this.title,
    required this.value,
    this.onChanged,
    this.subtitle,
    this.iconColor,
    this.borderRadius,
    this.padding,
    this.switchKey,
    super.key,
  });

  final Key? switchKey;
  final String title;
  final String? subtitle;
  final bool value;
  final Function(bool value)? onChanged;
  final IconData icon;
  final Color? iconColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(kDefaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 30,
                ),
                const SizedBox(width: kDefaultSpacing),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(width: kDefaultSpacing),
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  key: switchKey,
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                maxLines: 2,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
