/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

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
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockCallActionBloc callActionBloc;
  late MockCallKit callKit;
  late MockDeviceInfo deviceInfo;
  late MockDeviceFeedback deviceFeedback;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    callActionBloc = getMockCallActionBloc();
    callKit = getMockCallKit();
    deviceInfo = getMockDeviceInfo();
    deviceFeedback = getMockDeviceFeedback();

    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findCallBackgroundImage() => find.byType(CallBackgroundImage);
  Finder findCancelButton() => find.byType(CancelCallButton);
  Finder findErrorMessageText() =>
      find.text(LocaleKeys.error_something_wrong.tr());
  Finder findEndCallSuccessfullyText() =>
      find.text(LocaleKeys.end_call_successfully.tr());
  Finder findNoVolunteerText() =>
      find.text(LocaleKeys.fail_to_call_no_volunteers.tr());

  User user = User(
    id: "123",
    avatar: const URLImage(
      small: "https://www.w3schools.com/w3images/avatar2.png",
      medium: "https://www.w3schools.com/w3images/avatar2.png",
      large: "https://www.w3schools.com/w3images/avatar2.png",
      original: "https://www.w3schools.com/w3images/avatar2.png",
    ),
    activity: UserActivity(
      online: true,
      lastSeen: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    ),
    dateOfBirth: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    gender: Gender.male,
    language: const ["id", "en"],
    name: "Firgia",
    info: UserInfo(
      dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
      listOfCallYears: const ["2022", "2023"],
      totalCalls: 12,
      totalFriends: 13,
      totalVisitors: 14,
    ),
    type: UserType.volunteer,
  );

  group("Bloc Listener", () {
    testWidgets(
        "Should show error message and back to previous pagewhen [CallActionError]",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(const CallActionError(CallActionType.answered)));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();
          expect(findErrorMessageText(), findsOneWidget);
          verify(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        'Should back to previous page and show unanswered message when '
        '[CallActionCreatedUnanswered]', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(const CallActionCreatedUnanswered()));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();

          verify(appNavigator.back(any));
          expect(findNoVolunteerText(), findsOneWidget);
        });
      });
    });

    testWidgets(
        'Should go to Video call page and start call when '
        '[CallActionCreatedSuccessfully]', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
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

          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(CallActionCreatedSuccessfully(callingSetup)));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();

          verify(
            callKit.startCall(
              CallKitArgument(
                id: "1",
                nameCaller: "name",
                handle: LocaleKeys.volunteer.tr(),
                type: 1,
              ),
            ),
          );

          verify(appNavigator.goToVideoCall(any, setup: callingSetup));
        });
      });
    });

    testWidgets(
        'Should back to previous page and end all calls when '
        '[CallActionEndedSuccessfully]', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(const CallActionEndedSuccessfully()));

          await tester.pumpApp(child: CreateCallScreen(user: user));

          await tester.pump();
          verify(appNavigator.back(any));
          expect(findEndCallSuccessfullyText(), findsOneWidget);
        });
      });
    });
  });

  group("Initial", () {
    testWidgets("Should call callActionBloc.add(CallActionCreated)",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          verify(callActionBloc.add(const CallActionCreated()));
        });
      });
    });
  });

  group("Background Image", () {
    testWidgets("Should show [CallBackgroundImage]", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          expect(findCallBackgroundImage(), findsOneWidget);
        });
      });
    });
  });

  group("Cancel Button", () {
    testWidgets("Should show [CancelButton]", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          expect(findCancelButton(), findsOneWidget);
        });
      });
    });

    testWidgets("Should call [CallActionEnded()] when cancel button is tapped",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          Call call = const Call(id: "123");

          when(callActionBloc.stream).thenAnswer((_) => Stream.fromIterable([
                const CallActionLoading(CallActionType.created),
                CallActionCreatedSuccessfullyWithWaitingAnswer(call),
              ]));

          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          // Request to end call when Create call not completed yet
          await tester.tap(findCancelButton());
          await tester.pump();
          expect(find.byType(AdaptiveLoading), findsOneWidget);

          // Execute request end call when Create call is completed but waiting
          // the answer
          await Future.delayed(const Duration(milliseconds: 200));
          await tester.pump();
          verify(callActionBloc.add(CallActionEnded(call.id!))).called(1);
        });
      });
    });
  });

  group("Text", () {
    testWidgets("Should show user name text", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          expect(find.text(user.name!), findsOneWidget);
        });
      });
    });

    testWidgets("Should show calling volunteer text", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          expect(find.text(LocaleKeys.async_calling_volunteer.tr()),
              findsOneWidget);
        });
      });
    });
  });

  group("On Volume Changed", () {
    testWidgets(
        'Should cancel call when volume changed to up and down under 1 second',
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          StreamController<double> volumeUpAndDown = StreamController<double>();

          when(deviceInfo.onVolumeUpAndDown)
              .thenAnswer((_) => volumeUpAndDown.stream);

          Call call = const Call(id: "123");

          when(callActionBloc.stream).thenAnswer((_) => Stream.fromIterable([
                const CallActionLoading(CallActionType.created),
                CallActionCreatedSuccessfullyWithWaitingAnswer(call),
              ]));

          await tester.pumpApp(
            child: CreateCallScreen(user: user),
          );

          // Execute request end call when Create call is completed but waiting
          // the answer
          await Future.delayed(const Duration(milliseconds: 1200));

          volumeUpAndDown.sink.add(.2);
          await Future.delayed(const Duration(seconds: 2));
          volumeUpAndDown.sink.add(.3);
          await tester.pump();

          verify(callActionBloc.add(CallActionEnded(call.id!))).called(1);
        });
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets('Should play calling volunteer info', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: CreateCallScreen(user: user));

          verify(
            deviceFeedback.playVoiceAssistant(
              [
                LocaleKeys.va_async_calling_volunteer.tr(),
              ],
              any,
              immediately: true,
            ),
          );
        });
      });
    });

    testWidgets(
        'Should play starting call when [CallActionAnsweredSuccessfully]',
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
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

          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(CallActionCreatedSuccessfully(callingSetup)));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();

          verify(
            deviceFeedback.playVoiceAssistant(
              [
                LocaleKeys.va_starting_video_call.tr(),
              ],
              any,
              immediately: true,
            ),
          );
        });
      });
    });
  });

  group("Vibration", () {
    testWidgets('Should play vibration', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: CreateCallScreen(user: user));

          verify(
            deviceFeedback.playCallVibration(),
          );
        });
      });
    });

    testWidgets('Should stop vibration when [CallActionAnsweredSuccessfully]',
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
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

          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(CallActionCreatedSuccessfully(callingSetup)));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();

          verify(deviceFeedback.stopCallVibration());
        });
      });
    });

    testWidgets('Should stop vibration when page disposed', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          StreamController<Widget> widgetStreamController =
              StreamController<Widget>();

          await tester.pumpApp(
              child: StreamBuilder(
            stream: widgetStreamController.stream,
            builder: (context, snapshot) => snapshot.data ?? Container(),
          ));

          widgetStreamController.add(CreateCallScreen(user: user));
          await tester.pumpAndSettle();

          widgetStreamController.add(const Scaffold());
          await tester.pumpAndSettle();

          verify(deviceFeedback.stopCallVibration());
        });
      });
    });
  });
}
