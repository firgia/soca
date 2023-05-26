/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:custom_icons/custom_icons.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../data/data.dart';
import '../loading/loading.dart';

class LanguageCard extends _LanguageCardItem {
  const LanguageCard(
    Language data, {
    VoidCallback? onTapRemove,
  }) : super(
          isLoading: false,
          data: data,
          onTapRemove: onTapRemove,
        );

  const LanguageCard.loading() : super(isLoading: true);
}

class _LanguageCardItem extends StatelessWidget {
  const _LanguageCardItem({
    required this.isLoading,
    this.data,
    this.onTapRemove,
  });

  final Language? data;
  final VoidCallback? onTapRemove;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      assert(data != null, "Data is required");
    }
    return !isLoading
        ? _LanguageCard(
            data!,
            onTapRemove: onTapRemove,
            key: key,
          )
        : _LanguageCardLoading(key: key);
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard(
    this.data, {
    Key? key,
    this.onTapRemove,
  });

  final Language data;
  final VoidCallback? onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("language_card_${data.code}"),
      margin: EdgeInsets.zero,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildName(context),
                  _buildNativeName(context),
                ],
              ),
            ),
            if (onTapRemove != null) const SizedBox(width: kDefaultSpacing),
            if (onTapRemove != null) _buildRemoveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return IconButton(
      key: Key("language_card_remove_button_${data.code}"),
      onPressed: onTapRemove,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      iconSize: 20,
      icon: const Icon(CustomIcons.delete),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      data.name ?? "-",
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNativeName(BuildContext context) {
    return Text(
      data.nativeName ?? "-",
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _LanguageCardLoading extends StatelessWidget {
  const _LanguageCardLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(
                    height: 16,
                    width: 100,
                  ),
                  SizedBox(height: 8),
                  CustomShimmer(
                    height: 12,
                    width: 80,
                  ),
                ],
              ),
            ),
            SizedBox(width: kDefaultSpacing),
            CustomShimmer(
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
