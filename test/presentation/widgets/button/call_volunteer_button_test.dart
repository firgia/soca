/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findAvatarGlow() => find.byType(AvatarGlow);

  group("Actions", () {
    testWidgets(
        "Should execute onPressed when tapped the [CallVolunteerButton]",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;

        await tester.pumpApp(
          child: Scaffold(
            body: CallVolunteerButton(onPressed: () {
              tapped = true;
            }),
          ),
        );

        await tester.tap(find.byType(CallVolunteerButton));
        expect(tapped, true);
      });
    });

    testWidgets("Should disable animation Avatar Glow when pressed",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: CallVolunteerButton(onPressed: () {}),
          ),
        );

        AvatarGlow avatarGlow = findAvatarGlow().getWidget() as AvatarGlow;
        expect(avatarGlow.animate, true);

        final Offset tapLocation =
            tester.getRect(find.byType(CallVolunteerButton)).center;
        final TestGesture gesture1 = await tester.startGesture(tapLocation);
        await tester.pumpAndSettle();

        avatarGlow = findAvatarGlow().getWidget() as AvatarGlow;
        expect(avatarGlow.animate, false);

        await gesture1.up();
        await tester.pumpAndSettle();

        avatarGlow = findAvatarGlow().getWidget() as AvatarGlow;
        expect(avatarGlow.animate, true);
      });
    });
  });

  group("Icon", () {
    testWidgets("Should show phone icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: CallVolunteerButton(onPressed: () {}),
          ),
        );

        Finder findIcon() => find.byType(Icon);
        Icon icon = findIcon().getWidget() as Icon;

        expect(findIcon(), findsOneWidget);
        expect(icon.icon, Icons.call);
      });
    });

    testWidgets("Should show Avatar Glow", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: CallVolunteerButton(onPressed: () {}),
          ),
        );

        expect(find.byType(AvatarGlow), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show text call a volunteer", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: CallVolunteerButton(onPressed: () {}),
          ),
        );

        expect(find.text(LocaleKeys.call_volunteer.tr().capitalize),
            findsOneWidget);
      });
    });
  });
}
