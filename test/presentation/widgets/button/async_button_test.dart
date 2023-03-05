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

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findIcon() => find.byType(Icon);

  group("Child", () {
    testWidgets("Should show the widget child", (tester) async {
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
    testWidgets("Should show the widget icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton.icon(
            icon: const Icon(Icons.abc),
            onPressed: () {},
            isLoading: false,
            label: Container(),
          ),
        );

        Icon icon = findIcon().getWidget() as Icon;
        expect(icon.icon, Icons.abc);
      });
    });

    testWidgets("Shouldn't show the widget icon when [isLoading] true",
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

        expect(findIcon(), findsNothing);
      });
    });
  });

  group("Label", () {
    testWidgets("Should show the widget label", (tester) async {
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
    testWidgets("Should show the loading indicator when [isLoading] true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: true,
            child: Container(),
          ),
        );
        expect(findAdaptiveLoading(), findsOneWidget);
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
        expect(findAdaptiveLoading(), findsOneWidget);
      });
    });

    testWidgets("Shouldn't show the loading indicator when [isLoading] false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: AsyncButton(
            onPressed: () {},
            isLoading: false,
            child: Container(),
          ),
        );
        expect(findAdaptiveLoading(), findsNothing);
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
        expect(findAdaptiveLoading(), findsNothing);
      });
    });

    testWidgets("Should update the [loadingRadius] based on parameter",
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

        AdaptiveLoading adaptiveLoading =
            findAdaptiveLoading().getWidget() as AdaptiveLoading;
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

        AdaptiveLoading adaptiveLoading =
            findAdaptiveLoading().getWidget() as AdaptiveLoading;
        expect(adaptiveLoading.radius, 20);
      });
    });
  });
}
