/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipWidget extends StatelessWidget {
  const FlipWidget({
    this.flip = false,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    if (flip) {
      return Transform(
        key: const Key("flip_widget_transform"),
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: child,
      );
    } else {
      return child;
    }
  }
}
