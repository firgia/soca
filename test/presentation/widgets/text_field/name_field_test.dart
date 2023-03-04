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
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  group("icon", () {
    testWidgets("Should show icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: NameField(controller: TextEditingController()),
          ),
        );

        expect(find.byType(Icon), findsOneWidget);
      });
    });
  });

  group("Hint", () {
    testWidgets("Should show name hint text when inpus is empty",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: NameField(controller: TextEditingController()),
          ),
        );

        expect(find.text(LocaleKeys.name.tr()), findsOneWidget);
      });
    });

    // TODO: This test getting failed because a flutter issue
    // More details: https://github.com/flutter/flutter/issues/26336
    // testWidgets("Should hide name hint text when inpus is not empty",
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

  group("Validator", () {
    Finder findErrorMessage() => find.text(LocaleKeys.tf_name_change_conditions
        .tr(namedArgs: {'min': "4", 'max': '25'}));

    testWidgets("Should show error message when input is not valid",
        (tester) async {
      await tester.runAsync(() async {
        TextEditingController controller = TextEditingController();

        await tester.pumpApp(
          child: Scaffold(
            body: NameField(controller: controller),
          ),
        );

        await tester.enterText(find.byType(NameField), "Fir");
        await tester.pumpAndSettle();
        await tester.pump();

        expect(findErrorMessage(), findsOneWidget);
        expect(controller.text, "Fir");
      });
    });

    testWidgets("Should not show error message when input is valid or empty",
        (tester) async {
      await tester.runAsync(() async {
        TextEditingController controller = TextEditingController();

        await tester.pumpApp(
          child: Scaffold(
            body: NameField(controller: controller),
          ),
        );

        await tester.enterText(find.byType(NameField), "Firgia");
        await tester.pumpAndSettle();
        await tester.pump();

        expect(findErrorMessage(), findsNothing);
        expect(controller.text, "Firgia");
      });
    });
  });
}
