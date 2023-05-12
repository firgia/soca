/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../widgets/widgets.dart';

part 'call_ended_screen.component.dart';

class CallEndedScreen extends StatefulWidget {
  const CallEndedScreen({required this.userType, super.key});

  final UserType userType;

  @override
  State<CallEndedScreen> createState() => _CallEndedScreenState();
}

class _CallEndedScreenState extends State<CallEndedScreen> {
  DeviceFeedback deviceFeedback = sl<DeviceFeedback>();
  bool hasPlayPageInfo = false;
  late UserType userType;

  @override
  void initState() {
    super.initState();
    userType = widget.userType;
  }

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
                const _CallEndedText(),
                const Spacer(flex: 2),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const _IllustrationImage(),
                    _CallEndedCountdown(
                      duration: const Duration(seconds: 6),
                      onEnded: () => sl<AppNavigator>().goToHome(context),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                _CallEndedInfoText(userType),
                const Spacer(flex: 2),
                const _OkButton(),
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
          LocaleKeys.call_ended.tr(),
          userType == UserType.blind
              ? LocaleKeys.call_ended_blind_info.tr()
              : LocaleKeys.call_ended_volunteer_info.tr(),
        ],
        context,
        immediately: true,
      );
    }
  }
}
