/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:soca/injection.dart';

class BrightnessBuilder extends StatefulWidget {
  const BrightnessBuilder({required this.builder, Key? key}) : super(key: key);

  final Widget Function(BuildContext context, Brightness brightness) builder;

  @override
  State<BrightnessBuilder> createState() => _BrightnessBuilderState();
}

class _BrightnessBuilderState extends State<BrightnessBuilder>
    with WidgetsBindingObserver {
  final platformDispatcher = sl<WidgetsBinding>().platformDispatcher;

  late Brightness currentBrightness;

  @override
  void initState() {
    super.initState();

    currentBrightness = platformDispatcher.platformBrightness;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    final brightness = platformDispatcher.platformBrightness;
    if (currentBrightness != brightness) {
      setState(() {
        currentBrightness = brightness;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentBrightness);
  }
}
