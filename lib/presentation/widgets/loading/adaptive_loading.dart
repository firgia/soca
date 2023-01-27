/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AdaptiveLoading extends StatelessWidget {
  const AdaptiveLoading({
    this.radius = 12,
    this.platform = AdaptivePlatform.automatically,
    this.color,
    Key? key,
  }) : super(key: key);

  final double radius;
  final Color? color;
  final AdaptivePlatform platform;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (platform == AdaptivePlatform.android)
          ? _buildAndroid()
          : (platform == AdaptivePlatform.ios)
              ? _buildIOS()
              : (Platform.isIOS)
                  ? _buildIOS()
                  : _buildAndroid(),
    );
  }

  Widget _buildIOS() {
    return CupertinoActivityIndicator(
      radius: radius,
      color: color,
    );
  }

  Widget _buildAndroid() {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CircularProgressIndicator(
        strokeWidth: radius / 5,
        color: color,
      ),
    );
  }
}
