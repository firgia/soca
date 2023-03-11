/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findGradientButton() => find.byType(GradientButton);

  group("Action", () {
    testWidgets(
        "Should call [onPressed] when [GradientButton] is tapped and [isLoading] is false",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
          child: GradientButton(
            label: "Gradient Button",
            onPressed: () {
              isTapped = true;
            },
            isLoading: false,
          ),
        );

        await tester.tap(findGradientButton());
        await tester.pumpAndSettle();

        expect(isTapped, true);
      });
    });

    testWidgets(
        "Should not call [onPressed] when [GradientButton] is tapped and [isLoading] is true",
        (tester) async {
      await tester.runAsync(() async {
        bool isTapped = false;

        await tester.pumpApp(
          child: GradientButton(
            label: "Gradient Button",
            onPressed: () {
              isTapped = true;
            },
            isLoading: true,
          ),
        );

        await tester.tap(findGradientButton());
        await tester.pump();

        expect(isTapped, false);
      });
    });

    // testWidgets(
    //     "Should call [onPressed] when [GenderButton] is tapped even selected is false",
    //     (tester) async {
    //   await tester.runAsync(() async {
    //     bool isTapped = false;

    //     await tester.pumpApp(
    //       child: GenderButton(
    //         gender: Gender.male,
    //         onPressed: () {
    //           isTapped = true;
    //         },
    //         selected: false,
    //       ),
    //     );

    //     await tester.tap(find.byType(GenderButton));
    //     await tester.pumpAndSettle();

    //     expect(isTapped, true);
    //   });
    // });
  });

  group("Loading", () {
    testWidgets("Should show loading when is [isLoading] is true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GradientButton(
            label: "Gradient Button",
            onPressed: () {},
            isLoading: true,
          ),
        );

        expect(find.text("Gradient Button"), findsNothing);
        expect(findAdaptiveLoading(), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show label text when is [isLoading] is not true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: GradientButton(
            label: "Gradient Button",
            onPressed: () {},
            isLoading: false,
          ),
        );

        expect(find.text("Gradient Button"), findsOneWidget);
        expect(findAdaptiveLoading(), findsNothing);
      });
    });
  });
}
