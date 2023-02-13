/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockAccountCubit accountCubit;
  late MockSignUpBloc signUpBloc;
  late MockSignUpInputBloc signUpInputBloc;
  late MockSignOutCubit signOutCubit;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    accountCubit = getMockAccountCubit();
    signUpBloc = getMockSignUpBloc();
    signUpInputBloc = getMockSignUpInputBloc();
    signOutCubit = getMockSignOutCubit();

    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.light);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  group("Responsive Layout", () {
    test("Should implements [ResponsiveLayoutInterface]", () {
      SignUpScreen signUpScreen = SignUpScreen();

      expect(signUpScreen, isA<ResponsiveLayoutInterface>());
    });

    testWidgets("Should use [ResponsiveBuilder]", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        expect(find.byType(ResponsiveBuilder), findsOneWidget);
      });
    });

    testWidgets("Should show the mobile layout when device is mobile",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key("sign_up_mobile_layout")), findsOneWidget);
        expect(find.byKey(const Key("sign_up_tablet_layout")), findsNothing);
      });
    });

    testWidgets("Should show the tablet layout when device is tablet",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key("sign_up_mobile_layout")), findsNothing);
        expect(find.byKey(const Key("sign_up_tablet_layout")), findsOneWidget);
      });
    });
  });

  group("Text", () {
    testWidgets("Should show hello text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(find.text(LocaleKeys.hello.tr()), findsOneWidget);

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(find.text(LocaleKeys.hello.tr()), findsOneWidget);
      });
    });

    testWidgets("Should show lets get started text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(find.text(LocaleKeys.lets_get_started.tr()), findsOneWidget);

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(find.text(LocaleKeys.lets_get_started.tr()), findsOneWidget);
      });
    });

    testWidgets("Should show fill in form text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream)
            .thenAnswer((_) => Stream.value(const AccountEmpty()));

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(
          find.text(LocaleKeys.fill_in_form_to_continue.tr()),
          findsOneWidget,
        );

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(
          find.text(LocaleKeys.fill_in_form_to_continue.tr()),
          findsOneWidget,
        );
      });
    });
  });

  group("Account", () {
    testWidgets("Should show auth icon button when device is mobile",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: "contact@firgia.com",
              signInMethod: AuthMethod.google,
            ),
          ),
        );

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key("sign_up_auth_icon_button")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("sign_up_account_card")),
          findsNothing,
        );
      });
    });

    testWidgets("Should show account card when device is tablet",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: "contact@firgia.com",
              signInMethod: AuthMethod.google,
            ),
          ),
        );

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key("sign_up_auth_icon_button")),
          findsNothing,
        );

        expect(
          find.byKey(const Key("sign_up_account_card")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show sign out button with tap auth icon button",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: "contact@firgia.com",
              signInMethod: AuthMethod.google,
            ),
          ),
        );

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        await tester.tapAt(tester
            .getCenter(find.byKey(const Key("sign_up_auth_icon_button"))));
        await tester.pumpAndSettle();

        expect(find.byType(SignOutButton), findsOneWidget);
      });
    });

    testWidgets("Should show sign out button with tap account card",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: "contact@firgia.com",
              signInMethod: AuthMethod.google,
            ),
          ),
        );

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        await tester.tapAt(
            tester.getCenter(find.byKey(const Key("sign_up_account_card"))));
        await tester.pumpAndSettle();

        expect(find.byType(SignOutButton), findsOneWidget);
      });
    });

    testWidgets("Should show unknown text when email is null", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: null,
              signInMethod: AuthMethod.google,
            ),
          ),
        );

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        await tester.tapAt(
            tester.getCenter(find.byKey(const Key("sign_up_account_card"))));
        await tester.pumpAndSettle();

        expect(find.byType(AccountCard), findsNWidgets(2));

        for (Element element in find.byType(AccountCard).evaluate()) {
          AccountCard accountCard = element.widget as AccountCard;

          expect(accountCard.email, "unknown");
        }
      });
    });
  });

  group("Sign Out", () {
    Future showAndTapSignOutButton(WidgetTester tester) async {
      await tester.pumpApp(child: SignUpScreen());
      await tester.setScreenSize(iphone14);
      await tester.pumpAndSettle();
      await tester.tapAt(
          tester.getCenter(find.byKey(const Key("sign_up_auth_icon_button"))));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SignOutButton));
      await tester.pumpAndSettle();
    }

    setUp(() {
      when(accountCubit.stream).thenAnswer(
        (_) => Stream.value(
          const AccountData(
            email: "contact@firgia.com",
            signInMethod: AuthMethod.google,
          ),
        ),
      );
    });

    testWidgets("Should call signOut() when [SignOutButton] is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await showAndTapSignOutButton(tester);
        verify(signOutCubit.signOut());
      });
    });

    testWidgets("Should navigate to splash page when SignOutSuccessfully",
        (tester) async {
      await tester.runAsync(() async {
        when(signOutCubit.stream).thenAnswer(
          (_) => Stream.value(const SignOutSuccessfully()),
        );

        await showAndTapSignOutButton(tester);

        verify(signOutCubit.signOut());
        verify(appNavigator.goToSplash(any));
      });
    });

    testWidgets("Should navigate to splash page when SignOutError",
        (tester) async {
      await tester.runAsync(() async {
        when(signOutCubit.stream).thenAnswer(
          (_) => Stream.value(const SignOutError()),
        );

        await showAndTapSignOutButton(tester);

        verify(signOutCubit.signOut());
        verify(appNavigator.goToSplash(any));
      });
    });
  });
}
