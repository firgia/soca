/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

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
  });

  tearDown(() => unregisterLocator());

  group("Route", () {
    testWidgets(
        "Should navigate to sign in page when routeTarget return signIn",
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
        "Should navigate to language page when routeTarget return language",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.language)));

        await tester.pumpApp(child: SplashScreen());

        verify(routeCubit.getTargetRoute());
        verify(appNavigator.goToLanguage(any));
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
