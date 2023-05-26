/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
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

  Finder findCheckAnimationIcon() =>
      find.byKey(const Key("illustration_card_button_check_animation_icon"));
  Finder findIllustrationCardButton() => find.byType(IllustrationCardButton);
  Finder findSvgPicture() => find.byType(SvgPicture);

  group("Action", () {
    testWidgets("Should execute [onPressed] when tap the button",
        (tester) async {
      await tester.runAsync(() async {
        bool isPressed = false;

        await tester.pumpApp(
          child: Scaffold(
            body: IllustrationCardButton(
              onPressed: () {
                isPressed = true;
              },
              vectorAsset: ImageVector.greetingIllustration,
              title: "This is title text",
              subtitle: "This is subtitle text",
            ),
          ),
        );

        await tester.tap(findIllustrationCardButton());
        await tester.pumpAndSettle();

        expect(isPressed, true);
      });
    });
  });

  group("Check Icons", () {
    IllustrationCardButton buildIllustrationCardButton(
            {required bool selected}) =>
        IllustrationCardButton(
          onPressed: () {},
          vectorAsset: ImageVector.greetingIllustration,
          title: "This is title text",
          subtitle: "This is subtitle text",
          selected: selected,
        );

    testWidgets("Should show the check icon when [selected] is true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(body: buildIllustrationCardButton(selected: true)),
        );

        expect(
          findCheckAnimationIcon(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should not show the check icon when [selected] is false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(body: buildIllustrationCardButton(selected: false)),
        );

        expect(
          findCheckAnimationIcon(),
          findsNothing,
        );
      });
    });
  });

  group("Illustration Image", () {
    testWidgets("Should show vector image based on [vectorAsset]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: IllustrationCardButton(
              onPressed: () {},
              vectorAsset: ImageVector.blindIllustration,
              title: "This is title text",
              subtitle: "This is subtitle text",
            ),
          ),
        );

        SvgPicture svgPicture = findSvgPicture().getWidget() as SvgPicture;
        SvgAssetLoader svgAssetLoader =
            svgPicture.bytesLoader as SvgAssetLoader;

        expect(svgAssetLoader.assetName, ImageVector.blindIllustration);
      });
    });
  });

  group("Text", () {
    IllustrationCardButton buildIllustrationCardButton() =>
        IllustrationCardButton(
          onPressed: () {},
          vectorAsset: ImageVector.greetingIllustration,
          title: "This is title text",
          subtitle: "This is subtitle text",
        );

    testWidgets("Should show the title text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(body: buildIllustrationCardButton()),
        );

        expect(find.text("This is title text"), findsOneWidget);
      });
    });

    testWidgets("Should show the subtitle text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(body: buildIllustrationCardButton()),
        );

        expect(find.text("This is subtitle text"), findsOneWidget);
      });
    });
  });
}
