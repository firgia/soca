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
import 'package:lottie/lottie.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../style/style.dart';
import '../utility/utility.dart';

enum _PermissionType {
  permanentlyDenied,
  restricted,
}

class PermissionMessage extends _PermissionMessage {
  const PermissionMessage.permanentlyDenied({
    VoidCallback? onActionPressed,
    String? captiontext,
  }) : super(
          type: _PermissionType.permanentlyDenied,
          onActionPressed: onActionPressed,
          captionText: captiontext,
        );

  const PermissionMessage.restricted({
    VoidCallback? onActionPressed,
    String? captiontext,
  }) : super(
          type: _PermissionType.restricted,
          onActionPressed: onActionPressed,
          captionText: captiontext,
        );

  static double get height => 450.0;
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({
    required this.type,
    this.onActionPressed,
    this.captionText,
  });

  final _PermissionType type;
  final String? captionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _PermissionType.permanentlyDenied:
        return _PermanentlyDenied(
          key: const Key("permission_message_permanently_denied"),
          onActionPressed: onActionPressed,
          caption: captionText,
        );

      case _PermissionType.restricted:
        return _Restricted(
          key: const Key("permission_message_restricted"),
          onActionPressed: onActionPressed,
          caption: captionText,
        );

      default:
        return const SizedBox();
    }
  }
}

class _PermanentlyDenied extends StatelessWidget {
  const _PermanentlyDenied({
    this.onActionPressed,
    this.caption,
    Key? key,
  }) : super(key: key);

  final String? caption;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PermissionMessage.height,
      child: BrightnessBuilder(builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * 2),
          child: Column(
            children: [
              _buildAnimation(),
              const SizedBox(height: kDefaultSpacing),
              _buildTitle(context),
              const SizedBox(height: kDefaultSpacing / 2),
              _buildSubtitle(context),
              if (caption != null) const SizedBox(height: kDefaultSpacing),
              if (caption != null) _buildCaption(context),
              const Spacer(),
              _buildActionButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnimation() {
    return LottieBuilder.asset(
      ImageAnimation.denied,
      height: 180,
      width: 180,
      repeat: false,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      LocaleKeys.permission_denied,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.fontPallets[0],
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ).tr();
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      LocaleKeys.permission_permanently_denied_desc,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.fontPallets[1],
          ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ).tr();
  }

  Widget _buildCaption(BuildContext context) {
    if (caption == null) {
      return const SizedBox();
    } else {
      return Text(
        caption!,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.fontPallets[2],
            ),
      );
    }
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      key: const Key("permission_message_settings_button"),
      onPressed: onActionPressed,
      style: FlatButtonStyle(expanded: true, primary: AppColors.red),
      child: const Text(LocaleKeys.settings).tr(),
    );
  }
}

class _Restricted extends StatelessWidget {
  const _Restricted({
    this.onActionPressed,
    this.caption,
    Key? key,
  }) : super(key: key);

  final String? caption;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PermissionMessage.height,
      child: BrightnessBuilder(builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * 2),
          child: Column(
            children: [
              _buildAnimation(),
              const SizedBox(height: kDefaultSpacing),
              _buildTitle(context),
              const SizedBox(height: kDefaultSpacing / 2),
              _buildSubtitle(context),
              if (caption != null) const SizedBox(height: kDefaultSpacing),
              if (caption != null) _buildCaption(context),
              const Spacer(),
              _buildActionButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnimation() {
    return LottieBuilder.asset(
      ImageAnimation.denied,
      height: 180,
      width: 180,
      repeat: false,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      LocaleKeys.permission_restricted,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.fontPallets[0],
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ).tr();
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      LocaleKeys.permission_restricted_desc,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.fontPallets[1],
          ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ).tr();
  }

  Widget _buildCaption(BuildContext context) {
    if (caption == null) {
      return const SizedBox();
    } else {
      return Text(
        caption!,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.fontPallets[2],
            ),
      );
    }
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      key: const Key("permission_message_ok_button"),
      onPressed: onActionPressed,
      style: FlatButtonStyle(expanded: true, primary: AppColors.red),
      child: const Text(LocaleKeys.ok).tr(),
    );
  }
}
