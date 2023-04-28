/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findPageIconButton() => find.byType(PageIconButton);
  Finder findIcon() => find.byType(Icon);

  group("Action", () {
    testWidgets("Should call [onPressed] when [PageIconButton] is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
            child: Scaffold(
          body: PageIconButton(
            icon: Icons.abc,
            label: "Tes",
            onPressed: () {
              isTapped = true;
            },
          ),
        ));

        await tester.tap(findPageIconButton());
        await tester.pumpAndSettle();

        expect(isTapped, true);
      });
    });
  });

  group("Icon", () {
    testWidgets("Should show icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: PageIconButton(
              icon: Icons.abc,
              label: "Tes",
            ),
          ),
        );

        Icon icon = findIcon().getFirstWidget() as Icon;

        expect(icon.icon, Icons.abc);
      });
    });

    testWidgets("Should set icon color when [iconColor] not null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: PageIconButton(
              icon: Icons.abc,
              label: "Tes",
              iconColor: Colors.red,
            ),
          ),
        );

        Icon icon = findIcon().getFirstWidget() as Icon;

        expect(icon.color, Colors.red);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show label text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: PageIconButton(
              icon: Icons.abc,
              label: "Tes",
            ),
          ),
        );

        expect(find.text("Tes"), findsOneWidget);
      });
    });
  });
}
