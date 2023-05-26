/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
  });

  tearDown(() => unregisterLocator());

  Finder findIcon() => find.byType(Icon);
  Finder findSignInButton() => find.byType(SignInButton);

  group("Button", () {
    testWidgets("Should use [SignInButton]", (tester) async {
      await tester.runAsync(() async {
        MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
        when(platformDispatcher.platformBrightness)
            .thenReturn(Brightness.light);
        when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

        await tester.pumpApp(
          child: SignInWithAppleButton(onPressed: () {}),
        );

        expect(findSignInButton(), findsOneWidget);
      });
    });
  });

  group("Brightness", () {
    late MockPlatformDispatcher platformDispatcher;
    const primaryDarkColor = Colors.white;
    final primaryLightColor = Colors.grey[900]!;
    final onPrimaryDarkColor = Colors.grey[900]!;
    const onPrimaryLightColor = Colors.white;

    setUp(() {
      platformDispatcher = MockPlatformDispatcher();
    });

    testWidgets("Should set the color for dark theme", (tester) async {
      await tester.runAsync(() async {
        when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
        when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

        await tester.pumpApp(
          child: SignInWithAppleButton(onPressed: () {}),
        );

        SignInButton button = findSignInButton().getWidget() as SignInButton;
        Icon icon = findIcon().getWidget() as Icon;

        expect(button.primaryColor, primaryDarkColor);
        expect(button.onPrimaryColor, onPrimaryDarkColor);
        expect(icon.color, onPrimaryDarkColor);
      });
    });

    testWidgets("Should set the color for light theme", (tester) async {
      await tester.runAsync(() async {
        when(platformDispatcher.platformBrightness)
            .thenReturn(Brightness.light);
        when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

        await tester.pumpApp(
          child: SignInWithAppleButton(onPressed: () {}),
        );

        SignInButton button = findSignInButton().getWidget() as SignInButton;
        Icon icon = findIcon().getWidget() as Icon;

        expect(button.primaryColor, primaryLightColor);
        expect(button.onPrimaryColor, onPrimaryLightColor);
        expect(icon.color, onPrimaryLightColor);
      });
    });
  });
}
