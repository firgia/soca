/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/widgets/card/volunteer_info_card.dart';

import '../../../helper/helper.dart';

void main() {
  group("Illustration", () {
    testWidgets("Should show animation illustration", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: VolunteerInfoCard(),
          ),
        );

        expect(find.byType(LottieBuilder), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show description text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: VolunteerInfoCard(),
          ),
        );

        expect(find.text(LocaleKeys.no_call_data_yet_volunteer_desc.tr()),
            findsOneWidget);
      });
    });
  });
}
