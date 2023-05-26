/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../widgets/widgets.dart';

part 'update_app_screen.component.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
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
          child: const Padding(
            padding: EdgeInsets.all(kDefaultSpacing * 2),
            child: Column(
              children: [
                Spacer(),
                _UpdateRequiredText(),
                Spacer(flex: 2),
                _IllustrationImage(),
                Spacer(flex: 2),
                _NewUpdateInfoText(),
                Spacer(flex: 2),
                _UpdateNotButton(),
                Spacer(),
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
          LocaleKeys.update_app_required_desc.tr(),
        ],
        context,
        immediately: true,
      );
    }
  }
}
