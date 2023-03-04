/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAppNavigator appNavigator;
  late MockAccountCubit accountCubit;
  late MockFileBloc fileBloc;
  late MockLanguageBloc languageBloc;
  late MockSignUpBloc signUpBloc;
  late MockSignUpInputBloc signUpInputBloc;
  late MockSignOutCubit signOutCubit;
  late MockWidgetsBinding widgetBinding;

  File file = File("assets/images/raster/avatar.png");

  Finder findNameField() => find.byKey(const Key("sign_up_screen_name_field"));
  Finder findProfileImageButton() =>
      find.byKey(const Key("sign_up_screen_profile_image_button"));
  Finder findPickImageText() => find.text(LocaleKeys.choose_an_image.tr());
  Finder findCameraButton() =>
      find.byKey(const Key("bottom_sheet_pick_image_camera_icon_button"));
  Finder findGalleryButton() =>
      find.byKey(const Key("bottom_sheet_pick_image_gallery_icon_button"));
  Finder findDateOfBirthField() =>
      find.byKey(const Key("sign_up_screen_date_of_birth_field"));
  Finder findOKText() => find.text("OK");
  Finder findPersonalInformationPage() =>
      find.byKey(const Key("sign_up_screen_personal_information_page"));
  Finder findGenderMaleButton() =>
      find.byKey(const Key("sign_up_screen_gender_male_button"));
  Finder findGenderFemaleButton() =>
      find.byKey(const Key("sign_up_screen_gender_female_button"));
  Finder findErrorChooseImageText() =>
      find.text(LocaleKeys.error_failed_to_choose_image.tr());

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    accountCubit = getMockAccountCubit();
    fileBloc = getMockFileBloc();
    languageBloc = getMockLanguageBloc();
    signUpBloc = getMockSignUpBloc();
    signUpInputBloc = getMockSignUpInputBloc();
    signOutCubit = getMockSignOutCubit();
    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();
    when(window.platformBrightness).thenReturn(Brightness.light);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  group("Bloc Listener", () {
    testWidgets("Should show error choose image message when [FileError]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        when(fileBloc.stream).thenAnswer(
          (_) => Stream.value(const FileError()),
        );

        await tester.pumpApp(child: SignUpScreen());
        await tester.pumpAndSettle();

        expect(findErrorChooseImageText(), findsOneWidget);
      });
    });

    testWidgets(
        "Should call add [SignUpInputProfileImageChanged] when [FilePicked]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        when(fileBloc.stream).thenAnswer(
          (_) => Stream.value(FilePicked(file)),
        );

        await tester.pumpApp(child: SignUpScreen());
        verify(signUpInputBloc.add(SignUpInputProfileImageChanged(file)));
      });
    });

    testWidgets("Should navigate to home page when [SignUpSuccessfully]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        when(signUpBloc.stream).thenAnswer(
          (_) => Stream.value(const SignUpSuccessfully()),
        );

        await tester.pumpApp(child: SignUpScreen());
        verify(appNavigator.goToHome(any));
      });
    });

    testWidgets("Should navigate to splash page when [SignOutSuccessfully]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        when(signOutCubit.stream).thenAnswer(
          (_) => Stream.value(const SignOutSuccessfully()),
        );

        await tester.pumpApp(child: SignUpScreen());
        verify(appNavigator.goToSplash(any));
      });
    });

    testWidgets("Should navigate to splash page when [SignOutError]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        when(signOutCubit.stream).thenAnswer(
          (_) => Stream.value(const SignOutError()),
        );

        await tester.pumpApp(child: SignUpScreen());
        verify(appNavigator.goToSplash(any));
      });
    });
  });

  group("Responsive Layout", () {
    setUp(() {
      when(signUpInputBloc.state).thenReturn(
        const SignUpInputState(currentStep: SignUpStep.selectUserType),
      );
    });

    test("Should implements [ResponsiveLayoutInterface]", () {
      SignUpScreen signUpScreen = SignUpScreen();

      expect(signUpScreen, isA<ResponsiveLayoutInterface>());
    });

    testWidgets("Should use [ResponsiveBuilder]", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        expect(find.byType(ResponsiveBuilder), findsOneWidget);
      });
    });

    testWidgets("Should show the mobile layout when device is mobile",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key("sign_up_screen_mobile_layout")),
            findsOneWidget);
        expect(find.byKey(const Key("sign_up_screen_tablet_layout")),
            findsNothing);
      });
    });

    testWidgets("Should show the tablet layout when device is tablet",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key("sign_up_screen_mobile_layout")),
            findsNothing);
        expect(find.byKey(const Key("sign_up_screen_tablet_layout")),
            findsOneWidget);
      });
    });
  });

  group("Text", () {
    setUp(() {
      when(signUpInputBloc.state).thenReturn(
        const SignUpInputState(currentStep: SignUpStep.selectUserType),
      );
    });

    testWidgets("Should show hello text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

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
        when(accountCubit.state).thenReturn(const AccountEmpty());

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
        when(accountCubit.state).thenReturn(const AccountEmpty());

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
    setUp(() {
      when(signUpInputBloc.state).thenReturn(
        const SignUpInputState(currentStep: SignUpStep.selectUserType),
      );
    });

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
          find.byKey(const Key("sign_up_screen_auth_icon_button")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("sign_up_screen_account_card")),
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
          find.byKey(const Key("sign_up_screen_auth_icon_button")),
          findsNothing,
        );

        expect(
          find.byKey(const Key("sign_up_screen_account_card")),
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

        await tester.tapAt(tester.getCenter(
            find.byKey(const Key("sign_up_screen_auth_icon_button"))));
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

        await tester.tapAt(tester
            .getCenter(find.byKey(const Key("sign_up_screen_account_card"))));
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

        await tester.tapAt(tester
            .getCenter(find.byKey(const Key("sign_up_screen_account_card"))));
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
      await tester.tapAt(tester
          .getCenter(find.byKey(const Key("sign_up_screen_auth_icon_button"))));
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

      when(signUpInputBloc.state).thenReturn(
        const SignUpInputState(currentStep: SignUpStep.selectUserType),
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

  group("Page Transition", () {
    testWidgets(
        "Should show select user type page when [SignUpInputBloc.currentStep] is [SignUpStep.selectType]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectUserType),
        );

        await tester.pumpApp(child: SignUpScreen());

        expect(
          find.byKey(const Key("sign_up_screen_select_user_type_page")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("sign_up_screen_select_language_page")),
          findsNothing,
        );

        expect(
          findPersonalInformationPage(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show select language page when [SignUpInputBloc.currentStep] is [SignUpStep.selectLanguage]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(currentStep: SignUpStep.selectLanguage),
        );

        await tester.pumpApp(child: SignUpScreen());

        expect(
          find.byKey(const Key("sign_up_screen_select_user_type_page")),
          findsNothing,
        );

        expect(
          find.byKey(const Key("sign_up_screen_select_language_page")),
          findsOneWidget,
        );

        expect(
          findPersonalInformationPage(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show personal information page when [SignUpInputBloc.currentStep] is [SignUpStep.inputPersonalInformation]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation),
        );

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: SignUpScreen());

        expect(
          find.byKey(const Key("sign_up_screen_select_user_type_page")),
          findsNothing,
        );

        expect(
          find.byKey(const Key("sign_up_screen_select_language_page")),
          findsNothing,
        );

        expect(
          findPersonalInformationPage(),
          findsOneWidget,
        );
      });
    });
  });

  group("SelectUserTypePage()", () {
    group("Next Button", () {
      testWidgets("Should show next button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(find.byKey(const Key("sign_up_screen_next_button")),
              findsOneWidget);
        });
      });

      testWidgets(
          "Should enable next button when [SignUpInputState.type] is not null",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(type: UserType.volunteer),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton = find
              .byKey(const Key("sign_up_screen_next_button"))
              .getWidget() as ElevatedButton;

          expect(nextButton.onPressed, isNotNull);
        });
      });

      testWidgets(
          "Should disable next button when [SignUpInputState.type] is null",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(type: null),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton = find
              .byKey(const Key("sign_up_screen_next_button"))
              .getWidget() as ElevatedButton;

          expect(nextButton.onPressed, null);
        });
      });

      testWidgets(
          "Should call [SignUpInputNextStep()] when next button is pressed and enabled",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(type: UserType.volunteer),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(find.byKey(const Key("sign_up_screen_next_button")));
          await tester.pumpAndSettle();

          verify(signUpInputBloc.add(const SignUpInputNextStep()));
        });
      });
    });

    group("User type button", () {
      testWidgets("Should show blind user button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_blind_user_button")),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show volunteer user button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_volunteer_user_button")),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call the [SignUpInputTypeChanged(UserType.blind)] when pressed blind user button",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(
            find.byKey(const Key("sign_up_screen_blind_user_button")),
          );
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc.add(const SignUpInputTypeChanged(UserType.blind)),
          );
        });
      });

      testWidgets(
          "Should call the [SignUpInputTypeChanged(UserType.volunteer)] when pressed volunteer user button",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(
            find.byKey(const Key("sign_up_screen_volunteer_user_button")),
          );
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc
                .add(const SignUpInputTypeChanged(UserType.volunteer)),
          );
        });
      });
    });

    group("Text", () {
      testWidgets("Should show title text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(find.text(LocaleKeys.select_user_type.tr()), findsOneWidget);
        });
      });

      testWidgets("Should show info text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(find.text(LocaleKeys.sign_up_rule_desc.tr()), findsOneWidget);
        });
      });
    });
  });

  group("SelectLanguagePage()", () {
    group("Add Language Button", () {
      testWidgets("Should show add button when language is not reaching max",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_add_language_button")),
            findsOneWidget,
          );

          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should hide add button when language is reaching max",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.selectLanguage,
                languages: [
                  Language(),
                  Language(),
                  Language(),
                ]),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_add_language_button")),
            findsNothing,
          );

          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show selection language when tap add language button",
          (tester) async {
        await tester.runAsync(() async {
          when(languageBloc.state).thenReturn(const LanguageLoaded([
            Language(
              code: "id",
              name: "Indonesian",
            ),
            Language(
              code: "ru",
              name: "Russian",
            ),
          ]));

          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(
            find.byKey(const Key("sign_up_screen_add_language_button")),
          );

          await tester.pumpAndSettle();

          expect(find.byType(LanguageSelectionCard), findsOneWidget);
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
          expect(find.text("Indonesian"), findsOneWidget);
          expect(find.text("Russian"), findsOneWidget);
        });
      });
    });

    group("Back Button", () {
      testWidgets("Should show back button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_back_icon_button")),
            findsOneWidget,
          );
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputBackStep()] when back button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester
              .tap(find.byKey(const Key("sign_up_screen_back_icon_button")));
          await tester.pumpAndSettle();

          verify(signUpInputBloc.add(const SignUpInputBackStep()));
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });
    });

    group("Next Button", () {
      testWidgets("Should show next button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_next_button")),
            findsOneWidget,
          );
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should enable next button when [SignUpInputState.type] is not null and [SignUpInputState.languages] is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton = find
              .byKey(const Key("sign_up_screen_next_button"))
              .getWidget() as ElevatedButton;

          expect(nextButton.onPressed, isNotNull);
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should disable next button when [SignUpInputState.type] is null or [SignUpInputState.languages] is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: null,
              languages: null,
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton = find
              .byKey(const Key("sign_up_screen_next_button"))
              .getWidget() as ElevatedButton;

          expect(nextButton.onPressed, null);
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputNextStep()] when next button is pressed and enabled",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(find.byKey(const Key("sign_up_screen_next_button")));
          await tester.pumpAndSettle();

          verify(signUpInputBloc.add(const SignUpInputNextStep()));
          expect(
            find.byKey(const Key("sign_up_screen_select_language_page")),
            findsOneWidget,
          );
        });
      });
    });

    group("Selection Language", () {
      setUp(() {
        when(languageBloc.state).thenReturn(const LanguageLoaded([
          Language(
            code: "id",
            name: "Indonesian",
          ),
          Language(
            code: "ru",
            name: "Russian",
          ),
        ]));

        when(signUpInputBloc.state).thenReturn(
          const SignUpInputState(
              currentStep: SignUpStep.selectLanguage,
              languages: [
                Language(
                  code: "ru",
                  name: "Russian",
                ),
                Language(
                  code: "en",
                  name: "English",
                ),
              ]),
        );
      });

      testWidgets(
          "Should show LanguageCard based on [SignUpInputState.languages]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          expect(find.byType(LanguageCard), findsNWidgets(2));
          expect(find.byKey(const Key("language_card_ru")), findsOneWidget);
          expect(find.byKey(const Key("language_card_en")), findsOneWidget);
        });
      });

      testWidgets(
          "Should call the [SignUpInputLanguageAdded] when tap selection language",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          // Tap to show selection language
          await tester.tap(
            find.byKey(const Key("sign_up_screen_add_language_button")),
          );
          await tester.pumpAndSettle();

          // Tap to select the language
          await tester.tap(find.text("Indonesian"));
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc.add(
              const SignUpInputLanguageAdded(
                Language(
                  code: "id",
                  name: "Indonesian",
                ),
              ),
            ),
          );
        });
      });

      testWidgets(
          "Should call the [SignUpInputLanguageRemoved] when tap remove button on Language Card",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(
            find.byKey(const Key("language_card_remove_button_ru")),
          );
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc.add(
              const SignUpInputLanguageRemoved(
                Language(
                  code: "ru",
                  name: "Russian",
                ),
              ),
            ),
          );
        });
      });
    });

    group("Text", () {
      testWidgets("Should show title text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(find.text(LocaleKeys.select_language.tr()), findsOneWidget);
        });
      });

      testWidgets("Should show add language text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(find.text(LocaleKeys.add_language_desc.tr()), findsOneWidget);
        });
      });

      testWidgets("Should show blind info text when blind is selected",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.selectLanguage,
              type: UserType.blind,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(
            find.text(LocaleKeys.select_language_blind_desc.tr()),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show volunteer info text when volunteer is selected",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.selectLanguage,
              type: UserType.volunteer,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(
            find.text(LocaleKeys.select_language_volunteer_desc.tr()),
            findsOneWidget,
          );
        });
      });
    });
  });

  group("PersonalInformationPage()", () {
    group("Back Button", () {
      testWidgets("Should show back button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_back_icon_button")),
            findsOneWidget,
          );
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputBackStep()] when back button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester
              .tap(find.byKey(const Key("sign_up_screen_back_icon_button")));
          await tester.pumpAndSettle();

          verify(signUpInputBloc.add(const SignUpInputBackStep()));
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Date Of Birth Field", () {
      testWidgets("Should show date of birth field", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findDateOfBirthField(),
            findsOneWidget,
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputDateOfBirthChanged()] when date of birth field is changed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          // Showing Date Dialog
          await tester.tap(findDateOfBirthField());
          await tester.pumpAndSettle();

          // Confirm selected date
          await tester.tap(findOKText());
          await tester.pumpAndSettle();

          /// The default date selected is 17 years old
          DateTime currentDate =
              DateTime.now().add(-const Duration(days: 365 * 17));

          verify(
            signUpInputBloc.add(
              SignUpInputDateOfBirthChanged(
                DateTime(
                  currentDate.year,
                  currentDate.month,
                  currentDate.day,
                ),
              ),
            ),
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Gender", () {
      testWidgets("Should show Gender male and female button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findGenderMaleButton(),
            findsOneWidget,
          );

          expect(
            findGenderFemaleButton(),
            findsOneWidget,
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputGenderChanged()] when Gender male or female button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findGenderMaleButton());
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc.add(const SignUpInputGenderChanged(Gender.male)),
          );

          await tester.tap(findGenderFemaleButton());
          await tester.pumpAndSettle();

          verify(
            signUpInputBloc.add(const SignUpInputGenderChanged(Gender.female)),
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Name Field", () {
      testWidgets("Should show name field", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findNameField(),
            findsOneWidget,
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpInputNameChanged()] when name field is changed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          Future enterText(String text) async {
            await tester.enterText(findNameField(), text);
            await Future.delayed(const Duration(milliseconds: 800));
            await tester.pump();
            await tester.pumpAndSettle();
          }

          await enterText("Mochamad");
          verify(signUpInputBloc.add(const SignUpInputNameChanged("Mochamad")));

          await enterText("Mochamad Firgia");
          verify(signUpInputBloc
              .add(const SignUpInputNameChanged("Mochamad Firgia")));

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Profile Image Button", () {
      testWidgets("Should show profile image button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findProfileImageButton(),
            findsOneWidget,
          );

          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should call [FileProfileImagePicked()] when pick image",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          // Test pick image from Camera
          await tester.tap(findProfileImageButton());
          await tester.pumpAndSettle();

          expect(findPickImageText(), findsOneWidget);
          expect(findCameraButton(), findsOneWidget);
          expect(findGalleryButton(), findsOneWidget);

          await tester.tap(findCameraButton());
          await tester.pumpAndSettle();

          verify(
              fileBloc.add(const FileProfileImagePicked(ImageSource.camera)));

          // Test pick image from Gallery
          await tester.tap(findProfileImageButton());
          await tester.pumpAndSettle();

          await tester.tap(findGalleryButton());
          await tester.pumpAndSettle();

          verify(
              fileBloc.add(const FileProfileImagePicked(ImageSource.gallery)));
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should show profile file image from [SignUpInputBloc.profileImage]",
          (tester) async {
        await tester.runAsync(() async {
          File file = File("assets/images/raster/avatar.png");

          when(signUpInputBloc.state).thenReturn(
            SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
              profileImage: file,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          ProfileImageButton profileImageButton =
              find.byType(ProfileImageButton).getWidget() as ProfileImageButton;

          expect(profileImageButton.fileImage, file);
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Save Button", () {
      testWidgets("Should show save button", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.byKey(const Key("sign_up_screen_save_button")),
            findsOneWidget,
          );
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should enable save button when all [SignUpInputState] fields is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            SignUpInputState(
              type: UserType.volunteer,
              languages: const [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.inputPersonalInformation,
              name: "Firgia",
              profileImage: File("assets/images/raster/avatar.png"),
              dateOfBirth: DateTime(2000),
              gender: Gender.male,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          AsyncButton saveButton = find
              .byKey(const Key("sign_up_screen_save_button"))
              .getWidget() as AsyncButton;

          expect(saveButton.onPressed, isNotNull);
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should disable save button when some [SignUpInputState] fields is empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              type: null,
              languages: null,
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          AsyncButton saveButton = find
              .byKey(const Key("sign_up_screen_save_button"))
              .getWidget() as AsyncButton;

          expect(saveButton.onPressed, isNull);
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpSubmitted()] when save button is tapped and enabled",
          (tester) async {
        await tester.runAsync(() async {
          SignUpInputState signUpInputState = SignUpInputState(
            type: UserType.volunteer,
            languages: const [Language(code: "id", name: "Indonesia")],
            currentStep: SignUpStep.inputPersonalInformation,
            name: "Firgia",
            profileImage: File("assets/images/raster/avatar.png"),
            dateOfBirth: DateTime(2000),
            gender: Gender.male,
            deviceLanguage: DeviceLanguage.indonesian,
          );

          when(signUpInputBloc.state).thenReturn(signUpInputState);

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(find.byKey(const Key("sign_up_screen_save_button")));
          await tester.pumpAndSettle();

          verify(signUpBloc
              .add(SignUpSubmitted.fromSignUpInputState(signUpInputState)));
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Text", () {
      testWidgets("Should show title text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            find.text(LocaleKeys.personal_information.tr()),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show info text", (tester) async {
        await tester.runAsync(() async {
          when(signUpInputBloc.state).thenReturn(
            const SignUpInputState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());
          expect(find.text(LocaleKeys.sign_up_rule_desc.tr()), findsOneWidget);
        });
      });
    });
  });
}
