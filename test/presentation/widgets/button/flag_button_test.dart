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
  group("Image", () {
    testWidgets("Should render image based on DeviceLanguage", (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onPressed: () {},
            selected: false,
          ),
        );

        final image =
            find.byKey(const Key("flag_button_image")).getWidget() as Image;

        expect(image.image, deviceLanguage.getImage());
      });
    });
  });

  group("Text", () {
    testWidgets("Should render text based on DeviceLanguage native name",
        (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onPressed: () {},
            selected: false,
          ),
        );

        final text =
            find.byKey(const Key("flag_button_text")).getWidget() as Text;
        expect(text.data, deviceLanguage.getNativeName());
      });
    });
  });

  group("CheckIcon", () {
    testWidgets("Should render check icon when selected is true",
        (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onPressed: () {},
            selected: true,
          ),
        );

        expect(find.byKey(const Key("flag_button_check_icon")), findsOneWidget);
      });
    });

    testWidgets("Shouldn't render check icon when selected is false",
        (tester) async {
      await tester.runAsync(() async {
        const deviceLanguage = DeviceLanguage.indonesian;

        await tester.pumpApp(
          child: FlagButton(
            language: deviceLanguage,
            onPressed: () {},
            selected: false,
          ),
        );

        expect(find.byKey(const Key("flag_button_check_icon")), findsNothing);
      });
    });
  });
}
