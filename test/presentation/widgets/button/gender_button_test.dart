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
  Finder findMaleText() => find.text(LocaleKeys.male.tr());
  Finder findFemaleText() => find.text(LocaleKeys.female.tr());
  Finder findGenderButton() => find.byType(GenderButton);
  Finder findGenderButtonSelected() =>
      find.byKey(const Key("gender_button_selected"));
  Finder findGenderButtonUnselected() =>
      find.byKey(const Key("gender_button_unselected"));

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

        await tester.tap(findGenderButton());
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

        await tester.tap(findGenderButton());
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

        expect(findGenderButtonSelected(), findsOneWidget);
        expect(findGenderButtonUnselected(), findsNothing);
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

        expect(findGenderButtonUnselected(), findsOneWidget);
        expect(findGenderButtonSelected(), findsNothing);
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

        expect(findMaleText(), findsOneWidget);
        expect(findFemaleText(), findsNothing);
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

        expect(findMaleText(), findsNothing);
        expect(findFemaleText(), findsOneWidget);
      });
    });
  });
}
