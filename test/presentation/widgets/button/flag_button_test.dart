/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findButtonImage() => find.byKey(const Key("flag_button_image"));
  Finder findButtonText() => find.byKey(const Key("flag_button_text"));
  Finder findCheckIcon() => find.byKey(const Key("flag_button_check_icon"));

  group("Check Icon", () {
    testWidgets("Should show check icon when selected is true", (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onTap: () {},
            selected: true,
          ),
        );

        expect(findCheckIcon(), findsOneWidget);
      });
    });

    testWidgets("Shouldn't show check icon when selected is false",
        (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onTap: () {},
            selected: false,
          ),
        );

        expect(findCheckIcon(), findsNothing);
      });
    });
  });

  group("Image", () {
    testWidgets("Should show image based on [DeviceLanguage]", (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onTap: () {},
            selected: false,
          ),
        );

        Image image = findButtonImage().getWidget() as Image;
        expect(image.image, deviceLanguage.getImage());
      });
    });
  });

  group("Text", () {
    testWidgets("Should show text based on [DeviceLanguage] native name",
        (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onTap: () {},
            selected: false,
          ),
        );

        Text text = findButtonText().getWidget() as Text;
        expect(text.data, deviceLanguage.getNativeName());
      });
    });
  });
}
