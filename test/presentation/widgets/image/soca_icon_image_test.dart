/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/widgets/widgets.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
  });

  tearDown(() => unregisterLocator());

  Finder findHero() => find.byType(Hero);
  Finder findImage() => find.byType(Image);

  group("Brightness", () {
    late MockPlatformDispatcher platformDispatcher;

    setUp(() {
      platformDispatcher = MockPlatformDispatcher();
    });

    testWidgets("Should show image asset for dark theme", (tester) async {
      await tester.runAsync(() async {
        when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
        when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

        await tester.pumpApp(
          child: const SocaIconImage(),
        );

        Image image = findImage().getWidget() as Image;
        expect(image.image, isA<AssetImage>());

        final assetImage = image.image as AssetImage;
        expect(assetImage.assetName, ImageRaster.socaIconDarkElevation);
      });
    });

    testWidgets("Should show image asset for light theme", (tester) async {
      await tester.runAsync(() async {
        when(platformDispatcher.platformBrightness)
            .thenReturn(Brightness.light);
        when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
        await tester.pumpApp(
          child: const SocaIconImage(),
        );

        Image image = findImage().getWidget() as Image;
        expect(image.image, isA<AssetImage>());

        final assetImage = image.image as AssetImage;
        expect(assetImage.assetName, ImageRaster.socaIconLightElevation);
      });
    });
  });

  group("Hero", () {
    late MockPlatformDispatcher platformDispatcher;

    setUp(() {
      platformDispatcher = MockPlatformDispatcher();
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.light);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
    });

    testWidgets("Should show the [Hero] widget when [heroTag] is exists",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SocaIconImage(heroTag: "abc"));

        expect(findHero(), findsOneWidget);

        final hero = findHero().getWidget() as Hero;
        expect(hero.tag, "abc");
      });
    });

    testWidgets(
        "Should not show the [Hero] widget when [heroTag] is not exists",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SocaIconImage());

        expect(findHero(), findsNothing);
      });
    });
  });

  group("Size", () {
    late MockPlatformDispatcher platformDispatcher;

    setUp(() {
      platformDispatcher = MockPlatformDispatcher();
      when(platformDispatcher.platformBrightness).thenReturn(Brightness.light);
      when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
    });

    testWidgets("Should set the height image 200 as a default", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SocaIconImage());

        Image image = findImage().getWidget() as Image;
        expect(image.height, 200);
      });
    });

    testWidgets("Should set the height image based on size parameter",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SocaIconImage(size: 300));

        Image image = findImage().getWidget() as Image;
        expect(image.height, 300);
      });
    });
  });
}
