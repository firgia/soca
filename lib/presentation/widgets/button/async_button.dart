/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../loading/adaptive_loading.dart';

class AsyncButton extends _Generator {
  const AsyncButton({
    required Widget child,
    required Function()? onPressed,
    required bool isLoading,
    ButtonStyle? style,
    double loadingRadius = 11,
    Key? key,
  }) : super(
          child: child,
          isLoading: isLoading,
          onPressed: onPressed,
          loadingRadius: loadingRadius,
          key: key,
          style: style,
        );

  const AsyncButton.icon({
    required Widget icon,
    required Widget label,
    required Function()? onPressed,
    required bool isLoading,
    ButtonStyle? style,
    double loadingRadius = 11,
    Key? key,
  }) : super(
          icon: icon,
          child: label,
          isLoading: isLoading,
          onPressed: onPressed,
          loadingRadius: loadingRadius,
          key: key,
          style: style,
        );
}

class _Generator extends StatelessWidget {
  const _Generator({
    required this.onPressed,
    required this.child,
    required this.isLoading,
    this.icon,
    this.style,
    this.loadingRadius = 11,
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final ButtonStyle? style;
  final Widget child;
  final Function()? onPressed;
  final bool isLoading;
  final double loadingRadius;

  @override
  Widget build(BuildContext context) {
    return (icon != null)
        ? ElevatedButton.icon(
            icon: isLoading ? const SizedBox() : icon!,
            style: style,
            onPressed: (onPressed == null || isLoading) ? null : onPressed,
            label: (isLoading) ? AdaptiveLoading(radius: loadingRadius) : child,
          )
        : ElevatedButton(
            style: style,
            onPressed: (onPressed == null || isLoading) ? null : onPressed,
            child: (isLoading) ? AdaptiveLoading(radius: loadingRadius) : child,
          );
  }
}
