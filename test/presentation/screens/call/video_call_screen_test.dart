/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockCallActionBloc callActionBloc;
  late MockRtcEngine rtcEngine;
  late MockVideoCallBloc videoCallBloc;

  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    callActionBloc = getMockCallActionBloc();
    rtcEngine = getMockRtcEngine();
    videoCallBloc = getMockVideoCallBloc();

    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  CallingSetup callingSetup = const CallingSetup(
    id: "1",
    rtc: RTCIdentity(token: "abc", channelName: "a", uid: 1),
    localUser: UserCallIdentity(
      name: "name",
      uid: "uid",
      avatar: "avatar",
      type: UserType.blind,
    ),
    remoteUser: UserCallIdentity(
      name: "name",
      uid: "uid",
      avatar: "avatar",
      type: UserType.volunteer,
    ),
  );

  Finder findFlashlightOnMessage() =>
      find.text(LocaleKeys.turn_on_flashlight.tr());

  Finder findFlashlightOffMessage() =>
      find.text(LocaleKeys.turn_off_flashlight.tr());

  Finder findFlipModeOnMessage() =>
      find.text(LocaleKeys.turn_on_reverse_screen.tr());

  Finder findFlipModeOffMessage() =>
      find.text(LocaleKeys.turn_off_reverse_screen.tr());

  group("Bloc Listener", () {
    testWidgets(
        'Should back to previous page when [CallActionError] with '
        'CallActionType.ended type', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: null,
              isLocalJoined: false,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: null,
            ),
          );

          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(const CallActionError(CallActionType.ended)));

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));

          verify(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        "Should back to previous page when [CallActionEndedSuccessfully]",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: null,
              isLocalJoined: false,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: null,
            ),
          );

          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(const CallActionEndedSuccessfully()));

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));

          verify(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        'Should call add [CallActionEnded] when [VideoCallState.isUserOffline] '
        'is true', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: null,
            isLocalJoined: false,
            isCallEnded: false,
            isUserOffline: true,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          verify(callActionBloc.add(CallActionEnded(callingSetup.id)));
        });
      });
    });

    testWidgets(
        'Should not call add [CallActionEnded] when [VideoCallState.isUserOffline] '
        'is false', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: null,
            isLocalJoined: false,
            isCallEnded: false,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          verifyNever(callActionBloc.add(CallActionEnded(callingSetup.id)));
        });
      });
    });

    testWidgets(
        'Should back to previous page when [VideoCallState.isCallEnded] '
        'is true', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: null,
            isLocalJoined: false,
            isCallEnded: true,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          verify(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        'Should not back to previous page when [VideoCallState.isCallEnded] '
        'is false', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: null,
            isLocalJoined: false,
            isCallEnded: false,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          verifyNever(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        'Should show turn on flip mode message when '
        '[VideoCallState.setting.enableFlip] is true', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: CallSetting(enableFlip: true),
            isLocalJoined: false,
            isCallEnded: true,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();
          expect(findFlipModeOnMessage(), findsOneWidget);
          expect(findFlipModeOffMessage(), findsNothing);
        });
      });
    });

    testWidgets(
        'Should show turn off flip mode message when '
        '[VideoCallState.setting.enableFlip] is false', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: CallSetting(enableFlip: false),
            isLocalJoined: false,
            isCallEnded: true,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          expect(findFlipModeOnMessage(), findsNothing);
          expect(findFlipModeOffMessage(), findsOneWidget);
        });
      });
    });

    testWidgets(
        'Should call [RtcEngine.setCameraTorchOn(true)] and show turn off '
        'flashlight message when  [VideoCallState.setting.enableFlashlight] '
        'is true', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: CallSetting(enableFlashlight: true),
            isLocalJoined: false,
            isCallEnded: true,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          verify(rtcEngine.setCameraTorchOn(true));
          expect(findFlashlightOnMessage(), findsOneWidget);
          expect(findFlashlightOffMessage(), findsNothing);
        });
      });
    });

    testWidgets(
        'Should call [RtcEngine.setCameraTorchOn(false)] and show turn off '
        'flashlight message when  [VideoCallState.setting.enableFlashlight] '
        'is false', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          VideoCallState state = const VideoCallState(
            setting: CallSetting(enableFlashlight: false),
            isLocalJoined: false,
            isCallEnded: true,
            isUserOffline: false,
            remoteUID: null,
          );

          when(videoCallBloc.state).thenReturn(state);
          when(videoCallBloc.stream).thenAnswer((_) => Stream.value(state));
          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          verify(rtcEngine.setCameraTorchOn(false));
          expect(findFlashlightOnMessage(), findsNothing);
          expect(findFlashlightOffMessage(), findsOneWidget);
        });
      });
    });
  });
}
