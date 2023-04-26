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
  late MockCompleter completer;
  late MockDeviceInfo deviceInfo;
  late MockDeviceSettings deviceSettings;
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
    deviceSettings = getMockDeviceSettings();
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
  Finder findSettingsButton() =>
      find.byKey(const Key("permission_message_settings_button"));

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

  group("Permission handler", () {
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

            await tester.pumpApp(child: const HomeScreen());
            await tester.tap(findPermissionCameraAllowButton());
            await tester.pump();

            // Show permanently denied message
            expect(findPermanentlyDenied(), findsOneWidget);

            // tapped settings button on alert message
            await tester.tap(findSettingsButton());
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
            await tester.tap(findSettingsButton());
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
            await tester.tap(findSettingsButton());
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
}
