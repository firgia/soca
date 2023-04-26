/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findImage() => find.byType(Image);
  Finder findOpacity() => find.byType(Opacity);

  group("Image", () {
    testWidgets("Should show [Image]", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          String url = "https://www.w3schools.com/w3images/avatar2.png";

          await tester.pumpApp(
            child: Scaffold(body: CallBackgroundImage(url: url)),
          );

          Image image = findImage().getWidget() as Image;

          NetworkImage networkImage = image.image as NetworkImage;

          expect(findImage(), findsOneWidget);
          expect(networkImage.url, url);
        });
      });
    });

    testWidgets("Should set height and width same with screen size",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          String url = "https://www.w3schools.com/w3images/avatar3.png";

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(
            child: Scaffold(body: CallBackgroundImage(url: url)),
          );

          Image image = findImage().getWidget() as Image;

          expect(findImage(), findsOneWidget);
          expect(image.width, iphone14.width / iphone14.ratio);
          expect(image.height, iphone14.height / iphone14.ratio);
        });
      });
    });
  });

  group("Opacity", () {
    testWidgets("Should set opacity to .2", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          String url = "https://www.w3schools.com/w3images/avatar2.png";

          await tester.pumpApp(
            child: Scaffold(body: CallBackgroundImage(url: url)),
          );

          Opacity opacity = findOpacity().getWidget() as Opacity;

          expect(findOpacity(), findsOneWidget);
          expect(opacity.opacity, .2);
        });
      });
    });
  });
}
