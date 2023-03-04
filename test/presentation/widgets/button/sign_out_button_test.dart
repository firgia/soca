/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());

  tearDown(() => unregisterLocator());

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findSignOutButton() => find.byType(SignOutButton);
  Finder findSignOutText() => find.text(LocaleKeys.sign_out.tr());

  group("Action", () {
    testWidgets("Should execute [onPressed] when tap the button",
        (tester) async {
      await tester.runAsync(() async {
        bool isPressed = false;

        await tester.pumpApp(
          child: Scaffold(
            body: SignOutButton(
              onPressed: () {
                isPressed = true;
              },
            ),
          ),
        );

        await tester.tap(findSignOutButton());
        await tester.pumpAndSettle();
        expect(isPressed, true);
      });
    });
  });

  group("Loading", () {
    testWidgets("Should show the loading indicator when [isLoading] is true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: SignOutButton(isLoading: true),
          ),
        );

        expect(findAdaptiveLoading(), findsOneWidget);
      });
    });

    testWidgets("Should hide the loading indicator when [isLoading] is false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: SignOutButton(isLoading: false),
          ),
        );

        expect(findAdaptiveLoading(), findsNothing);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show sign out text when not loading", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: SignOutButton(isLoading: false),
          ),
        );

        expect(findSignOutText(), findsOneWidget);
      });
    });

    testWidgets("Should hide sign out text when loading", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: SignOutButton(isLoading: true),
          ),
        );

        expect(findSignOutText(), findsNothing);
      });
    });
  });
}
