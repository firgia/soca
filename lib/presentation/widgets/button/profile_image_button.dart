/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 23 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:custom_icons/custom_icons.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class ProfileImageButton extends StatelessWidget with UIMixin {
  const ProfileImageButton({
    required this.onTap,
    required this.fileImage,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final File? fileImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: (fileImage == null) ? _buildCamera(context) : _buildImage(context),
    );
  }

  Widget _buildCamera(BuildContext context) {
    double radius = isTablet(context) ? 50 : 40;
    double size = isTablet(context) ? 40 : 30;

    return CircleAvatar(
      key: const Key("profile_image_button_large_camera_icon"),
      radius: radius,
      backgroundColor: Theme.of(context).cardColor,
      child: Icon(
        CustomIcons.camera,
        size: size,
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (fileImage == null) {
      return const SizedBox();
    } else {
      double imageRadius = isTablet(context) ? 50 : 40;
      double circleIconRadius = isTablet(context) ? 20 : 16;
      double iconSize = isTablet(context) ? 24 : 18;

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          SizedBox(
            height: imageRadius * 2,
            width: imageRadius * 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageRadius),
              child: Image.file(fileImage!),
            ),
          ),
          CircleAvatar(
            key: const Key("profile_image_button_camera_icon"),
            radius: circleIconRadius,
            backgroundColor: Theme.of(context).canvasColor,
            child: Icon(
              CustomIcons.camera,
              size: iconSize,
              color: AppColors.fontPallets[0],
            ),
          )
        ],
      );
    }
  }
}
