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

        final titleOpacity = find
            .byKey(const Key("custom_app_bar_title_opacity"))
            .getWidget() as AnimatedOpacity;

        final largeTitleOpacity = find
            .byKey(const Key("custom_app_bar_large_title_opacity"))
            .getWidget() as AnimatedOpacity;

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

        final titleOpacity = find
            .byKey(const Key("custom_app_bar_title_opacity"))
            .getWidget() as AnimatedOpacity;

        final largeTitleOpacity = find
            .byKey(const Key("custom_app_bar_large_title_opacity"))
            .getWidget() as AnimatedOpacity;

        expect(titleOpacity.opacity, 1);
        expect(largeTitleOpacity.opacity, 0);
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

        final dividerOpacity = find
            .byKey(const Key("custom_app_bar_divider_opacity"))
            .getWidget() as AnimatedOpacity;

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

        final dividerOpacity = find
            .byKey(const Key("custom_app_bar_divider_opacity"))
            .getWidget() as AnimatedOpacity;

        expect(dividerOpacity.opacity, 1);
      });
    });
  });

  group("CustomBackButton", () {
    testWidgets("Should render the CustomBackButton", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: Container()));
        expect(find.byType(CustomBackButton), findsOneWidget);
      });
    });
  });

  group("Body", () {
    testWidgets("Should render the body", (tester) async {
      await tester.runAsync(() async {
        final widget = Container(width: 10, height: 10, color: Colors.red);
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: widget));

        expect(find.byWidget(widget), findsOneWidget);
      });
    });
  });

  group("Actions", () {
    testWidgets("Should render the actions", (tester) async {
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
}
