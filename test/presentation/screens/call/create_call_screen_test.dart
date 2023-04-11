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
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    appNavigator = getMockAppNavigator();
    callActionBloc = getMockCallActionBloc();

    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findCallBackgroundImage() => find.byType(CallBackgroundImage);
  Finder findCancelButton() => find.byType(CancelCallButton);
  Finder findErrorMessage() => find.byType(ErrorMessage);
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
    testWidgets("Should show error choose message when [CallActionError]",
        (tester) async {
      await mockNetworkImages(() async {
        await tester.runAsync(() async {
          when(callActionBloc.stream).thenAnswer((_) =>
              Stream.value(const CallActionError(CallActionType.answered)));

          await tester.pumpApp(child: CreateCallScreen(user: user));
          await tester.pump();
          expect(findErrorMessage(), findsOneWidget);
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

    // testWidgets("Should call [CallActionEnded()] when cancel button is tapped",
    //     (tester) async {
    //   await mockNetworkImages(() async {
    //     await tester.runAsync(() async {
    //       await tester.pumpApp(
    //         child: CreateCallScreen(user: user),
    //       );

    //       await tester.tap(findCancelButton());
    //       await tester.pumpAndSettle();

    //        verify(callActionBloc.add(CallActionEnded(-)))
    //     });
    //   });
    // });
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
}
