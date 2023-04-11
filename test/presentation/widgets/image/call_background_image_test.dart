/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findCachedNetworkImage() => find.byType(CachedNetworkImage);
  Finder findOpacity() => find.byType(Opacity);

  group("Image", () {
    testWidgets("Should show [CachedNetworkImage] and set opacity to .2",
        (tester) async {
      await tester.runAsync(() async {
        String url = "https://www.w3schools.com/w3images/avatar2.png";
        await tester.setScreenSize(iphone14);

        await tester.pumpApp(
          child: Scaffold(body: CallBackgroundImage(url: url)),
        );

        CachedNetworkImage image =
            findCachedNetworkImage().getWidget() as CachedNetworkImage;

        Opacity opacity = findOpacity().getWidget() as Opacity;

        expect(findCachedNetworkImage(), findsOneWidget);
        expect(findOpacity(), findsOneWidget);

        expect(image.imageUrl, url);
        expect(image.width, iphone14.width / iphone14.ratio);
        expect(image.height, iphone14.height / iphone14.ratio);
        expect(opacity.opacity, .2);
      });
    });
  });
}
