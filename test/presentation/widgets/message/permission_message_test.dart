/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findPermanentlyDenied() =>
      find.byKey(const Key("permission_message_permanently_denied"));
  Finder findRestricted() =>
      find.byKey(const Key("permission_message_restricted"));
  Finder findLottieBuilder() => find.byType(LottieBuilder);
  Finder findOkButton() =>
      find.byKey(const Key("permission_message_ok_button"));
  Finder findSettingsButton() =>
      find.byKey(const Key("permission_message_settings_button"));

  group("Permanently Denied Message", () {
    testWidgets("Show permanently denied UI", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.permanentlyDenied(),
        );

        expect(
          findPermanentlyDenied(),
          findsOneWidget,
        );

        expect(
          findRestricted(),
          findsNothing,
        );
      });
    });

    testWidgets("Show permission denied text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.permanentlyDenied(),
        );

        expect(
          find.text(LocaleKeys.permission_denied.tr()),
          findsOneWidget,
        );

        expect(
          find.text(LocaleKeys.permission_permanently_denied_desc.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show caption text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.permanentlyDenied(
            captiontext: "Caption",
          ),
        );

        expect(
          find.text("Caption"),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.permanentlyDenied(),
        );

        expect(
          findLottieBuilder(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should call [onActionPressed] when settings button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;

        await tester.pumpApp(
          child: PermissionMessage.permanentlyDenied(
            onActionPressed: () => tapped = true,
          ),
        );

        expect(findSettingsButton(), findsOneWidget);

        await tester.tap(findSettingsButton());
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });
  });

  group("Restricted Message", () {
    testWidgets("Show restricted UI", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.restricted(),
        );

        expect(
          findPermanentlyDenied(),
          findsNothing,
        );

        expect(
          findRestricted(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show restricted text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.restricted(),
        );

        expect(
          find.text(LocaleKeys.permission_restricted.tr()),
          findsOneWidget,
        );

        expect(
          find.text(LocaleKeys.permission_restricted_desc.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show caption text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.restricted(
            captiontext: "Caption",
          ),
        );

        expect(
          find.text("Caption"),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const PermissionMessage.restricted(),
        );

        expect(
          findLottieBuilder(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should call [onActionPressed] when ok button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        bool tapped = false;

        await tester.pumpApp(
          child: PermissionMessage.restricted(
            onActionPressed: () => tapped = true,
          ),
        );

        expect(findOkButton(), findsOneWidget);

        await tester.tap(findOkButton());
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });
  });
}
