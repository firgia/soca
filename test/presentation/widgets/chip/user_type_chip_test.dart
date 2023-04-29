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
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findUserTypeText() => find.byKey(const Key("user_type_chip_text"));
  Finder findBlindText() => find.text(LocaleKeys.blind.tr());
  Finder findBlindIcon() => find.byKey(const Key("user_type_chip_blind_icon"));
  Finder findVolunteerIcon() =>
      find.byKey(const Key("user_type_chip_volunteer_icon"));
  Finder findVolunteerText() => find.text(LocaleKeys.volunteer.tr());

  group("Icon", () {
    testWidgets("Should hide icon user type when user type is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(),
          ),
        );

        expect(findBlindIcon(), findsNothing);
        expect(findVolunteerIcon(), findsNothing);
      });
    });

    testWidgets("Should show blind icon when userType is blind",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(
              userType: UserType.blind,
            ),
          ),
        );

        expect(findBlindIcon(), findsOneWidget);
        expect(findVolunteerIcon(), findsNothing);
      });
    });

    testWidgets("Should show volunteer icon when userType is volunteer",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(
              userType: UserType.volunteer,
            ),
          ),
        );

        expect(findBlindIcon(), findsNothing);
        expect(findVolunteerIcon(), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show blind text when usertype is blind",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(
              userType: UserType.blind,
            ),
          ),
        );

        expect(findBlindText(), findsOneWidget);
        expect(findVolunteerText(), findsNothing);
        expect(findUserTypeText(), findsOneWidget);
      });
    });

    testWidgets("Should show volunteer text when usertype is volunteer",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(
              userType: UserType.volunteer,
            ),
          ),
        );

        expect(findBlindText(), findsNothing);
        expect(findVolunteerText(), findsOneWidget);
        expect(findUserTypeText(), findsOneWidget);
      });
    });

    testWidgets("Should hide user type text when userType is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: UserTypeChip(),
          ),
        );
        expect(findBlindText(), findsNothing);
        expect(findVolunteerText(), findsNothing);
        expect(findUserTypeText(), findsNothing);
      });
    });
  });
}
