/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  Finder findAppleIcon() => find.byKey(const Key("account_card_apple_icon"));
  Finder findGoogleIcon() => find.byKey(const Key("account_card_google_icon"));
  Finder findAccountCardDefault() =>
      find.byKey(const Key("account_card_default"));
  Finder findAccountCardLarge() => find.byKey(const Key("account_card_large"));

  group("AccountCard()", () {
    group("Card", () {
      testWidgets("Should show default account card", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard(
              authMethod: AuthMethod.google,
              email: "contact@firgia.com",
            ),
          );

          expect(findAccountCardDefault(), findsOneWidget);
        });
      });
    });

    group("Icon", () {
      testWidgets(
          "Should show apple icon when [authMethod] is [AuthMethod.apple]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard(
              authMethod: AuthMethod.apple,
              email: "contact@firgia.com",
            ),
          );

          expect(
            findAppleIcon(),
            findsOneWidget,
          );

          expect(
            findGoogleIcon(),
            findsNothing,
          );
        });
      });

      testWidgets(
          "Should show google icon when [authMethod] is [AuthMethod.google]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard(
              authMethod: AuthMethod.google,
              email: "contact@firgia.com",
            ),
          );

          expect(
            findGoogleIcon(),
            findsOneWidget,
          );

          expect(
            findAppleIcon(),
            findsNothing,
          );
        });
      });
    });

    group("Action", () {
      testWidgets("Should execute [onTap] when tap the icon", (tester) async {
        await tester.runAsync(() async {
          bool isTap = false;

          await tester.pumpApp(
            child: AccountCard(
              authMethod: AuthMethod.google,
              email: "contact@firgia.com",
              onTap: () {
                isTap = true;
              },
            ),
          );

          await tester.tap(findGoogleIcon());
          await tester.pumpAndSettle();

          expect(isTap, true);
        });
      });
    });
  });

  group("AccountCard.large()", () {
    group("Card", () {
      testWidgets("Should show large account card", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard.large(
              authMethod: AuthMethod.google,
              email: "contact@firgia.com",
            ),
          );

          expect(findAccountCardLarge(), findsOneWidget);
        });
      });
    });

    group("Icon", () {
      testWidgets(
          "Should show apple icon when [authMethod] is [AuthMethod.apple]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard.large(
              authMethod: AuthMethod.apple,
              email: "contact@firgia.com",
            ),
          );

          expect(
            findAppleIcon(),
            findsOneWidget,
          );

          expect(
            findGoogleIcon(),
            findsNothing,
          );
        });
      });

      testWidgets(
          "Should show google icon when [authMethod] is [AuthMethod.google]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const AccountCard.large(
              authMethod: AuthMethod.google,
              email: "contact@firgia.com",
            ),
          );

          expect(
            findGoogleIcon(),
            findsOneWidget,
          );

          expect(
            findAppleIcon(),
            findsNothing,
          );
        });
      });
    });
  });
}
