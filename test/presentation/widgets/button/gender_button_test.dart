/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  group("Action", () {
    testWidgets(
        "Should call [onPressed] when [GenderButton] is tapped even selected is true",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.male,
            onPressed: () {
              isTapped = true;
            },
            selected: true,
          ),
        );

        await tester.tap(find.byType(GenderButton));
        await tester.pumpAndSettle();

        expect(isTapped, true);
      });
    });

    testWidgets(
        "Should call [onPressed] when [GenderButton] is tapped even selected is false",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.male,
            onPressed: () {
              isTapped = true;
            },
            selected: false,
          ),
        );

        await tester.tap(find.byType(GenderButton));
        await tester.pumpAndSettle();

        expect(isTapped, true);
      });
    });
  });

  group("Selected", () {
    testWidgets("Should show selected UI when [selected] is true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.male,
            onPressed: () {},
            selected: true,
          ),
        );

        expect(find.byKey(const Key("gender_button_selected")), findsOneWidget);
        expect(find.byKey(const Key("gender_button_unselected")), findsNothing);
      });
    });

    testWidgets("Should show unselected UI when [selected] is false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.male,
            onPressed: () {},
            selected: false,
          ),
        );

        expect(
            find.byKey(const Key("gender_button_unselected")), findsOneWidget);
        expect(find.byKey(const Key("gender_button_selected")), findsNothing);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show male text when [gender] is [Gender.male]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.male,
            onPressed: () {},
          ),
        );

        expect(find.text(LocaleKeys.male.tr()), findsOneWidget);
        expect(find.text(LocaleKeys.female.tr()), findsNothing);
      });
    });

    testWidgets("Should show female text when [gender] is [Gender.female]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GenderButton(
            gender: Gender.female,
            onPressed: () {},
          ),
        );

        expect(find.text(LocaleKeys.male.tr()), findsNothing);
        expect(find.text(LocaleKeys.female.tr()), findsOneWidget);
      });
    });
  });
}
