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
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockRouteCubit routeCubit;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    routeCubit = getMockRouteCubit();

    MockWidgetsBinding widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findErrorMessageSomethingError() =>
      find.byKey(const Key("error_message_something_error"));

  group("Route", () {
    testWidgets(
        "Should navigate to sign in page when routeTarget return [AppPages.signIn]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.signIn)));

        await tester.pumpApp(child: SplashScreen());

        verify(routeCubit.getTargetRoute());
        verify(appNavigator.goToSignIn(any));
      });
    });

    testWidgets(
        "Should navigate to language page when routeTarget return [AppPages.language]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.language)));

        await tester.pumpApp(child: SplashScreen());

        verify(routeCubit.getTargetRoute());
        verify(appNavigator.goToLanguage(any));
      });
    });

    testWidgets(
        "Should navigate to home page when routeTarget return [AppPages.home]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.home)));

        await tester.pumpApp(child: SplashScreen());

        verify(routeCubit.getTargetRoute());
        verify(appNavigator.goToHome(any));
      });
    });

    testWidgets(
        "Should navigate to sign up page when routeTarget return [AppPages.signUp]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.signUp)));

        await tester.pumpApp(child: SplashScreen());

        verify(routeCubit.getTargetRoute());
        verify(appNavigator.goToSignUp(any));
      });
    });

    testWidgets("Should show alert something error when getting error",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(const RouteError()));

        await tester.pumpApp(child: SplashScreen());
        await tester.pump();

        expect(
          findErrorMessageSomethingError(),
          findsOneWidget,
        );
        verify(routeCubit.getTargetRoute());
      });
    });

    testWidgets(
        "Should call getTargetRoute() again when press ok on alert something error",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(const RouteError()));

        await tester.pumpApp(child: SplashScreen());
        await tester.pump();

        expect(
          findErrorMessageSomethingError(),
          findsOneWidget,
        );
        verify(routeCubit.getTargetRoute());

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.signUp)));
        await tester.tap(find.text(LocaleKeys.ok.tr()));
        await tester.pump();
        verify(routeCubit.getTargetRoute());
      });
    });
  });

  group("Animation Loading", () {
    testWidgets("Should show animation loading", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SplashScreen());

        expect(find.byType(LottieBuilder), findsOneWidget);

        final lottieAnimation =
            find.byType(LottieBuilder).getWidget() as LottieBuilder;
        final assetLottie = lottieAnimation.lottie as AssetLottie;

        expect(assetLottie.assetName, ImageAnimation.splashLoading);
      });
    });
  });
}
