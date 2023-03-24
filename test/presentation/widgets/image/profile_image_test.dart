/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findCachedNetworkImage() => find.byType(CachedNetworkImage);
  Finder findImage() => find.byType(Image);
  Finder findErrorImage() => find.byKey(const Key("profile_image_error"));

  group(".asset()", () {
    testWidgets("Should show [Image] and use [AssetImage] provider",
        (tester) async {
      String assetName = "assets/images/raster/avatar.png";

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileImage.asset(assetName),
          ),
        );

        Image image = findImage().getWidget() as Image;
        AssetImage assetImage = image.image as AssetImage;

        expect(findImage(), findsOneWidget);
        expect(assetImage.assetName, assetName);
        expect(findErrorImage(), findsNothing);
      });
    });

    testWidgets("Should show error image when invalid URL", (tester) async {
      String assetName = "-";

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileImage.asset(
              assetName,
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        await tester.pump();

        expect(findErrorImage(), findsOneWidget);
      });
    });
  });

  group(".file()", () {
    testWidgets("Should show [Image] and use [FileImage] provider",
        (tester) async {
      File file = File("assets/images/raster/avatar.png");

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileImage.file(file),
          ),
        );

        Image image = findImage().getWidget() as Image;
        FileImage fileImage = image.image as FileImage;

        expect(findImage(), findsOneWidget);
        expect(fileImage.file.path, file.path);
        expect(findErrorImage(), findsNothing);
      });
    });

    testWidgets("Should show error image when invalid File", (tester) async {
      File file = File("-");

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileImage.file(file),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        await tester.pump();

        expect(findErrorImage(), findsOneWidget);
      });
    });
  });

  group(".loading()", () {
    testWidgets("Should show [CustomShimmer]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: ProfileImage.loading(),
          ),
        );

        expect(find.byType(CustomShimmer), findsOneWidget);
        expect(findErrorImage(), findsNothing);
      });
    });
  });

  group(".network()", () {
    testWidgets("Should show [Image] and use [CachedNetworkImage]",
        (tester) async {
      String url =
          "https://static.remove.bg/sample-gallery/graphics/bird-thumbnail.jpg";
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ProfileImage.network(
              url: url,
            ),
          ),
        );

        CachedNetworkImage image =
            findCachedNetworkImage().getWidget() as CachedNetworkImage;

        expect(findCachedNetworkImage(), findsOneWidget);
        expect(image.imageUrl, url);
      });
    });

    // FIXME: This test still fail
    // testWidgets("Should show error image when invalid Url", (tester) async {
    //   String url = "https://static.remove.bg/sample-gallery/graphics/.jpg";
    //   await tester.runAsync(() async {
    //     await tester.pumpApp(
    //       child: Scaffold(
    //         body: ProfileImage.network(
    //           url: url,
    //         ),
    //       ),
    //     );

    //     await Future.delayed(const Duration(seconds: 10));
    //     await tester.pump();

    //     expect(findErrorImage(), findsOneWidget);
    //   });
    // });
  });
}
