/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 04 2023
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
  late MockDeviceFeedback deviceFeedback;

  setUp(() {
    registerLocator();

    deviceFeedback = getMockDeviceFeedback();
    MockWidgetsBinding widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findUpdateText() => find.text(LocaleKeys.update_app_required.tr());
  Finder findUpdateDescText() =>
      find.text(LocaleKeys.update_app_required_desc.tr());
  Finder findUpdateButton() =>
      find.byKey(const Key("update_app_screen_update_now_button"));
  Finder findIllustrationImage() =>
      find.byKey(const Key("update_app_screen_illustration_image"));

  group("Button", () {
    testWidgets("Should show update now button", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UpdateAppScreen());

        expect(findUpdateButton(), findsOneWidget);
      });
    });
  });

  group("Image", () {
    testWidgets("Should show illustration animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UpdateAppScreen());

        expect(findIllustrationImage(), findsOneWidget);

        LottieBuilder lottieAnimation =
            findIllustrationImage().getWidget() as LottieBuilder;
        final assetLottie = lottieAnimation.lottie as AssetLottie;
        expect(assetLottie.assetName, ImageAnimation.mobileAppRepair);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show update app text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UpdateAppScreen());

        expect(findUpdateText(), findsOneWidget);
      });
    });

    testWidgets("Should show update app description info text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UpdateAppScreen());

        expect(findUpdateDescText(), findsOneWidget);
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets('Should play update app info', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const UpdateAppScreen());

        verify(
          deviceFeedback.playVoiceAssistant(
            [
              LocaleKeys.update_app_required_desc.tr(),
            ],
            any,
            immediately: true,
          ),
        );
      });
    });
  });
}
