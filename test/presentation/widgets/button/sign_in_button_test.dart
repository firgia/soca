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
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  Finder findContainer() => find.byType(Container);
  Finder findElevatedButton() =>
      find.byKey(const Key("sign_in_button_elevated_button"));
  Finder findIcon() => find.byType(Icon);
  Finder findText() => find.byType(Text);

  group("Size", () {
    testWidgets("Should set max width to 400", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: SignInButton(
            icon: const Icon(Icons.abc),
            label: const Text("button"),
            onPressed: () {},
          ),
        );

        Container container = findContainer().getWidget() as Container;
        expect(container.constraints?.maxWidth, 400);
      });
    });
  });

  group("Style", () {
    testWidgets("Should use the [ElevatedButton] with [FlatButtonStyle]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: SignInButton(
            icon: const Icon(Icons.abc),
            label: const Text("button"),
            onPressed: () {},
          ),
        );

        ElevatedButton button =
            findElevatedButton().getWidget() as ElevatedButton;
        expect(button.style, isA<FlatButtonStyle>());
      });
    });
  });

  group("Content", () {
    testWidgets("Should render the icon widget", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: SignInButton(
            icon: const Icon(Icons.abc),
            label: const Text("button"),
            onPressed: () {},
          ),
        );

        Icon icon = findIcon().getWidget() as Icon;
        expect(icon.icon, Icons.abc);
        expect(findIcon(), findsOneWidget);
      });
    });

    testWidgets("Should render the label widget", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: SignInButton(
            icon: const Icon(Icons.abc),
            label: const Text("button"),
            onPressed: () {},
          ),
        );

        Text text = findText().getWidget() as Text;
        expect(text.data, "button");
        expect(findText(), findsOneWidget);
      });
    });
  });
}
