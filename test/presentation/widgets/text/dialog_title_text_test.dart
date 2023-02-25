/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 16 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

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

  group("Action", () {
    testWidgets("Should call [onClosePressed] when tap close button",
        (tester) async {
      await tester.runAsync(() async {
        bool isPressed = false;

        await tester.pumpApp(
          child: Scaffold(
            body: DialogTitleText(
              title: "Dialog title",
              onClosePressed: () {
                isPressed = true;
              },
            ),
          ),
        );

        await tester
            .tap(find.byKey(const Key("dialog_title_text_close_button")));
        await tester.pumpAndSettle();

        expect(isPressed, true);
      });
    });

    testWidgets("Should hide the close button when [onClosePressed] is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: DialogTitleText(
              title: "Dialog title",
              onClosePressed: null,
            ),
          ),
        );

        expect(
          find.byKey(const Key("dialog_title_text_close_button")),
          findsNothing,
        );
      });
    });
  });

  group("Text", () {
    testWidgets("Should show title text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const DialogTitleText(title: "Dialog title"),
        );

        expect(find.text("Dialog title"), findsOneWidget);
      });
    });
  });
}