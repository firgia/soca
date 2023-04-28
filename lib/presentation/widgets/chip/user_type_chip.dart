/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class UserTypeChip extends StatelessWidget {
  const UserTypeChip({this.userType, Key? key}) : super(key: key);

  final UserType? userType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: AppColors.fontPallets[2],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing / 1.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userType != null)
            userType == UserType.blind
                ? _buildBlindIcon()
                : _buildVolunteerIcon(),
          if (userType != null) ...[
            const SizedBox(width: 4),
            Text(
              userType == UserType.blind
                  ? LocaleKeys.blind.tr()
                  : LocaleKeys.volunteer.tr(),
              key: const Key("user_type_chip_text"),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBlindIcon() {
    return const Icon(
      EvaIcons.eyeOffOutline,
      key: Key("user_type_chip_blind_icon"),
      size: 16,
      color: Colors.white,
    );
  }

  Widget _buildVolunteerIcon() {
    return const Icon(
      EvaIcons.eyeOutline,
      key: Key("user_type_chip_volunteer_icon"),
      size: 16,
      color: Colors.white,
    );
  }
}
