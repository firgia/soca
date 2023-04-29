/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../image/image.dart';

class CallItem extends StatelessWidget {
  const CallItem(this.data, {super.key});

  final CallHistory data;

  @override
  Widget build(BuildContext context) {
    final nameText = data.remoteUser?.name;

    return Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: kDefaultSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameText(context),
              _buildStateText(context, large: nameText == null),
            ],
          ),
        ),
        _buildTimeText(context),
      ],
    );
  }

  Widget _buildProfileImage() {
    final profileImage = data.remoteUser?.avatar?.fixed;

    if (profileImage == null) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.fontPallets[2].withOpacity(.1),
        child: _buildIcon(),
      );
    } else {
      return ProfileImage.network(url: profileImage);
    }
  }

  Widget _buildTimeText(BuildContext context) {
    final localCreatedAt = data.localCreatedAt;
    final localCreatedAtText =
        localCreatedAt == null ? "-" : DateFormat.Hm().format(localCreatedAt);

    return Text(
      localCreatedAtText,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }

  Widget _buildNameText(BuildContext context) {
    final nameText = data.remoteUser?.name;

    if (nameText == null) {
      return const SizedBox();
    } else {
      return Text(
        nameText,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }
  }

  Widget _buildStateText(BuildContext context, {bool large = false}) {
    final state = data.state;
    String? stateText;

    switch (state) {
      case CallState.ended:
        stateText = LocaleKeys.call_state_ended.tr();
        break;

      case CallState.endedWithCanceled:
        stateText = LocaleKeys.call_state_ended_with_canceled.tr();
        break;

      case CallState.ongoing:
        stateText = LocaleKeys.call_state_ongoing.tr();
        break;

      case CallState.waiting:
        stateText = LocaleKeys.call_state_waiting.tr();
        break;

      case CallState.endedWithUnanswered:
        stateText = LocaleKeys.call_state_ended_with_unanswered.tr();
        break;

      case CallState.endedWithDeclined:
        stateText = LocaleKeys.call_state_ended_with_declined.tr();
        break;

      default:
    }

    if (stateText == null) {
      return const SizedBox();
    } else {
      return Text(
        stateText,
        style: large
            ? Theme.of(context).textTheme.bodyLarge
            : Theme.of(context).textTheme.labelMedium,
      );
    }
  }

  Widget _buildIcon() {
    final state = data.state;
    IconData? iconData;

    switch (state) {
      case CallState.ended:
        iconData = Icons.call_end_outlined;
        break;

      case CallState.endedWithCanceled:
        iconData = Icons.call_end_outlined;
        break;

      case CallState.ongoing:
        iconData = Icons.phone_in_talk_outlined;
        break;

      case CallState.waiting:
        iconData = Icons.phone_forwarded_outlined;
        break;

      case CallState.endedWithUnanswered:
        iconData = Icons.phone_missed_outlined;
        break;

      case CallState.endedWithDeclined:
        iconData = Icons.phone_missed_outlined;
        break;

      default:
    }

    if (iconData != null) {
      return Icon(
        iconData,
        size: 20,
      );
    } else {
      return const SizedBox();
    }
  }
}
