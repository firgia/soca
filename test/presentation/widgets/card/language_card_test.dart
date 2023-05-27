/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 16 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.light);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findRemoveButtonID() =>
      find.byKey(const Key("language_card_remove_button_id"));
  Finder findCustomShimmer() => find.byType(CustomShimmer);

  group("LanguageCard()", () {
    const Language language = Language(
      code: "id",
      name: "Indonesian",
      nativeName: "Bahasa Indonesia",
    );

    group("Remove Button", () {
      testWidgets("Should show remove button when [onTapRemove] is not null",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: LanguageCard(
              language,
              onTapRemove: () {},
            ),
          );

          expect(findRemoveButtonID(), findsOneWidget);
          expect(findRemoveButtonID().getWidget(), isA<IconButton>());
        });
      });

      testWidgets("Should hide remove button when [onTapRemove] is null",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const LanguageCard(language),
          );

          expect(findRemoveButtonID(), findsNothing);
        });
      });

      testWidgets("Should execute [onTapRemove] when tap remove button",
          (tester) async {
        await tester.runAsync(() async {
          bool isTap = false;

          await tester.pumpApp(
            child: LanguageCard(
              language,
              onTapRemove: () {
                isTap = true;
              },
            ),
          );

          await tester.tap(findRemoveButtonID());
          await tester.pumpAndSettle();

          expect(isTap, true);
        });
      });
    });

    group("Text", () {
      testWidgets("Should show [name] language text", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const LanguageCard(language),
          );

          expect(find.text("Indonesian"), findsOneWidget);
        });
      });

      testWidgets("Should show [nativeName] language text", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const LanguageCard(language),
          );

          expect(find.text("Bahasa Indonesia"), findsOneWidget);
        });
      });
    });
  });

  group("LanguageCard.loading()", () {
    group("Loading", () {
      testWidgets("Should show [CustomShimmer] widget", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const LanguageCard.loading(),
          );

          expect(findCustomShimmer(), findsAtLeastNWidgets(1));
        });
      });
    });
  });
}
