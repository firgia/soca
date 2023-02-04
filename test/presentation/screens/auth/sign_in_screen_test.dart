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
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockDeviceInfo deviceInfo;
  late MockSignInBloc signInBloc;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    deviceInfo = getMockDeviceInfo();
    signInBloc = getMockSignInBloc();
    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  group("Icons", () {
    testWidgets("Should show the app icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(find.byType(SocaIconImage), findsOneWidget);
      });
    });
  });

  group("Route", () {
    testWidgets("Should navigate to home when SignInSuccessfully",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(find.byType(SignInWithGoogleButton));
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
        verify(appNavigator.goToHome(any));
      });
    });
  });

  group("Sign In Button", () {
    testWidgets(
        "Should show the sign in with Apple and sign in with Google button if device is iOS",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        expect(find.byType(SignInWithAppleButton), findsOneWidget);
        expect(find.byType(SignInWithGoogleButton), findsOneWidget);
      });
    });

    testWidgets(
        "Should show the sign in with Google button only if device is not iOS",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(false);

        await tester.pumpApp(child: SignInScreen());

        expect(find.byType(SignInWithAppleButton), findsNothing);
        expect(find.byType(SignInWithGoogleButton), findsOneWidget);
      });
    });

    testWidgets(
        "Should call the SignInWithApple event when tap the SignInWithAppleButton",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(find.byType(SignInWithAppleButton));
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithApple()));
      });
    });

    testWidgets(
        "Should call the SignInWithGoogle event when tap the SignInWithGoogleButton",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(find.byType(SignInWithGoogleButton));
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
      });
    });
  });

  group("Text", () {
    testWidgets("Should show the sign in text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(find.text(LocaleKeys.sign_in.tr()), findsOneWidget);
        expect(find.text(LocaleKeys.sign_in_info.tr()), findsOneWidget);
      });
    });

    testWidgets("Should show the volunteer text info", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(
            find.text(LocaleKeys.volunteer_sign_in_info.tr()), findsOneWidget);
      });
    });
  });
}
