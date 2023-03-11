/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../core/core.dart';
import '../../../config/config.dart';
import '../utility/utility.dart';

class IllustrationCardButton extends StatelessWidget with UIMixin {
  const IllustrationCardButton({
    this.selected = false,
    required this.onPressed,
    required this.vectorAsset,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final bool selected;
  final Function() onPressed;
  final String vectorAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Row(
              children: [
                _buildIllustration(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        BrightnessBuilder(builder: (context, _) {
                          return Text(
                            subtitle,
                            style: Theme.of(context).textTheme.labelMedium,
                            maxLines: 3,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selected)
          Container(
            key: const Key("illustration_card_button_check_animation_icon"),
            alignment: Alignment.topRight,
            child: LottieBuilder.asset(
              ImageAnimation.check,
              height: 40,
              repeat: false,
            ),
          ),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: isRTL(context) ? kDefaultSpacing : 0,
        left: isLTR(context) ? kDefaultSpacing : 0,
        top: kDefaultSpacing,
        bottom: kDefaultSpacing,
      ),
      height: 60,
      width: 60,
      child: Transform.scale(
        scaleX: isLTR(context) ? 1 : -1,
        child: SvgPicture.asset(vectorAsset),
      ),
    );
  }
}
