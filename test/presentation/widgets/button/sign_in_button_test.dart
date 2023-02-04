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

        final container = find.byType(Container).getWidget() as Container;
        expect(container.constraints?.maxWidth, 400);
      });
    });
  });

  group("Style", () {
    testWidgets("Should use the ElevatedButton with FlatButtonStyle ",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: SignInButton(
            icon: const Icon(Icons.abc),
            label: const Text("button"),
            onPressed: () {},
          ),
        );

        final finder = find.byKey(const Key("sign_in_button_elevated_button"));
        final button = finder.getWidget() as ElevatedButton;
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

        final icon = find.byType(Icon).getWidget() as Icon;
        expect(icon.icon, Icons.abc);
        expect(find.byType(Icon), findsOneWidget);
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

        final text = find.byType(Text).getWidget() as Text;
        expect(text.data, "button");
        expect(find.byType(Text), findsOneWidget);
      });
    });
  });
}
