/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class OutlinedButtonStyle extends ButtonStyle {
  static Color defaultPrimary = AppColors.lightBlue;

  OutlinedButtonStyle({
    Color? color,
    BorderRadius? borderRadius,
    ButtonSize size = ButtonSize.medium,
    TextStyle? textStyle,
    bool expanded = false,
  }) : super(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.any((element) => element == MaterialState.disabled)
                    ? AppColors.disableButtonForeground
                    : color ?? defaultPrimary,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(kBorderRadius),
            ),
          ),
          side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.any((element) => element == MaterialState.disabled)
                  ? AppColors.disableButtonForeground.withOpacity(.4)
                  : color ?? defaultPrimary,
            ),
          ),
          overlayColor: MaterialStateProperty.all(
            color?.withOpacity(.2) ?? defaultPrimary.withOpacity(.2),
          ),
          textStyle: MaterialStateProperty.all(
            textStyle?.copyWith(
                  fontSize: (size == ButtonSize.small)
                      ? 12
                      : (size == ButtonSize.medium)
                          ? 15
                          : 18,
                  fontFamily: AppFont.poppins,
                ) ??
                TextStyle(
                  fontSize: (size == ButtonSize.small)
                      ? 12
                      : (size == ButtonSize.medium)
                          ? 15
                          : 18,
                  fontWeight: (size == ButtonSize.large)
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: .2,
                  fontFamily: AppFont.poppins,
                ),
          ),
          minimumSize: MaterialStateProperty.all(
            (size == ButtonSize.small)
                ? Size(expanded ? double.infinity : 60, 20)
                : (size == ButtonSize.medium)
                    ? Size(expanded ? double.infinity : 80, 35)
                    : Size(expanded ? double.infinity : 100, 60),
          ),
          padding: MaterialStateProperty.all(
            (size == ButtonSize.small)
                ? const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  )
                : (size == ButtonSize.medium)
                    ? const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      )
                    : const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
}

class FlatButtonStyle extends _SolidButtonStyle {
  FlatButtonStyle({
    Color? primary,
    Color? onPrimary,
    BorderRadius? borderRadius,
    ButtonSize size = ButtonSize.medium,
    TextStyle? textStyle,
    bool expanded = false,
  }) : super(
          useElevation: false,
          primary: primary,
          onPrimary: onPrimary,
          borderRadius: borderRadius,
          size: size,
          textStyle: textStyle,
          expanded: expanded,
        );
}

class RaisedButtonStyle extends _SolidButtonStyle {
  RaisedButtonStyle({
    Color? primary,
    Color? onPrimary,
    BorderRadius? borderRadius,
    ButtonSize size = ButtonSize.medium,
    TextStyle? textStyle,
    bool expanded = false,
  }) : super(
          useElevation: true,
          primary: primary,
          onPrimary: onPrimary,
          borderRadius: borderRadius,
          size: size,
          textStyle: textStyle,
          expanded: expanded,
        );
}

class _SolidButtonStyle extends ButtonStyle {
  static const Color _onPrimaryColor = Colors.white;
  static Color defaultPrimary = AppColors.lightBlue;

  _SolidButtonStyle({
    Color? primary,
    Color? onPrimary,
    BorderRadius? borderRadius,
    ButtonSize size = ButtonSize.medium,
    TextStyle? textStyle,
    required bool expanded,
    required bool useElevation,
  }) : super(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.any((element) => element == MaterialState.disabled)
                    ? AppColors.disableButtonBackground
                    : primary ?? defaultPrimary,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.any((element) => element == MaterialState.disabled)
                    ? AppColors.disableButtonForeground
                    : onPrimary ?? _onPrimaryColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(kBorderRadius),
            ),
          ),
          overlayColor: MaterialStateProperty.all(
            onPrimary?.withOpacity(.2) ?? _onPrimaryColor.withOpacity(.2),
          ),
          textStyle: MaterialStateProperty.all(
            textStyle?.copyWith(
                  fontSize: (size == ButtonSize.small)
                      ? 12
                      : (size == ButtonSize.medium)
                          ? 15
                          : 18,
                  fontFamily: AppFont.poppins,
                ) ??
                TextStyle(
                  fontSize: (size == ButtonSize.small)
                      ? 12
                      : (size == ButtonSize.medium)
                          ? 15
                          : 18,
                  fontWeight: (size == ButtonSize.large)
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: .2,
                  fontFamily: AppFont.poppins,
                ),
          ),
          minimumSize: MaterialStateProperty.all(
            (size == ButtonSize.small)
                ? Size(expanded ? double.infinity : 60, 20)
                : (size == ButtonSize.medium)
                    ? Size(expanded ? double.infinity : 80, 35)
                    : Size(expanded ? double.infinity : 100, 60),
          ),
          padding: MaterialStateProperty.all(
            (size == ButtonSize.small)
                ? const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  )
                : (size == ButtonSize.medium)
                    ? const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      )
                    : const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: !useElevation
              ? null
              : MaterialStateProperty.resolveWith((states) =>
                  states.any((element) => element == MaterialState.pressed)
                      ? (size == ButtonSize.small)
                          ? 5
                          : (size == ButtonSize.medium)
                              ? 8
                              : 10
                      : 0),
        );
}
