/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utility/utility.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    this.child,
    this.width = double.maxFinite,
    this.height = 50,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final double width;
  final double height;
  final bool enabled;
  final Duration period;
  final ShimmerDirection direction;
  final int loop;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(5),
      child: BrightnessBuilder(builder: (context, brightness) {
        bool isDark = brightness == Brightness.dark;

        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[850]! : Colors.grey[200]!,
          enabled: true,
          direction: direction,
          loop: loop,
          period: period,
          child: child ??
              Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
        );
      }),
    );
  }
}
