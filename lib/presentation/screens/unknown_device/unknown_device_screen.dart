/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../widgets/widgets.dart';

part 'unknown_device_screen.component.dart';

class UnknownDeviceScreen extends StatefulWidget {
  const UnknownDeviceScreen({super.key});

  @override
  State<UnknownDeviceScreen> createState() => _UnknownDeviceScreenState();
}

class _UnknownDeviceScreenState extends State<UnknownDeviceScreen> {
  DeviceFeedback deviceFeedback = sl<DeviceFeedback>();
  bool hasPlayPageInfo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playPageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing * 2),
            child: Column(
              children: [
                const Spacer(),
                const _DifferentDeviceText(),
                const Spacer(flex: 2),
                const _IllustrationImage(),
                const Spacer(flex: 2),
                const _DifferentDeviceInfoText(),
                const Spacer(flex: 2),
                _GotItButton(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void playPageInfo() {
    if (mounted && !hasPlayPageInfo) {
      hasPlayPageInfo = true;

      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.sign_in_different_device_info.tr(),
        ],
        context,
        immediately: true,
      );
    }
  }
}
