/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/core.dart';
import '../../../config/config.dart';
import '../shadow/shadow.dart';

class AccountCard extends _AccountCardWrapper {
  const AccountCard({
    required AuthMethod authMethod,
    required String email,
    VoidCallback? onTap,
    Key? key,
  }) : super(
          authMethod: authMethod,
          email: email,
          isDefault: true,
          onTap: onTap,
          key: key,
        );

  const AccountCard.large({
    required AuthMethod authMethod,
    required String email,
    Key? key,
  }) : super(
          authMethod: authMethod,
          email: email,
          isDefault: false,
          key: key,
        );
}

class _AccountCardWrapper extends StatelessWidget {
  const _AccountCardWrapper({
    required this.isDefault,
    required this.email,
    required this.authMethod,
    this.onTap,
    super.key,
  });

  final bool isDefault;
  final String email;
  final AuthMethod authMethod;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isDefault) {
      return _DefaultAccountCard(
        authMethod: authMethod,
        email: email,
        ontap: onTap,
      );
    } else {
      return _LargeAccountCard(
        authMethod: authMethod,
        email: email,
      );
    }
  }
}

class _LargeAccountCard extends StatelessWidget {
  const _LargeAccountCard({
    required this.authMethod,
    required this.email,
  }) : super(key: const Key("account_card_large"));

  final AuthMethod authMethod;
  final String email;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        authMethod == AuthMethod.apple ? _buildIconApple() : _buildIconGoogle(),
        const SizedBox(height: kDefaultSpacing),
        Text(
          authMethod.name.capitalizeFirst,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: brightness == Brightness.dark
                    ? AppColors.fontPalletsDark[2]
                    : AppColors.fontPalletsLight[2],
              ),
          maxLines: 1,
        ),
        Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: brightness == Brightness.dark
                    ? AppColors.fontPalletsDark[0]
                    : AppColors.fontPalletsLight[0],
              ),
        ),
      ],
    );
  }

  Widget _buildIconGoogle() {
    return _circleAvatar(
      key: const Key("account_card_google_icon"),
      color: Colors.white,
      child: Image.asset(
        ImageRaster.googleLogo,
        width: 38,
      ),
    );
  }

  Widget _buildIconApple() {
    return _circleAvatar(
      key: const Key("account_card_apple_icon"),
      color: Colors.white,
      child: const Icon(
        FontAwesomeIcons.apple,
        color: Colors.black,
        size: 40,
      ),
    );
  }

  Widget _circleAvatar({
    required Widget child,
    required Color color,
    Key? key,
  }) {
    return Container(
      key: key,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          SoftShadow(
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _DefaultAccountCard extends StatelessWidget {
  const _DefaultAccountCard({
    required this.authMethod,
    required this.email,
    this.ontap,
  }) : super(key: const Key("account_card_default"));

  final AuthMethod authMethod;
  final String email;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            authMethod == AuthMethod.apple
                ? _buildIconApple()
                : _buildIconGoogle(),
            const SizedBox(width: kDefaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.account,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                  ).tr(),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGoogle() {
    return CircleAvatar(
      key: const Key("account_card_google_icon"),
      radius: 18,
      backgroundColor: Colors.white,
      child: Image.asset(
        ImageRaster.googleLogo,
        width: 18,
      ),
    );
  }

  Widget _buildIconApple() {
    return const CircleAvatar(
      key: Key("account_card_apple_icon"),
      backgroundColor: Colors.white,
      radius: 18,
      child: Icon(
        FontAwesomeIcons.apple,
        color: Colors.black,
        size: 18,
      ),
    );
  }
}
