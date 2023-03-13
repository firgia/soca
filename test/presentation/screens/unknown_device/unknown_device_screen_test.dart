/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();

    MockWidgetsBinding widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findDifferentDeviceText() =>
      find.text(LocaleKeys.sign_in_different_device.tr());
  Finder findDifferentDeviceInfoText() =>
      find.text(LocaleKeys.sign_in_different_device_info.tr());
  Finder findGotItButton() =>
      find.byKey(const Key("unknown_device_screen_got_it_button"));
  Finder findIllustrationImage() =>
      find.byKey(const Key("unknown_device_screen_illustration_image"));

  group("Button", () {
    testWidgets("Should show Got It button", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UnknownDeviceScreen());

        expect(findGotItButton(), findsOneWidget);
      });
    });

    testWidgets("Should navigate to sign in page when Got It button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UnknownDeviceScreen());

        expect(findGotItButton(), findsOneWidget);
        await tester.tap(findGotItButton());
        await tester.pump();
        verify(appNavigator.goToSignIn(any));
      });
    });
  });

  group("Image", () {
    testWidgets("Should show illustration animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UnknownDeviceScreen());

        expect(findIllustrationImage(), findsOneWidget);

        LottieBuilder lottieAnimation =
            findIllustrationImage().getWidget() as LottieBuilder;
        final assetLottie = lottieAnimation.lottie as AssetLottie;
        expect(assetLottie.assetName, ImageAnimation.cyberSecurity);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show different device text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UnknownDeviceScreen());

        expect(findDifferentDeviceText(), findsOneWidget);
      });
    });

    testWidgets("Should show different device info text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UnknownDeviceScreen());

        expect(findDifferentDeviceInfoText(), findsOneWidget);
      });
    });
  });
}
