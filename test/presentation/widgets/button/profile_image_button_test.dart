/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findCameraIcon() =>
      find.byKey(const Key("profile_image_button_camera_icon"));
  Finder findImage() => find.byType(Image);
  Finder findLargeCameraIcon() =>
      find.byKey(const Key("profile_image_button_large_camera_icon"));
  Finder findProfileImageButton() => find.byType(ProfileImageButton);

  group("Action", () {
    testWidgets("Should call [onTap] when [ProfileImageButton] is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
            child: Scaffold(
          body: ProfileImageButton(
            onTap: () {
              isTapped = true;
            },
            fileImage: File("assets/images/raster/avatar.png"),
          ),
        ));

        await tester.tap(findProfileImageButton());
        await tester.pumpAndSettle();

        expect(isTapped, true);
      });
    });
  });

  group("Camera Icon", () {
    testWidgets("Should not show camera icon when [fileImage] is not null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: Scaffold(
          body: ProfileImageButton(
              onTap: () {}, fileImage: File("assets/images/raster/avatar.png")),
        ));

        expect(
          findLargeCameraIcon(),
          findsNothing,
        );
      });
    });

    testWidgets("Should show camera icon when [fileImage] is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: Scaffold(
          body: ProfileImageButton(
            onTap: () {},
            fileImage: null,
          ),
        ));

        expect(
          findLargeCameraIcon(),
          findsOneWidget,
        );
      });
    });
  });

  group("Image", () {
    testWidgets("Should show image if [fileImage] is not null", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: Scaffold(
          body: ProfileImageButton(
              onTap: () {}, fileImage: File("assets/images/raster/avatar.png")),
        ));

        expect(findImage(), findsOneWidget);
        expect(
          findCameraIcon(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should not show image if [fileImage] is null", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: Scaffold(
          body: ProfileImageButton(onTap: () {}, fileImage: null),
        ));

        expect(findImage(), findsNothing);
      });
    });
  });
}
