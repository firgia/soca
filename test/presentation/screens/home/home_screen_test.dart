/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockCompleter completer;
  late MockDeviceInfo deviceInfo;
  late MockIncomingCallBloc incomingCallBloc;
  late MockRouteCubit routeCubit;
  late MockUserBloc userBloc;
  late MockUserRepository userRepository;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    completer = getMockCompleter();
    deviceInfo = getMockDeviceInfo();
    incomingCallBloc = getMockIncomingCallBloc();
    routeCubit = getMockRouteCubit();
    userBloc = getMockUserBloc();
    userRepository = getMockUserRepository();
    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
    when(deviceInfo.isAndroid()).thenReturn(false);
    when(deviceInfo.isIOS()).thenReturn(true);
  });

  tearDown(() => unregisterLocator());

  Finder findLoadingPanel() => find.byType(LoadingPanel);
  Finder findProfileCard() => find.byKey(const Key("home_screen_profile_card"));
  Finder findProfileCardLoading() =>
      find.byKey(const Key("home_screen_profile_card_loading"));
  Finder findVolunteerInfoCard() => find.byType(VolunteerInfoCard);
  Finder findCallVolunteerButton() => find.byType(CallVolunteerButton);

  group("Initial", () {
    testWidgets("Should call userBloc.add(UserFetched)", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());

        verify(userBloc.add(const UserFetched()));
      });
    });

    testWidgets("Should call incomingCallBloc.add(IncomingCallFetched)",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());

        verify(incomingCallBloc.add(const IncomingCallFetched()));
      });
    });

    testWidgets("Should listen userRepository.onUserDeviceUpdated",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());

        verify(userRepository.onUserDeviceUpdated);
      });
    });

    testWidgets(
        "Should call routeCubit.getTargetRoute() when device is updated",
        (tester) async {
      UserDevice userDevice = const UserDevice(id: "1234");

      await tester.runAsync(() async {
        when(userRepository.onUserDeviceUpdated).thenAnswer(
          (realInvocation) => Stream.value(userDevice),
        );

        await tester.pumpApp(child: const HomeScreen());

        verify(
          routeCubit.getTargetRoute(
            checkDifferentDevice: true,
            userDevice: userDevice,
          ),
        );
      });
    });
  });

  group("Loading", () {
    testWidgets('Should hide [LoadingPanel] when state is not [RouteLoading] ',
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.state).thenReturn(const RouteError());

        await tester.pumpApp(child: const HomeScreen());
        expect(findLoadingPanel(), findsNothing);
      });
    });

    testWidgets("Should show LoadingPanel when state is [RouteLoading]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.state).thenReturn(const RouteLoading());

        await tester.pumpApp(child: const HomeScreen());
        expect(findLoadingPanel(), findsOneWidget);
      });
    });
  });

  group("Refresh", () {
    testWidgets("Should fetched user data when refresh", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());
        await tester.setScreenSize(iphone14);

        verify(userBloc.add(const UserFetched()));
        await tester.drag(find.byType(SwipeRefresh), const Offset(0, 400));
        await tester.pump();
        verify(userBloc.add(UserFetched(completer: completer)));
      });
    });
  });

  group("Profile Card", () {
    testWidgets('Should show profile card when [UserState] is [UserLoaded]',
        (tester) async {
      User user = const User(id: "1234", name: "Mochamad Firgia");

      await tester.runAsync(() async {
        when(userBloc.stream).thenAnswer((_) => Stream.value(UserLoaded(user)));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        expect(findProfileCard(), findsOneWidget);
        expect(findProfileCardLoading(), findsNothing);

        ProfileCard profileCard = findProfileCard().getWidget() as ProfileCard;
        expect(profileCard.user, user);
      });
    });

    testWidgets(
        'Should show profile card loading when [UserState] is not [UserLoaded]',
        (tester) async {
      await tester.runAsync(() async {
        when(userBloc.stream)
            .thenAnswer((_) => Stream.value(const UserEmpty()));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        expect(findProfileCard(), findsNothing);
        expect(findProfileCardLoading(), findsOneWidget);
      });
    });
  });

  group("Bloc Listener", () {
    testWidgets('Should navigate to answer call page when [IncomingCallLoaded]',
        (tester) async {
      await tester.runAsync(() async {
        when(incomingCallBloc.stream).thenAnswer(
          (_) => Stream.value(
            const IncomingCallLoaded(
              blindID: "123",
              id: "456",
              name: "test",
              urlImage: "avatar.jpg",
            ),
          ),
        );

        await tester.pumpApp(child: const HomeScreen());

        verify(
          appNavigator.goToAnswerCall(
            any,
            callID: "456",
            blindID: "123",
            name: "test",
            urlImage: "avatar.jpg",
          ),
        );

        verify(incomingCallBloc.add(const IncomingCallEventRemoved()));
      });
    });

    testWidgets(
        'Should navigate to Unknown Device page when [RouteTarget] is '
        '[AppPages.unknownDevice]', (tester) async {
      UserDevice userDevice = const UserDevice(id: "1234");

      await tester.runAsync(() async {
        when(userRepository.onUserDeviceUpdated).thenAnswer(
          (realInvocation) => Stream.value(userDevice),
        );

        when(routeCubit.stream).thenAnswer(
            (_) => Stream.value(RouteTarget(AppPages.unknownDevice)));
        await tester.pumpApp(child: const HomeScreen());

        verify(
          routeCubit.getTargetRoute(
            checkDifferentDevice: true,
            userDevice: userDevice,
          ),
        );

        verify(appNavigator.goToUnknownDevice(any));
      });
    });
  });

  group("User Action", () {
    testWidgets('Should show VolunteerInfoCard when user type is volunteer',
        (tester) async {
      User user = const User(
        id: "1234",
        name: "Mochamad Firgia",
        type: UserType.volunteer,
      );

      await tester.runAsync(() async {
        when(userBloc.stream).thenAnswer((_) => Stream.value(UserLoaded(user)));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        expect(findVolunteerInfoCard(), findsOneWidget);
        expect(findCallVolunteerButton(), findsNothing);
      });
    });

    testWidgets('Should show CallVolunteerButton when user type is blind',
        (tester) async {
      User user = const User(
        id: "1234",
        name: "Mochamad Firgia",
        type: UserType.blind,
      );

      await tester.runAsync(() async {
        when(userBloc.stream).thenAnswer((_) => Stream.value(UserLoaded(user)));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        expect(findVolunteerInfoCard(), findsNothing);
        expect(findCallVolunteerButton(), findsOneWidget);
      });
    });

    testWidgets(
        'Should navigate to create call page when CallVolunteerButton '
        'button is pressed', (tester) async {
      User user = const User(
        id: "1234",
        name: "Mochamad Firgia",
        type: UserType.blind,
      );

      await tester.runAsync(() async {
        when(userBloc.stream).thenAnswer((_) => Stream.value(UserLoaded(user)));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        await tester.tap(findCallVolunteerButton());
        await tester.pumpAndSettle();

        verify(appNavigator.goToCreateCall(any, user: user));
      });
    });

    testWidgets(
        'Should hide CallVolunteerButton and VolunteerInfoCard when '
        'user type is empty', (tester) async {
      User user = const User(
        id: "1234",
        name: "Mochamad Firgia",
      );

      await tester.runAsync(() async {
        when(userBloc.stream).thenAnswer((_) => Stream.value(UserLoaded(user)));

        await tester.pumpApp(child: const HomeScreen());
        await tester.pump();

        expect(findVolunteerInfoCard(), findsNothing);
        expect(findCallVolunteerButton(), findsNothing);
      });
    });
  });
}
