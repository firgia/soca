/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../utility/utility.dart';

class SocaIconImage extends StatelessWidget {
  const SocaIconImage({
    this.size = 200,
    this.heroTag,
    super.key,
  });

  final double size;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: _buildIconImage(),
      );
    } else {
      return _buildIconImage();
    }
  }

  Widget _buildIconImage() {
    return BrightnessBuilder(
      builder: (context, brightness) {
        final isDark = brightness == Brightness.dark;

        return Image.asset(
          isDark
              ? ImageRaster.socaIconDarkElevation
              : ImageRaster.socaIconLightElevation,
          height: size,
        );
      },
    );
  }
}
