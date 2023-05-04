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
import '../../widgets/widgets.dart';

part 'update_app_screen.component.dart';

class UpdateAppScreen extends StatelessWidget {
  const UpdateAppScreen({super.key});

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
              children: const [
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
}
