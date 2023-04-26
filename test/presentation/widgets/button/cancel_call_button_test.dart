/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findAvatarGlow() => find.byType(AvatarGlow);
  Finder findCancelText() => find.text(LocaleKeys.cancel.tr());
  Finder findIcon() => find.byType(Icon);

  group("Actions", () {
    testWidgets("Should execute onPressed when tapped the [CancelCallButton]",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;

        await tester.pumpApp(
          child: CancelCallButton(
            onPressed: () {
              tapped = true;
            },
            isLoading: false,
          ),
        );

        await tester.tap(find.byType(CancelCallButton));
        expect(tapped, true);
      });
    });
  });

  group("AvatarGlow", () {
    testWidgets("Should show [AvatarGlow]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CancelCallButton(
            onPressed: () {},
            isLoading: false,
          ),
        );

        expect(findAvatarGlow(), findsOneWidget);
      });
    });
  });

  group("Loading", () {
    testWidgets("Should show [AdaptiveLoading] when [isLoading] is true",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CancelCallButton(
            onPressed: () {},
            isLoading: true,
          ),
        );

        expect(findAdaptiveLoading(), findsOneWidget);
        expect(findIcon(), findsNothing);
      });
    });

    testWidgets("Should hide [AdaptiveLoading] when [isLoading] is false",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CancelCallButton(
            onPressed: () {},
            isLoading: false,
          ),
        );

        expect(findAdaptiveLoading(), findsNothing);
        expect(findIcon(), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show male text when [gender] is [Gender.male]",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: CancelCallButton(
            onPressed: () {},
            isLoading: false,
          ),
        );

        expect(findCancelText(), findsOneWidget);
      });
    });
  });
}
