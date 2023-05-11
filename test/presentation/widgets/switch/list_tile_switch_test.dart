/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findCupertinoSwitch() => find.byType(CupertinoSwitch);
  Finder findIcon() => find.byType(Icon);

  group("Switch", () {
    testWidgets("Should call [onChanged] when [CupertinoSwitch] is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool value = false;

        await tester.pumpApp(
            child: Scaffold(
          body: ListTileSwitch(
            title: "Test",
            icon: Icons.abc,
            value: value,
            onChanged: (val) {
              value = val;
            },
          ),
        ));

        await tester.tap(findCupertinoSwitch());
        await tester.pumpAndSettle();

        expect(value, true);
      });
    });
  });

  group("Icon", () {
    testWidgets("Should show icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: ListTileSwitch(
              title: "Test",
              icon: Icons.abc,
              value: false,
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
            body: ListTileSwitch(
              icon: Icons.abc,
              title: "Test",
              iconColor: Colors.red,
              value: false,
            ),
          ),
        );

        Icon icon = findIcon().getFirstWidget() as Icon;

        expect(icon.color, Colors.red);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show title text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: ListTileSwitch(
              icon: Icons.abc,
              title: "Test",
              iconColor: Colors.red,
              value: false,
            ),
          ),
        );

        expect(find.text("Test"), findsOneWidget);
      });
    });

    testWidgets("Should show subtitle text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: ListTileSwitch(
              icon: Icons.abc,
              title: "Test",
              subtitle: "subtitle",
              iconColor: Colors.red,
              value: false,
            ),
          ),
        );

        expect(find.text("Test"), findsOneWidget);
        expect(find.text("subtitle"), findsOneWidget);
      });
    });
  });
}
