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
  group("Child", () {
    testWidgets("Should render the widget child", (tester) async {
      await tester.runAsync(() async {
        const child = Text("Hello world");
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: false,
            child: child,
          ),
        );
        expect(find.byWidget(child), findsOneWidget);
      });
    });
  });

  group("Icon", () {
    testWidgets("Should render the widget icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: false,
            label: Container(),
          ),
        );

        final icon = find.byType(Icon).getWidget() as Icon;
        expect(icon.icon, Icons.abc);
      });
    });

    testWidgets("Shouldn't render the widget icon when isLoading true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: true,
            label: Container(),
          ),
        );

        expect(find.byType(Icon), findsNothing);
      });
    });
  });

  group("Label", () {
    testWidgets("Should render the widget label", (tester) async {
      await tester.runAsync(() async {
        const child = Text("Hello world");

        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: false,
            label: child,
          ),
        );
        expect(find.byWidget(child), findsOneWidget);
      });
    });
  });

  group("Loading", () {
    testWidgets("Should render the loading indicator when isLoading true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: true,
            child: Container(),
          ),
        );
        expect(find.byType(AdaptiveLoading), findsOneWidget);
      });

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: true,
            label: Container(),
          ),
        );
        expect(find.byType(AdaptiveLoading), findsOneWidget);
      });
    });

    testWidgets("Shouldn't render the loading indicator when isLoading false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: false,
            child: Container(),
          ),
        );
        expect(find.byType(AdaptiveLoading), findsNothing);
      });

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: false,
            label: Container(),
          ),
        );
        expect(find.byType(AdaptiveLoading), findsNothing);
      });
    });

    testWidgets("Should update the loadingRadius based on parameter",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: true,
            loadingRadius: 20,
            child: Container(),
          ),
        );

        final adaptiveLoading =
            find.byType(AdaptiveLoading).getWidget() as AdaptiveLoading;
        expect(adaptiveLoading.radius, 20);
      });

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: true,
            loadingRadius: 20,
            label: Container(),
          ),
        );

        final adaptiveLoading =
            find.byType(AdaptiveLoading).getWidget() as AdaptiveLoading;
        expect(adaptiveLoading.radius, 20);
      });
    });
  });
}
