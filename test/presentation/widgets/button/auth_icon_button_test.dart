/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';

void main() {
  group("Icon", () {
    testWidgets("Should show apple icon when [type] is AuthMethod.apple",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: AuthIconButton(type: AuthMethod.apple),
          ),
        );

        expect(find.byKey(const Key("auth_icon_apple")), findsOneWidget);
        expect(find.byKey(const Key("auth_icon_google")), findsNothing);
      });
    });

    testWidgets("Should show google icon when [type] is AuthMethod.google",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: AuthIconButton(type: AuthMethod.google),
          ),
        );

        expect(find.byKey(const Key("auth_icon_google")), findsOneWidget);
        expect(find.byKey(const Key("auth_icon_apple")), findsNothing);
      });
    });
  });

  group("Action", () {
    testWidgets("Should exceute [onTap] when tap the icon button",
        (tester) async {
      await tester.runAsync(() async {
        bool isTap = false;

        await tester.pumpApp(
          child: Scaffold(
            body: AuthIconButton(
              type: AuthMethod.apple,
              ontap: () {
                isTap = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(AuthIconButton));
        await tester.pumpAndSettle();
        expect(isTap, true);
      });
    });
  });
}
