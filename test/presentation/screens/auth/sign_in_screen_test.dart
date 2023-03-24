/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockDeviceInfo deviceInfo;
  late MockRouteCubit routeCubit;
  late MockSignInBloc signInBloc;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    deviceInfo = getMockDeviceInfo();
    routeCubit = getMockRouteCubit();
    signInBloc = getMockSignInBloc();
    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  Finder findErrorMessageSomethingError() =>
      find.byKey(const Key("error_message_something_error"));
  Finder findLoadingPanel() => find.byType(LoadingPanel);
  Finder findOkText() => find.text(LocaleKeys.ok.tr());
  Finder findSignInText() => find.text(LocaleKeys.sign_in.tr());
  Finder findSignInInfoText() => find.text(LocaleKeys.sign_in_info.tr());
  Finder findSignInWithAppleButton() => find.byType(SignInWithAppleButton);
  Finder findSignInWithGoogleButton() => find.byType(SignInWithGoogleButton);
  Finder findVolunteerSignInInfoText() =>
      find.text(LocaleKeys.volunteer_sign_in_info.tr());

  group("Icons", () {
    testWidgets("Should show the app icon", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(find.byType(SocaIconImage), findsOneWidget);
      });
    });
  });

  group("Loading", () {
    testWidgets(
        'Should hide [LoadingPanel] when state is not [RouteLoading] or '
        '[SignInLoading]', (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.state).thenReturn(const RouteError());
        when(signInBloc.state).thenReturn(const SignInError());

        await tester.pumpApp(child: SignInScreen());
        expect(findLoadingPanel(), findsNothing);
      });
    });

    testWidgets("Should show LoadingPanel when state is [RouteLoading]",
        (tester) async {
      await tester.runAsync(() async {
        when(routeCubit.state).thenReturn(const RouteLoading());

        await tester.pumpApp(child: SignInScreen());
        expect(findLoadingPanel(), findsOneWidget);
      });
    });

    testWidgets("Should show LoadingPanel when state is [SignInLoading]",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.state).thenReturn(const SignInLoading());

        await tester.pumpApp(child: SignInScreen());
        expect(findLoadingPanel(), findsOneWidget);
      });
    });
  });

  group("Routing", () {
    testWidgets("Should call getTargetRoute() when [SignInSuccessfully]",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(findSignInWithGoogleButton());
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
        verify(routeCubit.getTargetRoute(checkDifferentDevice: false));
      });
    });

    testWidgets(
        "Should navigate to home page when [RouteTarget(AppPages.home)]",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.home)));

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(findSignInWithGoogleButton());
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
        verify(appNavigator.goToHome(any));
      });
    });

    testWidgets(
        "Should navigate to sign up page when [RouteTarget(AppPages.signUp)]",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.signUp)));

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(findSignInWithGoogleButton());
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
        verify(appNavigator.goToSignUp(any));
      });
    });

    testWidgets("Should show alert something error when getting error",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(const RouteError()));
        await tester.pumpApp(child: SignInScreen());

        await tester.tapAt(tester.getCenter(findSignInWithGoogleButton()));
        await tester.pump();

        expect(
          findErrorMessageSomethingError(),
          findsOneWidget,
        );
        verify(routeCubit.getTargetRoute(checkDifferentDevice: false));
      });
    });

    testWidgets(
        "Should call getTargetRoute() again when press ok on alert something error",
        (tester) async {
      await tester.runAsync(() async {
        when(signInBloc.stream)
            .thenAnswer((_) => Stream.value(const SignInSuccessfully()));

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(const RouteError()));
        await tester.pumpApp(child: SignInScreen());

        await tester.tapAt(tester.getCenter(findSignInWithGoogleButton()));
        await tester.pump();

        expect(
          findErrorMessageSomethingError(),
          findsOneWidget,
        );
        verify(routeCubit.getTargetRoute(checkDifferentDevice: false));

        when(routeCubit.stream)
            .thenAnswer((_) => Stream.value(RouteTarget(AppPages.signUp)));
        await tester.tap(findOkText());
        await tester.pump();
        verify(routeCubit.getTargetRoute(checkDifferentDevice: false));
      });
    });
  });

  group("Sign In Button", () {
    testWidgets(
        "Should show the sign in with Apple and sign in with Google button if device is iOS",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        expect(findSignInWithAppleButton(), findsOneWidget);
        expect(findSignInWithGoogleButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should show the sign in with Google button only if device is not iOS",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(false);

        await tester.pumpApp(child: SignInScreen());

        expect(findSignInWithAppleButton(), findsNothing);
        expect(findSignInWithGoogleButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should call the SignInWithApple event when tap the [SignInWithAppleButton]",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(findSignInWithAppleButton());
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithApple()));
      });
    });

    testWidgets(
        "Should call the SignInWithGoogle event when tap the [SignInWithGoogleButton]",
        (tester) async {
      await tester.runAsync(() async {
        when(deviceInfo.isIOS()).thenReturn(true);

        await tester.pumpApp(child: SignInScreen());

        await tester.tap(findSignInWithGoogleButton());
        await tester.pumpAndSettle();

        verify(signInBloc.add(const SignInWithGoogle()));
      });
    });
  });

  group("Text", () {
    testWidgets("Should show the sign in text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(findSignInText(), findsOneWidget);
        expect(findSignInInfoText(), findsOneWidget);
      });
    });

    testWidgets("Should show the volunteer text info", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: SignInScreen());
        expect(findVolunteerSignInInfoText(), findsOneWidget);
      });
    });
  });
}
