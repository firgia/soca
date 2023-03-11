/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../loading/loading.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.colors,
    this.size = ButtonSize.medium,
    this.width,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.onPrimary,
    Key? key,
  }) : super(key: key);

  final String label;
  final Widget? icon;
  final List<Color>? colors;
  final Function()? onPressed;
  final bool isLoading;
  final ButtonSize size;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? onPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: onPressed == null ? AppColors.disableButtonBackground : null,
        gradient: onPressed == null
            ? null
            : LinearGradient(
                colors: colors ??
                    [
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).primaryColor,
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
          splashColor: onPrimary?.withOpacity(.3),
          highlightColor: onPrimary?.withOpacity(.1),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            padding: (size == ButtonSize.small)
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                : (size == ButtonSize.medium)
                    ? const EdgeInsets.symmetric(horizontal: 22, vertical: 14)
                    : const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: isLoading ? _buildLoading() : _buildLabel(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    double radius = (size == ButtonSize.small)
        ? 8
        : (size == ButtonSize.medium)
            ? 11
            : 13;

    return AdaptiveLoading(
      radius: radius,
      color: Colors.white,
    );
  }

  Widget _buildLabel() {
    final text = Text(
      label,
      style: TextStyle(
        color: onPressed == null
            ? AppColors.disableButtonForeground
            : onPrimary ?? Colors.white,
        fontSize: (size == ButtonSize.small)
            ? 12
            : (size == ButtonSize.medium)
                ? 15
                : 18,
        fontWeight:
            (size == ButtonSize.large) ? FontWeight.w700 : FontWeight.w600,
        letterSpacing: .2,
      ),
      maxLines: 1,
    );

    if (icon == null) {
      return text;
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: kDefaultSpacing / 2),
          Flexible(
            fit: FlexFit.loose,
            child: text,
          ),
        ],
      );
    }
  }
}
