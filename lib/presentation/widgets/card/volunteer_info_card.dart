/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';

class VolunteerInfoCard extends StatelessWidget {
  const VolunteerInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Row(
          children: [
            LottieBuilder.asset(
              ImageAnimation.comment,
              height: 55,
            ),
            const SizedBox(width: kDefaultSpacing),
            Expanded(
              child: Text(
                LocaleKeys.no_call_data_yet_volunteer_desc,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
