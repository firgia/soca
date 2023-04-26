/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  group("Allow Button", () {
    testWidgets("Should show allow button", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: PermissionCard(
              icon: Icons.abc,
              title: "Title",
              subtitle: "Subtitle",
              onPressedAllow: () {},
              iconColor: Colors.red,
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    testWidgets("Should call [onPressedAllow] when allow button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;

        await tester.pumpApp(
          child: Scaffold(
            body: PermissionCard(
              icon: Icons.abc,
              title: "Title",
              subtitle: "Subtitle",
              onPressedAllow: () {
                tapped = true;
              },
              iconColor: Colors.red,
            ),
          ),
        );

        await tester.tap(find.text(LocaleKeys.allow.tr()));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });
  });

  group("Icon", () {
    testWidgets("Should show icon data & set color", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: PermissionCard(
              icon: Icons.abc,
              title: "Title",
              subtitle: "Subtitle",
              onPressedAllow: () {},
              iconColor: Colors.red,
            ),
          ),
        );

        Icon icon = find.byType(Icon).getWidget() as Icon;

        expect(icon.icon, Icons.abc);
        expect(icon.color, Colors.red);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show title", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: PermissionCard(
              icon: Icons.abc,
              title: "Title",
              subtitle: "Subtitle",
              onPressedAllow: () {},
              iconColor: Colors.red,
            ),
          ),
        );

        expect(find.text("Title"), findsOneWidget);
      });
    });

    testWidgets("Should show subtitle", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: PermissionCard(
              icon: Icons.abc,
              title: "Title",
              subtitle: "Subtitle",
              onPressedAllow: () {},
              iconColor: Colors.red,
            ),
          ),
        );

        expect(find.text("Subtitle"), findsOneWidget);
      });
    });
  });
}
