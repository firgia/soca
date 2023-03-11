/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 03 2023
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
  Finder findCancelText() => find.text("CANCEL");
  Finder findDateOfBirthField() => find.byType(DateOfBirthField);
  Finder findDateOfBirthText() => find.text(LocaleKeys.date_of_birth.tr());
  Finder findIcon() => find.byType(Icon);
  Finder findOKText() => find.text("OK");

  group("Action", () {
    testWidgets(
        "Should show [DatePickerDialog] when tap the [DateOfBirthField]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: TextEditingController(),
              onChanged: (date) {},
            ),
          ),
        );

        Finder selectDate = find.byType(DatePickerDialog);
        expect(selectDate, findsNothing);
        await tester.tap(findDateOfBirthField());
        await tester.pumpAndSettle();
        expect(selectDate, findsOneWidget);
      });
    });

    testWidgets("Should call [onChanged] when tap ok on [DatePickerDialog]",
        (tester) async {
      await tester.runAsync(() async {
        DateTime? selected;

        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: TextEditingController(),
              onChanged: (date) {
                selected = date;
              },
            ),
          ),
        );

        await tester.tap(findDateOfBirthField());
        await tester.pumpAndSettle();
        await tester.tap(findOKText());
        await tester.pumpAndSettle();

        expect(selected, isNotNull);
      });
    });

    testWidgets(
        "Should not call [onChanged] when tap cancel on [DatePickerDialog]",
        (tester) async {
      await tester.runAsync(() async {
        DateTime? selected;

        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: TextEditingController(),
              onChanged: (date) {
                selected = date;
              },
            ),
          ),
        );

        await tester.tap(findDateOfBirthField());
        await tester.pumpAndSettle();
        await tester.tap(findCancelText());
        await tester.pumpAndSettle();

        expect(selected, isNull);
      });
    });

    testWidgets("Should set the controller text when date is selected",
        (tester) async {
      await tester.runAsync(() async {
        DateTime? selected;
        TextEditingController controller = TextEditingController();

        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: controller,
              onChanged: (date) {
                selected = date;
              },
            ),
          ),
        );

        expect(controller.text, isEmpty);
        await tester.tap(findDateOfBirthField());
        await tester.pumpAndSettle();
        await tester.tap(findOKText());
        await tester.pumpAndSettle();
        expect(selected, isNotNull);
        expect(controller.text, selected!.formatdMMMMY());
      });
    });
  });

  group("icon", () {
    testWidgets("Should show icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: TextEditingController(),
              onChanged: (date) {},
            ),
          ),
        );

        expect(findIcon(), findsOneWidget);
      });
    });
  });

  group("Hint", () {
    testWidgets("Should show date of birth hint text when inpus is empty",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: DateOfBirthField(
              controller: TextEditingController(),
              onChanged: (date) {},
            ),
          ),
        );

        expect(findDateOfBirthText(), findsOneWidget);
      });
    });

    // TODO: This test getting failed because a flutter issue
    // More details: https://github.com/flutter/flutter/issues/26336
    // testWidgets("Should hide date of birth hint text when inpus is not empty",
    //     (tester) async {
    //   await tester.runAsync(() async {
    //     TextEditingController controller = TextEditingController();

    //     await tester.pumpApp(
    //       child: Scaffold(
    //         body: NameField(controller: controller),
    //       ),
    //     );

    //     await tester.enterText(find.byType(NameField), "Firgia");
    //     await tester.pumpAndSettle();
    //     await tester.pump();

    //     expect(find.text(LocaleKeys.name.tr()), findsNothing);
    //     expect(
    //         find.bySemanticsLabel(LocaleKeys.tf_name_change_conditions
    //             .tr(namedArgs: {'min': "4", 'max': '25'})),
    //         findsNothing);

    //     expect(controller.text, "Firgia");
    //   });
    // });
  });
}
