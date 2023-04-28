/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
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
import 'package:soca/presentation/widgets/item/item.dart';
import 'package:soca/presentation/widgets/widgets.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findCircleAvatar() => find.byType(CircleAvatar);
  Finder findProfileImage() => find.byType(ProfileImage);

  CallHistory data = CallHistory(
    id: "1234",
    createdAt: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    endedAt: DateTime.tryParse("2023-02-11T14:12:06.182067"),
    state: CallState.waiting,
    role: CallRole.caller,
    remoteUser: User(
      id: "123",
      avatar: const URLImage(
        small: "small.png",
        medium: "medium.png",
        large: "large.png",
        original: "original.png",
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
    ),
  );

  group("Icon", () {
    testWidgets("Should show [Icon] when callState is not empty",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
                body: CallItem(CallHistory(state: CallState.waiting))),
          );

          expect(find.byType(Icon), findsOneWidget);
        });
      });
    });

    testWidgets("Should hide [Icon] when callState is empty", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(body: CallItem(CallHistory())),
          );

          expect(find.byType(Icon), findsNothing);
        });
      });
    });
  });

  group("Image", () {
    testWidgets("Should show [ProfileImage] when avatar image is not empty",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: Scaffold(body: CallItem(data)),
          );

          expect(findCircleAvatar(), findsNothing);
          expect(findProfileImage(), findsOneWidget);
        });
      });
    });

    testWidgets("Should show [CircleAvatar] when avatar image is empty",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(body: CallItem(CallHistory())),
          );

          expect(findCircleAvatar(), findsOneWidget);
          expect(findProfileImage(), findsNothing);
        });
      });
    });
  });

  group("Name Text", () {
    testWidgets("Should show name text when available", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: Scaffold(body: CallItem(data)),
          );

          expect(find.text("Firgia"), findsOneWidget);
        });
      });
    });

    testWidgets("Should not show name text when name is empty", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(body: CallItem(CallHistory())),
          );

          expect(find.text("Firgia"), findsNothing);
        });
      });
    });
  });

  group("State Text", () {
    Finder findEndedText() => find.text(LocaleKeys.call_state_ended.tr());
    Finder findCanceledText() =>
        find.text(LocaleKeys.call_state_ended_with_canceled.tr());
    Finder findOngoingText() => find.text(LocaleKeys.call_state_ongoing.tr());
    Finder findWaitingText() => find.text(LocaleKeys.call_state_waiting.tr());
    Finder findUnansweredText() =>
        find.text(LocaleKeys.call_state_ended_with_unanswered.tr());
    Finder findDeclinedText() =>
        find.text(LocaleKeys.call_state_ended_with_declined.tr());

    testWidgets("Should show ended text when callState is CallState.ended",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.ended),
              ),
            ),
          );

          expect(findEndedText(), findsOneWidget);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });

    testWidgets(
        "Should show canceled text when callState is CallState.endedWithCanceled",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.endedWithCanceled),
              ),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsOneWidget);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });

    testWidgets("Should show ongoing text when callState is CallState.ongoing",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.ongoing),
              ),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsOneWidget);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });

    testWidgets("Should show waiting text when callState is CallState.waiting",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.waiting),
              ),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsOneWidget);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });

    testWidgets(
        "Should show unanswered text when callState is CallState.endedWithUnanswered",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.endedWithUnanswered),
              ),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsOneWidget);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });

    testWidgets(
        "Should show declined text when callState is CallState.endedWithDeclined",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(
                CallHistory(state: CallState.endedWithDeclined),
              ),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsOneWidget);
        });
      });
    });

    testWidgets("Should not show text when callState is empty", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(CallHistory()),
            ),
          );

          expect(findEndedText(), findsNothing);
          expect(findCanceledText(), findsNothing);
          expect(findOngoingText(), findsNothing);
          expect(findWaitingText(), findsNothing);
          expect(findUnansweredText(), findsNothing);
          expect(findDeclinedText(), findsNothing);
        });
      });
    });
  });

  group("Time text", () {
    testWidgets("Should show time text when available", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          CallHistory data = CallHistory(createdAt: DateTime.now());

          await tester.pumpApp(
            child: Scaffold(
              body: CallItem(data),
            ),
          );

          expect(find.text(DateFormat.Hm().format(data.localCreatedAt!)),
              findsOneWidget);
        });
      });
    });

    testWidgets("Should not show time text when unavailable", (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          const CallHistory data = CallHistory();

          await tester.pumpApp(
            child: const Scaffold(
              body: CallItem(data),
            ),
          );

          expect(find.text("-"), findsOneWidget);
        });
      });
    });
  });
}
