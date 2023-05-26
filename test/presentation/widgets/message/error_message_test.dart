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

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findAuthenticationError() =>
      find.byKey(const Key("error_message_authentication_error"));
  Finder findErrorAuthText() => find.text(LocaleKeys.error_auth.tr());
  Finder findErrorCheckYourConnectionText() =>
      find.text(LocaleKeys.error_check_your_connection.tr());
  Finder findErrorCheckYourConnectionDescText() =>
      find.text(LocaleKeys.error_check_your_connection_desc.tr());
  Finder findErrorSignedInText() => find.text(LocaleKeys.error_signed_in.tr());
  Finder findErrorSomethingWrongText() =>
      find.text(LocaleKeys.error_something_wrong.tr());
  Finder findErrorSomethingWrongDescText() =>
      find.text(LocaleKeys.error_something_wrong_desc.tr());
  Finder findInternetError() =>
      find.byKey(const Key("error_message_internet_error"));
  Finder findLottieBuilder() => find.byType(LottieBuilder);
  Finder findSomethingError() =>
      find.byKey(const Key("error_message_something_error"));

  group("Authentication Error", () {
    testWidgets("Show authentication error", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const ErrorMessage.authenticationError(),
        );

        expect(
          findAuthenticationError(),
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
          findErrorAuthText(),
          findsOneWidget,
        );

        expect(
          findErrorSignedInText(),
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
          findLottieBuilder(),
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
          findInternetError(),
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
          findErrorCheckYourConnectionText(),
          findsOneWidget,
        );

        expect(
          findErrorCheckYourConnectionDescText(),
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
          findLottieBuilder(),
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
          findSomethingError(),
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
          findErrorSomethingWrongText(),
          findsOneWidget,
        );

        expect(
          findErrorSomethingWrongDescText(),
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
          findLottieBuilder(),
          findsOneWidget,
        );
      });
    });
  });
}
