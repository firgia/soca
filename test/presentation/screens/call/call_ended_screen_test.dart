/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockDeviceFeedback deviceFeedback;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    deviceFeedback = getMockDeviceFeedback();
    MockWidgetsBinding widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findCallEndedText() => find.text(LocaleKeys.call_ended.tr());
  Finder findCallEndedBlindInfoText() =>
      find.text(LocaleKeys.call_ended_blind_info.tr());
  Finder findCallEndedVolunteerInfoText() =>
      find.text(LocaleKeys.call_ended_volunteer_info.tr());
  Finder findOkButton() => find.byKey(const Key("call_ended_screen_ok_button"));
  Finder findIllustrationImage() =>
      find.byKey(const Key("call_ended_screen_illustration_image"));

  Finder findCircularBar() => find.byType(SimpleCircularProgressBar);

  group("Button", () {
    testWidgets("Should show ok button", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        expect(findOkButton(), findsOneWidget);
      });
    });

    testWidgets("Should navigate to home page when ok button is pressed",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        await tester.ensureVisible(findOkButton());
        await tester.tap(findOkButton());
        await tester.pump();

        verify(appNavigator.goToHome(any));
      });
    });
  });

  group("Circular Bar", () {
    testWidgets("Should show circular bar", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        expect(findCircularBar(), findsOneWidget);
      });
    });

    testWidgets("Should navigate to home page automatically on 4 seconds",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        await Future.delayed(const Duration(seconds: 5));
        await tester.pump();

        expect(findCircularBar(), findsOneWidget);
        verify(appNavigator.goToHome(any));
      });
    });
  });

  group("Image", () {
    testWidgets("Should show illustration animation image", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        expect(findIllustrationImage(), findsOneWidget);

        LottieBuilder lottieAnimation =
            findIllustrationImage().getWidget() as LottieBuilder;
        final assetLottie = lottieAnimation.lottie as AssetLottie;
        expect(assetLottie.assetName, ImageAnimation.star);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show call ended text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        expect(findCallEndedText(), findsOneWidget);
      });
    });

    testWidgets("Should show call ended info text for blind user",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        expect(findCallEndedBlindInfoText(), findsOneWidget);
        expect(findCallEndedVolunteerInfoText(), findsNothing);
      });
    });

    testWidgets("Should show call ended info text for volunteer user",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.volunteer,
        ));

        expect(findCallEndedBlindInfoText(), findsNothing);
        expect(findCallEndedVolunteerInfoText(), findsOneWidget);
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets('Should play call ended info for blind user', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.blind,
        ));

        verify(
          deviceFeedback.playVoiceAssistant(
            [
              LocaleKeys.call_ended.tr(),
              LocaleKeys.call_ended_blind_info.tr(),
            ],
            any,
            immediately: true,
          ),
        );
      });
    });

    testWidgets('Should play call ended info for volunteer user',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
            child: const CallEndedScreen(
          userType: UserType.volunteer,
        ));

        verify(
          deviceFeedback.playVoiceAssistant(
            [
              LocaleKeys.call_ended.tr(),
              LocaleKeys.call_ended_volunteer_info.tr(),
            ],
            any,
            immediately: true,
          ),
        );
      });
    });
  });
}
