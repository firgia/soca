/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late MockDeviceInfo deviceInfo;
  late MockDotEnv dotEnv;
  late MockRtcEngine rtcEngine;
  late MockVideoCallBloc videoCallBloc;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    callActionBloc = getMockCallActionBloc();
    deviceInfo = getMockDeviceInfo();
    dotEnv = getMockDotEnv();
    rtcEngine = getMockRtcEngine();
    videoCallBloc = getMockVideoCallBloc();

    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(dotEnv.env).thenReturn({"AGORA_APP_ID": "abc"});
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

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findAgoraView() => find.byType(AgoraVideoView);

  Finder findEndCallButton() =>
      find.byKey(const Key("video_call_screen_end_call_button"));

  Finder findEndCallButtonIcon() =>
      find.byKey(const Key("video_call_screen_end_call_button_icon"));

  Finder findEndCallButtonLoading() =>
      find.byKey(const Key("video_call_screen_end_call_button_loading"));

  Finder findFlashlightButton() =>
      find.byKey(const Key("video_call_screen_flashlight_button"));

  Finder findFlashlightButtonIcon() =>
      find.byKey(const Key("video_call_screen_flashlight_button_icon"));

  Finder findFlashlightButtonLoading() =>
      find.byKey(const Key("video_call_screen_flashlight_button_loading"));

  Finder findFlashlightOnMessage() =>
      find.text(LocaleKeys.turn_on_flashlight.tr());

  Finder findFlashlightOffMessage() =>
      find.text(LocaleKeys.turn_off_flashlight.tr());

  Finder findFlipButton() =>
      find.byKey(const Key("video_call_screen_flip_button"));

  Finder findFlipButtonIcon() =>
      find.byKey(const Key("video_call_screen_flip_button_icon"));

  Finder findFlipButtonLoading() =>
      find.byKey(const Key("video_call_screen_flip_button_loading"));

  Finder findFlipModeOnMessage() =>
      find.text(LocaleKeys.turn_on_reverse_screen.tr());

  Finder findFlipModeOffMessage() =>
      find.text(LocaleKeys.turn_off_reverse_screen.tr());

  Finder findFlipWidgetBlind() =>
      find.byKey(const Key("video_call_screen_video_view_blind_user_flip"));

  Finder findFlipWidgetVolunteer() =>
      find.byKey(const Key("video_call_screen_video_view_volunteer_user_flip"));

  Finder findVideoViewBlind() =>
      find.byKey(const Key("video_call_screen_video_view_blind_user"));

  Finder findVideoViewVolunteer() =>
      find.byKey(const Key("video_call_screen_video_view_volunteer_user"));

  group("End Call Button", () {
    testWidgets(
        "Should call [CallActionEnded()] when end call button is tapped",
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

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.tap(findEndCallButton());
          await tester.pump();

          verify(callActionBloc.add(CallActionEnded(callingSetup.id)));
          expect(findEndCallButtonIcon(), findsOneWidget);
          expect(findEndCallButtonLoading(), findsNothing);
        });
      });
    });

    testWidgets("Should show loading indicator when [CallActionLoading]",
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

          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(const CallActionLoading(CallActionType.ended)));

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          expect(findEndCallButtonIcon(), findsNothing);
          expect(findEndCallButtonLoading(), findsOneWidget);
        });
      });
    });
  });

  group("Flashlight Button", () {
    testWidgets(
        'Should call [VideoCallSettingFlashlightUpdated()] when flashlight '
        'button is tapped', (tester) async {
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

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.tap(findFlashlightButton());
          await tester.pump();

          verify(
              videoCallBloc.add(const VideoCallSettingFlashlightUpdated(true)));
          expect(findFlashlightButtonIcon(), findsOneWidget);
          expect(findFlashlightButtonLoading(), findsNothing);
        });
      });
    });

    testWidgets(
        "Should show loading indicator when [VideoCallSettingFlashlightLoading]",
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

          when(videoCallBloc.stream).thenAnswer(
            (_) => Stream.value(
              const VideoCallSettingFlashlightLoading(
                setting: null,
                isLocalJoined: false,
                isCallEnded: false,
                isUserOffline: false,
                remoteUID: null,
              ),
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          expect(findFlashlightButtonIcon(), findsNothing);
          expect(findFlashlightButtonLoading(), findsOneWidget);
        });
      });
    });
  });

  group("Flip Button", () {
    testWidgets(
        "Should call [VideoCallSettingFlipUpdated()] when flip button is tapped",
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

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.tap(findFlipButton());
          await tester.pump();

          verify(videoCallBloc.add(const VideoCallSettingFlipUpdated(true)));
          expect(findFlipButtonIcon(), findsOneWidget);
          expect(findFlipButtonLoading(), findsNothing);
        });
      });
    });

    testWidgets(
        "Should show loading indicator when [VideoCallSettingFlipLoading]",
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

          when(videoCallBloc.stream).thenAnswer(
            (_) => Stream.value(
              const VideoCallSettingFlipLoading(
                setting: null,
                isLocalJoined: false,
                isCallEnded: false,
                isUserOffline: false,
                remoteUID: null,
              ),
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await tester.pump();

          expect(findFlipButtonIcon(), findsNothing);
          expect(findFlipButtonLoading(), findsOneWidget);
        });
      });
    });
  });

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

  group("Initial", () {
    testWidgets("Should call VideoCallBloc.add(VideoCallStarted)",
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

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));

          verify(
              videoCallBloc.add(VideoCallStarted(callingSetup: callingSetup)));
        });
      });
    });

    testWidgets("Should initialize [RtcEngine]", (tester) async {
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

          await tester.pumpApp(child: VideoCallScreen(setup: callingSetup));
          await Future.delayed(const Duration(seconds: 1));

          verifyInOrder([
            deviceInfo.requestPermissions([
              Permission.microphone,
              Permission.camera,
            ]),
            rtcEngine.initialize(any),
            rtcEngine.registerEventHandler(any),
            rtcEngine.setClientRole(role: anyNamed('role')),
            rtcEngine.enableVideo(),
            rtcEngine.enableAudio(),
            rtcEngine.enableLocalAudio(any),
            rtcEngine.setVideoEncoderConfiguration(any),
            if (callingSetup.localUser.type == UserType.volunteer) ...[
              rtcEngine.enableLocalVideo(false),
              rtcEngine.muteLocalVideoStream(true),
            ],
            rtcEngine.startPreview(),
            rtcEngine.setCameraTorchOn(false),
            rtcEngine.joinChannel(
              token: callingSetup.rtc.token,
              channelId: callingSetup.rtc.channelName,
              uid: callingSetup.rtc.uid,
              options: anyNamed('options'),
            )
          ]);
        });
      });
    });
  });

  group("Video View", () {
    CallingSetup blindUser = const CallingSetup(
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

    CallingSetup volunteerUser = const CallingSetup(
      id: "1",
      rtc: RTCIdentity(token: "abc", channelName: "a", uid: 1),
      localUser: UserCallIdentity(
        name: "name",
        uid: "uid",
        avatar: "avatar",
        type: UserType.volunteer,
      ),
      remoteUser: UserCallIdentity(
        name: "name",
        uid: "uid",
        avatar: "avatar",
        type: UserType.blind,
      ),
    );

    testWidgets("Should show video view for blind user", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: null,
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: blindUser));

          AgoraVideoView agoraVideoView =
              findAgoraView().getWidget() as AgoraVideoView;
          VideoViewControllerBase agoraController = agoraVideoView.controller;

          expect(findVideoViewBlind(), findsOneWidget);
          expect(findVideoViewVolunteer(), findsNothing);
          expect(findAgoraView(), findsOneWidget);
          expect(agoraController.rtcEngine, rtcEngine);
          expect(agoraController.canvas.uid, 0);
          expect(agoraController.connection?.channelId, null);
        });
      });
    });

    testWidgets("Should show video view for volunteer user", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: null,
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: volunteerUser));

          AgoraVideoView agoraVideoView =
              findAgoraView().getWidget() as AgoraVideoView;
          VideoViewControllerBase agoraController = agoraVideoView.controller;

          expect(findVideoViewBlind(), findsNothing);
          expect(findVideoViewVolunteer(), findsOneWidget);
          expect(findAgoraView(), findsOneWidget);
          expect(agoraController.rtcEngine, rtcEngine);
          expect(agoraController.canvas.uid, 123);
          expect(agoraController.connection?.channelId,
              volunteerUser.rtc.channelName);
        });
      });
    });

    testWidgets("Should flip video view for blind user when enableFlip is true",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: CallSetting(enableFlip: true),
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: blindUser));

          FlipWidget flipWidget =
              findFlipWidgetBlind().getWidget() as FlipWidget;

          expect(findFlipWidgetBlind(), findsOneWidget);
          expect(flipWidget.flip, true);
        });
      });
    });

    testWidgets(
        "Should not flip video view for blind user when enableFlip is false or null",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: CallSetting(enableFlip: false),
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: blindUser));

          FlipWidget flipWidget =
              findFlipWidgetBlind().getWidget() as FlipWidget;

          expect(findFlipWidgetBlind(), findsOneWidget);
          expect(flipWidget.flip, false);
        });
      });
    });

    testWidgets(
        "Should flip video view for volunteer user when enableFlip is true",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: CallSetting(enableFlip: true),
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: volunteerUser));

          FlipWidget flipWidget =
              findFlipWidgetVolunteer().getWidget() as FlipWidget;

          expect(findFlipWidgetVolunteer(), findsOneWidget);
          expect(flipWidget.flip, true);
        });
      });
    });

    testWidgets(
        'Should not flip video view for volunteer user when enableFlip is false'
        ' or null', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(videoCallBloc.state).thenReturn(
            const VideoCallState(
              setting: CallSetting(enableFlip: false),
              isLocalJoined: true,
              isCallEnded: false,
              isUserOffline: false,
              remoteUID: 123,
            ),
          );

          await tester.pumpApp(child: VideoCallScreen(setup: volunteerUser));

          FlipWidget flipWidget =
              findFlipWidgetVolunteer().getWidget() as FlipWidget;

          expect(findFlipWidgetVolunteer(), findsOneWidget);
          expect(flipWidget.flip, false);
        });
      });
    });

    testWidgets(
        'Should show AdaptiveLoading when [isLocalJoined] is false && [userType]'
        ' is blind', (tester) async {
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

          await tester.pumpApp(child: VideoCallScreen(setup: blindUser));

          expect(findAgoraView(), findsNothing);
          expect(findAdaptiveLoading(), findsOneWidget);
        });
      });
    });

    testWidgets(
        'Should show AdaptiveLoading when [remoteUID] is null && [userType]'
        ' is volunteer', (tester) async {
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

          await tester.pumpApp(child: VideoCallScreen(setup: volunteerUser));

          expect(findAgoraView(), findsNothing);
          expect(findAdaptiveLoading(), findsOneWidget);
        });
      });
    });
  });
}
