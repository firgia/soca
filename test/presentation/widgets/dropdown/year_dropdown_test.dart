/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findDropdown() => find.byType(DropdownButton<String>);

  group("Action", () {
    testWidgets("Should select item", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: YearDropdown(
              value: "2020",
              items: [
                "2020",
                "2023",
              ],
            ),
          ),
        );

        expect(
          find.text("2020"),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should call [onChanged] when item is selected",
        (tester) async {
      await tester.runAsync(() async {
        String? selected;

        await tester.pumpApp(
          child: Scaffold(
            body: YearDropdown(
              onChanged: (value) {
                selected = value;
              },
              value: "2020",
              items: const [
                "2020",
                "2023",
              ],
            ),
          ),
        );

        await tester.tap(find.text("2020"));
        await tester.pumpAndSettle();

        await tester.tap(find.text("2023").last);
        await tester.pumpAndSettle();

        expect(
          selected,
          "2023",
        );
      });
    });
  });

  group("Dropdown Visibility", () {
    testWidgets("Should show Dropdown when items is not empty", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: YearDropdown(
              items: [
                "a",
                "b",
              ],
            ),
          ),
        );

        expect(
          findDropdown(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should not show Dropdown when items is empty", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: YearDropdown(
              items: [],
            ),
          ),
        );

        expect(
          findDropdown(),
          findsNothing,
        );
      });
    });
  });
}
