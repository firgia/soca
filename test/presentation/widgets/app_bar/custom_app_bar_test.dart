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
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  Finder findCustomBackButton() => find.byType(CustomBackButton);
  Finder findDividerOpacity() =>
      find.byKey(const Key("custom_app_bar_divider_opacity"));
  Finder findLargeTitleOpacity() =>
      find.byKey(const Key("custom_app_bar_large_title_opacity"));
  Finder findTitleOpacity() =>
      find.byKey(const Key("custom_app_bar_title_opacity"));

  group("Actions", () {
    testWidgets("Should show the actions", (tester) async {
      await tester.runAsync(() async {
        const actions = [Icon(Icons.telegram), Text("test")];
        await tester.pumpApp(
          child: CustomAppBar(
            title: "hello world",
            body: Container(),
            actions: actions,
          ),
        );

        for (Widget widget in actions) {
          expect(find.byWidget(widget), findsOneWidget);
        }
      });
    });
  });

  group("Body", () {
    testWidgets("Should show the body", (tester) async {
      await tester.runAsync(() async {
        final widget = Container(width: 10, height: 10, color: Colors.red);
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: widget));

        expect(find.byWidget(widget), findsOneWidget);
      });
    });
  });

  group("CustomBackButton", () {
    testWidgets("Should show the CustomBackButton", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: Container()));
        expect(findCustomBackButton(), findsOneWidget);
      });
    });
  });

  group("Divider", () {
    testWidgets("Should hide the divider when not scrolling", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CustomAppBar(
            title: "hello world",
            body: Container(),
          ),
        );

        final dividerOpacity =
            findDividerOpacity().getWidget() as AnimatedOpacity;

        expect(dividerOpacity.opacity, 0);
      });
    });

    testWidgets("Should show the divider when scrolling", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CustomAppBar(
            title: "hello world",
            body: Container(),
          ),
        );

        await tester.drag(find.byType(NestedScrollView), const Offset(0, -300));
        await tester.pump();

        final dividerOpacity =
            findDividerOpacity().getWidget() as AnimatedOpacity;

        expect(dividerOpacity.opacity, 1);
      });
    });
  });

  group("Title", () {
    testWidgets("Should show the title text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: Container()));
        expect(find.text("hello world"), findsNWidgets(2));
      });
    });

    testWidgets(
        "Should show the large title and hide the default title when not scrolling",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CustomAppBar(
            title: "hello world",
            body: Container(),
          ),
        );

        final titleOpacity = findTitleOpacity().getWidget() as AnimatedOpacity;

        final largeTitleOpacity =
            findLargeTitleOpacity().getWidget() as AnimatedOpacity;

        expect(titleOpacity.opacity, 0);
        expect(largeTitleOpacity.opacity, 1);
      });
    });

    testWidgets(
        "Should hide the large title and show the default title when scrolling",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CustomAppBar(
            title: "hello world",
            body: Container(),
          ),
        );

        await tester.drag(find.byType(NestedScrollView), const Offset(0, -300));
        await tester.pump();

        final titleOpacity = findTitleOpacity().getWidget() as AnimatedOpacity;

        final largeTitleOpacity =
            findLargeTitleOpacity().getWidget() as AnimatedOpacity;

        expect(titleOpacity.opacity, 1);
        expect(largeTitleOpacity.opacity, 0);
      });
    });
  });
}
