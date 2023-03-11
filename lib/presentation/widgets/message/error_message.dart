/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../style/style.dart';
import '../utility/utility.dart';

enum _ErrorType {
  authentication,
  internet,
  something,
}

class ErrorMessage extends _GeneratorWidget {
  const ErrorMessage.internetError({
    VoidCallback? onActionPressed,
  }) : super(
          type: _ErrorType.internet,
          onActionPressed: onActionPressed,
        );

  const ErrorMessage.somethingError({
    String? title,
    String? body,
    String? errorCode,
    VoidCallback? onActionPressed,
  }) : super(
          type: _ErrorType.something,
          title: title,
          body: body,
          errorCode: errorCode,
          onActionPressed: onActionPressed,
        );

  const ErrorMessage.authenticationError({
    String? title,
    String? body,
    String? errorCode,
    VoidCallback? onActionPressed,
  }) : super(
          type: _ErrorType.authentication,
          title: title,
          body: body,
          errorCode: errorCode,
          onActionPressed: onActionPressed,
        );

  static double get height => 450.0;
}

class _GeneratorWidget extends StatelessWidget {
  const _GeneratorWidget({
    required this.type,
    this.body,
    this.title,
    this.onActionPressed,
    this.errorCode,
  });

  final _ErrorType type;
  final String? title;
  final String? body;
  final VoidCallback? onActionPressed;
  final String? errorCode;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _ErrorType.authentication:
        return _AuthenticationError(
          key: const Key("error_message_authentication_error"),
          title: title,
          body: body,
          errorCode: errorCode,
          onActionPressed: onActionPressed,
        );
      case _ErrorType.internet:
        return _InternetError(
          key: const Key("error_message_internet_error"),
          onActionPressed: onActionPressed,
        );

      case _ErrorType.something:
        return _SomethingError(
          key: const Key("error_message_something_error"),
          title: title,
          body: body,
          errorCode: errorCode,
          onActionPressed: onActionPressed,
        );
      default:
        return const SizedBox();
    }
  }
}

class _InternetError extends StatelessWidget {
  const _InternetError({
    this.onActionPressed,
    super.key,
  });

  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ErrorMessage.height,
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
      ImageAnimation.disconnected,
      height: 200,
      width: 200,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      LocaleKeys.error_check_your_connection,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(color: AppColors.fontPallets[0]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    ).tr();
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      LocaleKeys.error_check_your_connection_desc,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.fontPallets[1],
          ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).tr();
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: onActionPressed,
      style: FlatButtonStyle(expanded: true, primary: AppColors.red),
      child: const Text(LocaleKeys.ok).tr(),
    );
  }
}

class _SomethingError extends StatelessWidget {
  const _SomethingError({
    this.onActionPressed,
    this.title,
    this.body,
    this.errorCode,
    super.key,
  });

  final String? title;
  final String? body;
  final String? errorCode;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ErrorMessage.height,
      child: BrightnessBuilder(builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * 2),
          child: Column(
            children: [
              _buildAnimation(),
              _buildTitle(context),
              const SizedBox(height: kDefaultSpacing / 2),
              _buildSubtitle(context),
              if (errorCode != null) const SizedBox(height: kDefaultSpacing),
              if (errorCode != null) _buildErrorCode(context),
              const Spacer(),
              _buildActionButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnimation() {
    return Transform.scale(
      scale: 1.5,
      child: LottieBuilder.asset(
        ImageAnimation.monsterError,
        height: 200,
        width: 200,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title ?? LocaleKeys.error_something_wrong.tr(),
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.fontPallets[0],
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      body ?? LocaleKeys.error_something_wrong_desc.tr(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.fontPallets[1],
          ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildErrorCode(BuildContext context) {
    if (errorCode == null) {
      return const SizedBox();
    } else {
      return Text(
        "($errorCode)",
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.fontPallets[2],
            ),
      );
    }
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: onActionPressed,
      style: FlatButtonStyle(expanded: true, primary: AppColors.red),
      child: const Text(LocaleKeys.ok).tr(),
    );
  }
}

class _AuthenticationError extends StatelessWidget {
  const _AuthenticationError({
    this.onActionPressed,
    this.title,
    this.body,
    this.errorCode,
    super.key,
  });

  final String? title;
  final String? body;
  final String? errorCode;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ErrorMessage.height,
      child: BrightnessBuilder(builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * 2),
          child: Column(
            children: [
              _buildAnimation(),
              _buildTitle(context),
              const SizedBox(height: kDefaultSpacing / 2),
              _buildSubtitle(context),
              if (errorCode != null) const SizedBox(height: kDefaultSpacing),
              if (errorCode != null) _buildErrorCode(context),
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
      ImageAnimation.fingerprintFailed,
      height: 200,
      width: 200,
      repeat: false,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title ?? LocaleKeys.error_auth.tr(),
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.fontPallets[0],
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      body ?? LocaleKeys.error_signed_in.tr(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.fontPallets[1],
          ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildErrorCode(BuildContext context) {
    if (errorCode == null) {
      return const SizedBox();
    } else {
      return Text(
        "($errorCode)",
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.fontPallets[2],
            ),
      );
    }
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: onActionPressed,
      style: FlatButtonStyle(expanded: true, primary: AppColors.red),
      child: const Text(LocaleKeys.ok).tr(),
    );
  }
}
