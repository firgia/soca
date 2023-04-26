/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../style/style.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressedAllow,
    this.iconColor,
    this.allowButtonKey,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onPressedAllow;
  final Key? allowButtonKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing / 2),
      child: Container(
        width: 200,
        height: 250,
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Column(
          children: [
            _buildIcon(),
            const Spacer(flex: 3),
            _buildTitle(context),
            _buildSubtitle(context),
            const Spacer(flex: 3),
            _buildAllowButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      icon,
      color: iconColor,
      size: 60,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAllowButton(BuildContext context) {
    return ElevatedButton(
      key: allowButtonKey,
      onPressed: onPressedAllow,
      style: OutlinedButtonStyle(
        size: ButtonSize.small,
        expanded: true,
        color: AppColors.fontPallets[1],
      ),
      child: const Text(LocaleKeys.allow).tr(),
    );
  }
}
