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
    testWidgets("Should how the title text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: CustomAppBar(title: "hello world", body: Container()));
        expect(find.text("hello world"), findsNWidgets(2));
      });
    });

    // TODO: Implement test
    // testWidgets(
    //     "Should show the large title when not scrolling", (tester) async {});

    // testWidgets(
    //     "Should hide the large title when scrolling", (tester) async {});

    // testWidgets(
    //     "Should show the small title when scrolling", (tester) async {});

    // testWidgets(
    //     "Should hide the small title when not scrolling", (tester) async {});
  });

  group("Divider", () {
    // TODO: Implement test
    // testWidgets(
    //     "Should show the divider when scrolling", (tester) async {});
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
