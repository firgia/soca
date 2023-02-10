/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
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

  group("Authentication Error", () {
    testWidgets("Show authentication error", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.authenticationError(),
        );

        expect(
          find.byKey(const Key("error_message_authentication_error")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show authentication error text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.authenticationError(),
        );

        expect(
          find.text(LocaleKeys.error_auth.tr()),
          findsOneWidget,
        );

        expect(
          find.text(LocaleKeys.error_signed_in.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.authenticationError(),
        );

        expect(
          find.byType(LottieBuilder),
          findsOneWidget,
        );
      });
    });
  });

  group("Internet Error", () {
    testWidgets("Show internet error", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.internetError(),
        );

        expect(
          find.byKey(const Key("error_message_internet_error")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show internet error text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.internetError(),
        );
        expect(
          find.text(LocaleKeys.error_check_your_connection.tr()),
          findsOneWidget,
        );

        expect(
          find.text(LocaleKeys.error_check_your_connection_desc.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.internetError(),
        );

        expect(
          find.byType(LottieBuilder),
          findsOneWidget,
        );
      });
    });
  });

  group("Something Error", () {
    testWidgets("Show something error", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.somethingError(),
        );

        expect(
          find.byKey(const Key("error_message_something_error")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show something error text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.somethingError(),
        );
        expect(
          find.text(LocaleKeys.error_something_wrong.tr()),
          findsOneWidget,
        );

        expect(
          find.text(LocaleKeys.error_something_wrong_desc.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets("Show animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.somethingError(),
        );

        expect(
          find.byType(LottieBuilder),
          findsOneWidget,
        );
      });
    });
  });
}
