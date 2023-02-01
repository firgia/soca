/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../config/config.dart';
import '../button/custom_back_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.title,
    required this.body,
    this.actions,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverPersistentHeader(
            delegate: _AppBarDelegate(
              title: title,
              actions: actions,
            ),
            pinned: true,
          ),
        ];
      },
      body: body,
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  const _AppBarDelegate({
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / maxExtent);

    double largeTitleOpacity = 1;
    double titleOpacity = 0;
    double dividerOpacity = 0;

    if (progress > .2) {
      largeTitleOpacity = 0;
      titleOpacity = progress;
    } else {
      largeTitleOpacity = 1 - progress;
    }

    if (progress > .6) {
      dividerOpacity = 1;
    } else {
      dividerOpacity = 0;
    }

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            key: const Key("custom_app_bar_large_title_opacity"),
            duration: const Duration(milliseconds: 150),
            opacity: largeTitleOpacity,
            child: Padding(
              padding: const EdgeInsets.all(kDefaultSpacing * 2),
              child: Center(
                child: _buildLargeTitleText(context),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultSpacing / 2,
                  ),
                  child: Row(
                    children: [
                      CustomBackButton(
                        color: AppColors.fontPallets[0],
                      ),
                      const SizedBox(width: kDefaultSpacing / 2),
                      Expanded(
                        child: AnimatedOpacity(
                          key: const Key("custom_app_bar_title_opacity"),
                          duration: const Duration(milliseconds: 150),
                          opacity: titleOpacity,
                          child: _buildTitleText(context),
                        ),
                      ),
                      const SizedBox(width: kDefaultSpacing),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedOpacity(
                  key: const Key("custom_app_bar_divider_opacity"),
                  opacity: dividerOpacity,
                  duration: const Duration(milliseconds: 150),
                  child: _buildDivider(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(
      width: double.maxFinite,
      child: Divider(
        height: 1,
        thickness: 1,
        indent: 0,
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).appBarTheme.titleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLargeTitleText(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            fontSize: 30,
          ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  double get maxExtent => 260;

  @override
  double get minExtent => Platform.isIOS ? 115 : 85;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
