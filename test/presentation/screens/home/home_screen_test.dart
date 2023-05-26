/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late MockAssistantCommandBloc assistantCommandBloc;
  late MockCompleter completer;
  late MockCallStatisticBloc callStatisticBloc;
  late MockDeviceInfo deviceInfo;
  late MockDeviceFeedback deviceFeedback;
  late MockDeviceSettings deviceSettings;
  late MockIncomingCallBloc incomingCallBloc;
  late MockRouteCubit routeCubit;
  late MockUserBloc userBloc;
  late MockUserRepository userRepository;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    assistantCommandBloc = getMockAssistantCommandBloc();
    completer = getMockCompleter();
    callStatisticBloc = getMockCallStatisticBloc();
    deviceInfo = getMockDeviceInfo();
    deviceFeedback = getMockDeviceFeedback();
    deviceSettings = getMockDeviceSettings();
    incomingCallBloc = getMockIncomingCallBloc();
    routeCubit = getMockRouteCubit();
    userBloc = getMockUserBloc();
    userRepository = getMockUserRepository();
    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);

    when(deviceInfo.isAndroid()).thenReturn(false);
    when(deviceInfo.isIOS()).thenReturn(true);
  });

  tearDown(() => unregisterLocator());

  Finder findCallHistoryButton() =>
      find.byKey(const Key("home_screen_call_history_button"));
  Finder findLoadingPanel() => find.byType(LoadingPanel);
  Finder findPermissionCamera() =>
      find.byKey(const Key("home_screen_permission_camera_card"));
  Finder findPermissionCardContent() =>
      find.byKey(const Key("home_screen_permission_card_content"));
  Finder findPermissionCameraAllowButton() =>
      find.byKey(const Key("home_screen_permission_camera_card_allow_button"));
  Finder findPermissionMicrophone() =>
      find.byKey(const Key("home_screen_permission_microphone_card"));
  Finder findPermissionMicrophoneAllowButton() => find
      .byKey(const Key("home_screen_permission_microphone_card_allow_button"));
  Finder findPermissionNotification() =>
      find.byKey(const Key("home_screen_permission_notification_card"));
  Finder findPermissionNotificationAllowButton() => find.byKey(
      const Key("home_screen_permission_notification_card_allow_button"));
  Finder findProfileCard() => find.byKey(const Key("home_screen_profile_card"));
  Finder findProfileCardLoading() =>
      find.byKey(const Key("home_screen_profile_card_loading"));
  Finder findVolunteerInfoCard() => find.byType(VolunteerInfoCard);
  Finder findCallVolunteerButton() => find.byType(CallVolunteerButton);
  Finder findPermanentlyDenied() =>
      find.byKey(const Key("permission_message_permanently_denied"));
  Finder findRestricted() =>
      find.byKey(const Key("permission_message_restricted"));
  Finder findMessageSettingsButton() =>
      find.byKey(const Key("permission_message_settings_button"));
  Finder findSettingsButton() =>
      find.byKey(const Key("home_screen_settings_button"));
  Finder findCallStatisticCard() =>
      find.byKey(const Key("call_statistics_card"));
  Finder findCallStatisticCardAdaptiveLoading() =>
      find.byKey(const Key("call_statistics_card_adaptive_loading"));
  Finder findCallStatisticCardLoading() =>
      find.byKey(const Key("call_statistics_card_loading"));
  Finder findCallStatisticCardEmpty() =>
      find.byKey(const Key("call_statistics_card_empty"));
  Finder findYearDropdown() => find.byType(YearDropdown);

  group("Initial", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets("Should call userBloc.add(UserFetched)", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());

        verify(userBloc.add(const UserFetched()));
      });
    });

    testWidgets("Should call assistantCommandBloc.add(AssistantCommandFetched)",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const HomeScreen());

        verify(assistantCommandBloc.add(const AssistantCommandFetched()));
      });
    });

    testWidgets("Should call callStatisticBloc.add(CallStatisticFetched)",
        (tester) async {
      await tester.runAsync(() async {
        late BuildContext context;

        await tester.pumpApp(
          child: Builder(
            builder: (ctx) {
              context = ctx;
              return const HomeScreen();
            },
          ),
        );

        verify(callStatisticBloc
            .add(CallStatisticFetched(context.locale.languageCode)));
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
          (_) => Stream.value(userDevice),
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
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

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
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

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

    testWidgets("Should fetched statistic data when refresh", (tester) async {
      await tester.runAsync(() async {
        late BuildContext context;

        await tester.pumpApp(
          child: Builder(
            builder: (ctx) {
              context = ctx;
              return const HomeScreen();
            },
          ),
        );
        await tester.setScreenSize(iphone14);

        verify(userBloc.add(const UserFetched()));
        await tester.drag(find.byType(SwipeRefresh), const Offset(0, 400));
        await tester.pump();
        verify(callStatisticBloc
            .add(CallStatisticFetched(context.locale.languageCode)));
      });
    });
  });

  group("Profile Card", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

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
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets(
        'Should navigate to create call page when [AssistantCommandCallVolunteerLoaded]',
        (tester) async {
      await tester.runAsync(() async {
        const User user = User(id: "123");
        when(assistantCommandBloc.stream).thenAnswer(
          (_) => Stream.value(
            const AssistantCommandCallVolunteerLoaded(user),
          ),
        );

        await tester.pumpApp(child: const HomeScreen());

        verify(
          appNavigator.goToCreateCall(
            any,
            user: user,
          ),
        );

        verify(assistantCommandBloc.add(const AssistantCommandEventRemoved()));
      });
    });

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
          (_) => Stream.value(userDevice),
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
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

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
        await tester.pump();

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

  group("Permission handler", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    group("Content", () {
      testWidgets(
          'Should show permission card content when permission '
          'camera, microphone, or notification is not granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
            (_) => Future.value(PermissionStatus.denied),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionCardContent(), findsOneWidget);
        });
      });

      testWidgets(
          'Should hide permission card content when permission '
          'camera, microphone, and notification is granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );
          when(deviceInfo.getPermissionStatus(Permission.microphone))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );
          when(deviceInfo.getPermissionStatus(Permission.notification))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionCardContent(), findsNothing);
        });
      });
    });

    group("Camera card", () {
      testWidgets(
          'Should show camera permission card when permission camera'
          ' is not granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
            (_) => Future.value(PermissionStatus.denied),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionCamera(), findsOneWidget);
        });
      });

      testWidgets(
          'Should hide camera permission card when permission camera'
          ' is granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionCamera(), findsNothing);
        });
      });

      group("Allow button pressed", () {
        testWidgets(
            'Should request permission when current permission status is denied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionCameraAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.camera));
          });
        });

        testWidgets(
            'Should open settings when user not allow request permission',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.requestPermission(Permission.camera)).thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );
            when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionCameraAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.camera));
            verify(deviceSettings.openAppSettings());
          });
        });

        testWidgets(
            'Should show Permission Permanently Denied Message when current '
            'permission status is PermissionStatus.permanentlyDenied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
              (_) => Future.value(PermissionStatus.permanentlyDenied),
            );

            await tester.setScreenSize(ipad12Pro);
            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionCameraAllowButton());
            await tester.pump();

            // Show permanently denied message
            expect(findPermanentlyDenied(), findsOneWidget);

            // tapped settings button on alert message
            await tester.tap(findMessageSettingsButton());
            await tester.pump();
            verify(deviceSettings.openAppSettings());
          });
        });

        testWidgets(
            'Should show Permission Restricted Message when current '
            'permission status is PermissionStatus.restricted', (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.camera)).thenAnswer(
              (_) => Future.value(PermissionStatus.restricted),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionCameraAllowButton());
            await tester.pump();

            expect(findRestricted(), findsOneWidget);
          });
        });
      });
    });

    group("Microphone card", () {
      testWidgets(
          'Should show microphone permission card when permission microphone'
          ' is not granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.microphone))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.denied),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionMicrophone(), findsOneWidget);
        });
      });

      testWidgets(
          'Should hide microphone permission card when permission microphone'
          ' is granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.microphone))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionMicrophone(), findsNothing);
        });
      });

      group("Allow button pressed", () {
        testWidgets(
            'Should request permission when current permission status is denied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.microphone))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionMicrophoneAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.microphone));
          });
        });

        testWidgets(
            'Should open settings when user not allow request permission',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.requestPermission(Permission.microphone))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );
            when(deviceInfo.getPermissionStatus(Permission.microphone))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionMicrophoneAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.microphone));
            verify(deviceSettings.openAppSettings());
          });
        });

        testWidgets(
            'Should show Permission Permanently Denied Message when current '
            'permission status is PermissionStatus.permanentlyDenied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.microphone))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.permanentlyDenied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionMicrophoneAllowButton());
            await tester.pump();

            // Show permanently denied message
            expect(findPermanentlyDenied(), findsOneWidget);

            // tapped settings button on alert message
            await tester.tap(findMessageSettingsButton());
            await tester.pump();
            verify(deviceSettings.openAppSettings());
          });
        });

        testWidgets(
            'Should show Permission Restricted Message when current '
            'permission status is PermissionStatus.restricted', (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.microphone))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.restricted),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionMicrophoneAllowButton());
            await tester.pump();

            expect(findRestricted(), findsOneWidget);
          });
        });
      });
    });

    group("Notification card", () {
      testWidgets(
          'Should show notification permission card when permission notification'
          ' is not granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.notification))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.denied),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionNotification(), findsOneWidget);
        });
      });

      testWidgets(
          'Should hide notification permission card when permission notification'
          ' is granted', (tester) async {
        await tester.runAsync(() async {
          when(deviceInfo.getPermissionStatus(Permission.notification))
              .thenAnswer(
            (_) => Future.value(PermissionStatus.granted),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findPermissionNotification(), findsNothing);
        });
      });

      group("Allow button pressed", () {
        testWidgets(
            'Should request permission when current permission status is denied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.notification))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionNotificationAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.notification));
          });
        });

        testWidgets(
            'Should open settings when user not allow request permission',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.requestPermission(Permission.notification))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );
            when(deviceInfo.getPermissionStatus(Permission.notification))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.denied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionNotificationAllowButton());
            await tester.pump();

            verify(deviceInfo.requestPermission(Permission.notification));
            verify(deviceSettings.openNotificationSettings());
          });
        });

        testWidgets(
            'Should show Permission Permanently Denied Message when current '
            'permission status is PermissionStatus.permanentlyDenied',
            (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.notification))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.permanentlyDenied),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionNotificationAllowButton());
            await tester.pump();

            // Show permanently denied message
            expect(findPermanentlyDenied(), findsOneWidget);

            // tapped settings button on alert message
            await tester.tap(findMessageSettingsButton());
            await tester.pump();
            verify(deviceSettings.openNotificationSettings());
          });
        });

        testWidgets(
            'Should show Permission Restricted Message when current '
            'permission status is PermissionStatus.restricted', (tester) async {
          await tester.runAsync(() async {
            when(deviceInfo.getPermissionStatus(Permission.notification))
                .thenAnswer(
              (_) => Future.value(PermissionStatus.restricted),
            );

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionNotificationAllowButton());
            await tester.pump();

            expect(findRestricted(), findsOneWidget);
          });
        });
      });
    });
  });

  group("Call Statistic", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    group("Year Dropdown", () {
      testWidgets(
          'Should show when [listOfYear] data on CallStatisticState is not empty ',
          (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(const CallStatisticState(
              calls: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                ),
              ],
              listOfYear: ["2020"],
              selectedYear: "2020",
              totalCall: 20,
              totalDayJoined: 10,
              userType: null,
            )),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findYearDropdown(), findsOneWidget);
        });
      });

      testWidgets(
          'Should hide when [listOfYear] data on CallStatisticState is empty ',
          (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(const CallStatisticState(
              calls: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                ),
              ],
              listOfYear: [],
              selectedYear: "2020",
              totalCall: 20,
              totalDayJoined: 10,
              userType: null,
            )),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findYearDropdown(), findsNothing);
        });
      });

      testWidgets(
          'Should call callStatisticBloc.add(CallStatisticYearChanged) when '
          'year is selected', (tester) async {
        await tester.runAsync(() async {
          late BuildContext context;

          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(const CallStatisticState(
              calls: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                ),
              ],
              listOfYear: ["2020", "2021"],
              selectedYear: "2020",
              totalCall: 20,
              totalDayJoined: 10,
              userType: null,
            )),
          );

          await tester.pumpApp(child: Builder(builder: (ctx) {
            context = ctx;

            return const HomeScreen();
          }));

          await tester.pump();

          await tester.tap(find.text("2020"));
          await tester.pump();

          await tester.tap(find.text("2021").last);
          await tester.pump();

          verify(callStatisticBloc.add(CallStatisticYearChanged(
            year: "2021",
            locale: context.locale.languageCode,
          )));
        });
      });
    });

    group("CallStatisticsCard", () {
      testWidgets(
          'Should show when [calls] data on CallStatisticState is not empty ',
          (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(const CallStatisticState(
              calls: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                ),
              ],
              listOfYear: ["2020"],
              selectedYear: "2020",
              totalCall: 20,
              totalDayJoined: 10,
              userType: null,
            )),
          );

          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findCallStatisticCard(), findsOneWidget);
          expect(findCallStatisticCardAdaptiveLoading(), findsNothing);
          expect(findCallStatisticCardLoading(), findsNothing);
          expect(findCallStatisticCardEmpty(), findsNothing);
        });
      });
    });

    group("CallStatisticCard.loading", () {
      testWidgets('Should show when [CallStatisticLoading]', (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(const CallStatisticLoading(
              calls: [],
              listOfYear: [],
              selectedYear: null,
              totalCall: null,
              totalDayJoined: null,
              userType: null,
            )),
          );
          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findCallStatisticCard(), findsNothing);
          expect(findCallStatisticCardAdaptiveLoading(), findsNothing);
          expect(findCallStatisticCardLoading(), findsOneWidget);
          expect(findCallStatisticCardEmpty(), findsNothing);
        });
      });

      testWidgets('Should show when [CallStatisticError]', (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(
              const CallStatisticError(
                calls: [],
                listOfYear: [],
                selectedYear: null,
                totalCall: null,
                totalDayJoined: null,
                userType: null,
              ),
            ),
          );
          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findCallStatisticCard(), findsNothing);
          expect(findCallStatisticCardAdaptiveLoading(), findsNothing);
          expect(findCallStatisticCardLoading(), findsOneWidget);
          expect(findCallStatisticCardEmpty(), findsNothing);
        });
      });
    });

    group("CallStatisticCard.empty", () {
      testWidgets(
          'Should show when CallStatisticError with CallingFailureCode '
          'is not found', (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(
              const CallStatisticError(
                calls: [],
                listOfYear: [],
                selectedYear: null,
                totalCall: null,
                totalDayJoined: null,
                userType: null,
                callingFailure:
                    CallingFailure(code: CallingFailureCode.notFound),
              ),
            ),
          );
          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findCallStatisticCard(), findsNothing);
          expect(findCallStatisticCardAdaptiveLoading(), findsNothing);
          expect(findCallStatisticCardLoading(), findsNothing);
          expect(findCallStatisticCardEmpty(), findsOneWidget);
        });
      });

      testWidgets(
          'Should show when [calls] data on CallStatisticState is empty',
          (tester) async {
        await tester.runAsync(() async {
          when(callStatisticBloc.stream).thenAnswer(
            (_) => Stream.value(
              const CallStatisticState(
                calls: [],
                listOfYear: [],
                selectedYear: null,
                totalCall: null,
                totalDayJoined: null,
                userType: null,
              ),
            ),
          );
          await tester.pumpApp(child: const HomeScreen());
          await tester.pump();

          expect(findCallStatisticCard(), findsNothing);
          expect(findCallStatisticCardAdaptiveLoading(), findsNothing);
          expect(findCallStatisticCardLoading(), findsNothing);
          expect(findCallStatisticCardEmpty(), findsOneWidget);
        });
      });
    });
  });

  group("Call History Button", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets("Should show call history button", (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        await tester.drag(find.byType(SwipeRefresh), const Offset(0, -100));
        await tester.pump();

        expect(findCallHistoryButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should navigate to call history page when call history button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        await tester.drag(find.byType(SwipeRefresh), const Offset(0, -100));
        await tester.pump();

        await tester.ensureVisible(findCallHistoryButton());
        await tester.tap(findCallHistoryButton());
        await tester.pump();

        verify(appNavigator.goToCallHistory(any));
      });
    });
  });

  group("Settings Button", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets("Should show call settings button", (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        await tester.drag(find.byType(SwipeRefresh), const Offset(0, -100));
        await tester.pump();

        expect(findSettingsButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should navigate to settings page when settings button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        await tester.drag(find.byType(SwipeRefresh), const Offset(0, -100));
        await tester.pump();

        await tester.ensureVisible(findSettingsButton());
        await tester.tap(findSettingsButton());
        await tester.pump();

        verify(appNavigator.goToSettings(any));
      });
    });
  });

  group("On Volume Changed", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets(
        'Should create call when volume changed to up and down '
        'and user type is blind', (tester) async {
      await tester.runAsync(() async {
        const User user = User(id: "123", type: UserType.blind);
        final volumeChanged = StreamController<double>();

        when(deviceInfo.onVolumeUpAndDown)
            .thenAnswer((_) => volumeChanged.stream);
        when(userBloc.stream)
            .thenAnswer((_) => Stream.value(const UserLoaded(user)));

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        volumeChanged.add(.6);
        await Future.delayed(const Duration(milliseconds: 2100));
        volumeChanged.add(.5);
        await tester.pump();

        verify(appNavigator.goToCreateCall(any, user: user));
      });
    });

    testWidgets(
        'Should not to create call when volume changed to up and down '
        'but user type is not blind', (tester) async {
      await tester.runAsync(() async {
        final volumeChanged = StreamController<double>();

        const User user = User(id: "123", type: UserType.volunteer);
        when(deviceInfo.onVolumeUpAndDown)
            .thenAnswer((_) => volumeChanged.stream);

        when(userBloc.stream).thenAnswer(
            (realInvocation) => Stream.value(const UserLoaded(user)));

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        volumeChanged.add(.6);
        await Future.delayed(const Duration(milliseconds: 2100));
        volumeChanged.add(.5);
        await tester.pump();

        verifyNever(appNavigator.goToCreateCall(any, user: user));
      });
    });
  });

  group("Voice Assistant", () {
    setUp(() {
      when(callStatisticBloc.state).thenReturn(const CallStatisticState(
        calls: [],
        listOfYear: [],
        selectedYear: null,
        totalCall: null,
        totalDayJoined: null,
        userType: null,
      ));
    });

    testWidgets('Should play home info for blind user', (tester) async {
      await tester.runAsync(() async {
        const User user = User(id: "123", type: UserType.blind);

        when(userBloc.stream)
            .thenAnswer((_) => Stream.value(const UserLoaded(user)));

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        verify(
          deviceFeedback.playVoiceAssistant([
            LocaleKeys.va_home_page.tr(),
            LocaleKeys.va_home_page_blind_info.tr()
          ], any),
        );
      });
    });

    testWidgets('Should play home info for volunteer user', (tester) async {
      await tester.runAsync(() async {
        const User user = User(id: "123", type: UserType.volunteer);

        when(userBloc.stream)
            .thenAnswer((_) => Stream.value(const UserLoaded(user)));

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const HomeScreen());

        verify(
          deviceFeedback.playVoiceAssistant([
            LocaleKeys.va_home_page.tr(),
            LocaleKeys.va_home_page_volunteer_info.tr()
          ], any),
        );
      });
    });
  });
}
