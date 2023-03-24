/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_icons/custom_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../chip/chip.dart';
import '../image/image.dart';
import '../loading/loading.dart';
import '../style/style.dart';

class ProfileCard extends _ProfileCardItem {
  const ProfileCard({
    required User user,
    bool? isOnline,
    VoidCallback? onTapEdit,
    super.key,
  }) : super(
          isLoading: false,
          user: user,
          isOnline: isOnline,
          onTapEdit: onTapEdit,
        );

  const ProfileCard.loading({Key? key}) : super(isLoading: true, key: key);
}

class _ProfileCardItem extends StatelessWidget {
  const _ProfileCardItem({
    required this.isLoading,
    this.user,
    this.isOnline,
    this.onTapEdit,
    super.key,
  });

  final bool isLoading;
  final User? user;
  final bool? isOnline;
  final VoidCallback? onTapEdit;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      assert(user != null, "user is required");
    }

    if (isLoading) {
      return const _ItemLoading();
    } else {
      return _Item(
        data: user!,
        isOnline: isOnline,
        onTapEdit: onTapEdit,
      );
    }
  }
}

class _Item extends StatelessWidget with UIMixin {
  const _Item({
    required this.data,
    this.isOnline,
    this.onTapEdit,
    Key? key,
  }) : super(key: key);

  final User data;
  final bool? isOnline;
  final VoidCallback? onTapEdit;

  @override
  Widget build(BuildContext context) {
    final name = data.name;
    final type = data.type;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing * 1.2),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: kDefaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null) _buildName(name, context),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (type != null)
                        _buildTypeText(
                            type == UserType.blind
                                ? LocaleKeys.blind.tr()
                                : LocaleKeys.volunteer.tr(),
                            context),
                      const SizedBox(width: kDefaultSpacing / 2),
                      GenderAgeChip(
                        gender: data.gender,
                        age: (data.dateOfBirth == null)
                            ? null
                            : Calculator.calculateAge(data.dateOfBirth!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildEditButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    if (onTapEdit == null) {
      return const SizedBox();
    } else {
      return IconButton(
        key: const Key("profile_card_edit_button"),
        onPressed: onTapEdit,
        icon: const Icon(CustomIcons.edit_square),
      );
    }
  }

  Widget _buildAvatar(BuildContext context) {
    final avatar = data.avatar?.fixed;
    final isOnline = this.isOnline ?? data.activity?.online;

    if (avatar != null) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [CustomShadow()],
        ),
        child: Stack(
          alignment:
              isLTR(context) ? Alignment.bottomLeft : Alignment.bottomRight,
          children: [
            ProfileImage(
              CachedNetworkImageProvider(avatar),
              radius: 60,
            ),
            if (isOnline != null)
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isOnline == true ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: Theme.of(context).canvasColor, width: 2),
                ),
              ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildName(String name, BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTypeText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: AppColors.fontPallets[1]),
    );
  }
}

class _ItemLoading extends StatelessWidget {
  const _ItemLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing * 1.2),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: kDefaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomShimmer(
                    height: 18,
                    width: 150,
                  ),
                  SizedBox(height: 10),
                  CustomShimmer(
                    height: 14,
                    width: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [CustomShadow()],
      ),
      child: const ProfileImage.loading(radius: 60),
    );
  }
}
