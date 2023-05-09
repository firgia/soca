/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
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
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockCallActionBloc callActionBloc;
  late MockCallKit callKit;
  late MockDeviceFeedback deviceFeedback;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    callActionBloc = getMockCallActionBloc();
    callKit = getMockCallKit();
    deviceFeedback = getMockDeviceFeedback();
    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findCallBackgroundImage() => find.byType(CallBackgroundImage);
  Finder findCancelButton() => find.byType(CancelCallButton);
  Finder findErrorMessageText() =>
      find.text(LocaleKeys.error_something_wrong.tr());
  Finder findEndCallSuccessfullyText() =>
      find.text(LocaleKeys.end_call_successfully.tr());

  String callID = "456";
  String blindID = "123";
  String? name = "name";
  String? urlImage = "test";

  group("Bloc Listener", () {
    testWidgets(
        "Should show error message and back to previous pagewhen [CallActionError]",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(const CallActionError(CallActionType.answered)));

          await tester.pumpApp(
              child: AnswerCallScreen(
                  callID: callID,
                  blindID: blindID,
                  name: name,
                  urlImage: urlImage));
          await tester.pump();
          expect(findErrorMessageText(), findsOneWidget);
          verify(appNavigator.back(any));
        });
      });
    });

    testWidgets(
        'Should back to previous page and end all calls when [CallActionEndedSuccessfully]',
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer(
              (_) => Stream.value(const CallActionEndedSuccessfully()));

          await tester.pumpApp(
              child: AnswerCallScreen(
                  callID: callID,
                  blindID: blindID,
                  name: name,
                  urlImage: urlImage));
          await tester.pump();
          verify(appNavigator.back(any));
          verify(callKit.endAllCalls());
          expect(findEndCallSuccessfullyText(), findsOneWidget);
        });
      });
    });

    testWidgets(
        'Should go to Video call page when '
        '[CallActionAnsweredSuccessfully]', (tester) async {
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

          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(CallActionAnsweredSuccessfully(callingSetup)));

          await tester.pumpApp(
              child: AnswerCallScreen(
                  callID: callID,
                  blindID: blindID,
                  name: name,
                  urlImage: urlImage));
          await Future.delayed(const Duration(seconds: 2));
          await tester.pump();

          verify(appNavigator.goToVideoCall(any, setup: callingSetup));
        });
      });
    });
  });

  group("Initial", () {
    testWidgets("Should call callActionBloc.add(CallActionAnswered)",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
          );

          verify(callActionBloc.add(CallActionAnswered(
            blindID: blindID,
            callID: callID,
          )));
        });
      });
    });
  });

  group("Background Image", () {
    testWidgets("Should show [CallBackgroundImage]", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
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
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
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
                const CallActionLoading(CallActionType.answered),
                CallActionAnsweredSuccessfullyWithWaitingCaller(call),
              ]));

          await tester.pumpApp(
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
          );

          // Request to end call when Answer call not completed yet
          await tester.tap(findCancelButton());
          await tester.pump();
          expect(find.byType(AdaptiveLoading), findsOneWidget);

          // Execute request end call when Answer call is completed but waiting
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
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
          );

          expect(find.text(name), findsOneWidget);
        });
      });
    });

    testWidgets("Should show calling volunteer text", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: AnswerCallScreen(
                callID: callID,
                blindID: blindID,
                name: name,
                urlImage: urlImage),
          );

          expect(
              find.text(LocaleKeys.async_answering_call.tr()), findsOneWidget);
        });
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets('Should play answering call info', (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: AnswerCallScreen(
              callID: callID,
              blindID: blindID,
              name: name,
              urlImage: urlImage,
            ),
          );
          verify(
            deviceFeedback.playVoiceAssistant(
              [
                LocaleKeys.va_async_answering_call.tr(),
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

          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(CallActionAnsweredSuccessfully(callingSetup)));

          await tester.pumpApp(
              child: AnswerCallScreen(
                  callID: callID,
                  blindID: blindID,
                  name: name,
                  urlImage: urlImage));
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
}
