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
  late MockSignUpFormBloc signUpFormBloc;
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

  Finder findResponsiveBuilder() => find.byType(ResponsiveBuilder);
  Finder findMobileLayout() =>
      find.byKey(const Key("sign_up_screen_mobile_layout"));
  Finder findTabletLayout() =>
      find.byKey(const Key("sign_up_screen_tablet_layout"));
  Finder findHelloText() => find.text(LocaleKeys.hello.tr());
  Finder findLetsGetStartedText() =>
      find.text(LocaleKeys.lets_get_started.tr());
  Finder findFillInFormToContinueText() =>
      find.text(LocaleKeys.fill_in_form_to_continue.tr());
  Finder findAuthIconButton() =>
      find.byKey(const Key("sign_up_screen_auth_icon_button"));
  Finder findAccountCard() =>
      find.byKey(const Key("sign_up_screen_account_card"));
  Finder findSignOutButton() => find.byType(SignOutButton);

  Finder findSelectUserTypePage() =>
      find.byKey(const Key("sign_up_screen_select_user_type_page"));
  Finder findSelectLanguagePage() =>
      find.byKey(const Key("sign_up_screen_select_language_page"));

  Finder findNextButton() =>
      find.byKey(const Key("sign_up_screen_next_button"));

  Finder findBlindUserButton() =>
      find.byKey(const Key("sign_up_screen_blind_user_button"));
  Finder findVolunteerUserButton() =>
      find.byKey(const Key("sign_up_screen_volunteer_user_button"));

  Finder findSelectUserTypeText() =>
      find.text(LocaleKeys.select_user_type.tr());
  Finder findSelectUserTypeDescText() =>
      find.text(LocaleKeys.sign_up_rule_desc.tr());

  Finder findAddLanguageButton() =>
      find.byKey(const Key("sign_up_screen_add_language_button"));

  Finder findLanguageSelectionCard() => find.byType(LanguageSelectionCard);

  Finder findBackIconButton() =>
      find.byKey(const Key("sign_up_screen_back_icon_button"));

  Finder findLanguageCard() => find.byType(LanguageCard);

  Finder findSelectLanguageText() => find.text(LocaleKeys.select_language.tr());
  Finder findAddLanguageDescText() =>
      find.text(LocaleKeys.add_language_desc.tr());
  Finder findSelectLanguageVolunteerDescText() =>
      find.text(LocaleKeys.select_language_volunteer_desc.tr());
  Finder findSelectLanguageBlindDescText() =>
      find.text(LocaleKeys.select_language_blind_desc.tr());

  Finder findSaveButton() =>
      find.byKey(const Key("sign_up_screen_save_button"));

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
    accountCubit = getMockAccountCubit();
    fileBloc = getMockFileBloc();
    languageBloc = getMockLanguageBloc();
    signUpBloc = getMockSignUpBloc();
    signUpFormBloc = getMockSignUpFormBloc();
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
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
        "Should call add [SignUpFormProfileImageChanged] when [FilePicked]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
        );

        when(fileBloc.stream).thenAnswer(
          (_) => Stream.value(FilePicked(file)),
        );

        await tester.pumpApp(child: SignUpScreen());
        verify(signUpFormBloc.add(SignUpFormProfileImageChanged(file)));
      });
    });

    testWidgets("Should navigate to home page when [SignUpSuccessfully]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
      when(signUpFormBloc.state).thenReturn(
        const SignUpFormState(currentStep: SignUpStep.selectUserType),
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

        expect(findResponsiveBuilder(), findsOneWidget);
      });
    });

    testWidgets("Should show the mobile layout when device is mobile",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(findMobileLayout(), findsOneWidget);
        expect(findTabletLayout(), findsNothing);
      });
    });

    testWidgets("Should show the tablet layout when device is tablet",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(findMobileLayout(), findsNothing);
        expect(findTabletLayout(), findsOneWidget);
      });
    });
  });

  group("Text", () {
    setUp(() {
      when(signUpFormBloc.state).thenReturn(
        const SignUpFormState(currentStep: SignUpStep.selectUserType),
      );
    });

    testWidgets("Should show hello text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(findHelloText(), findsOneWidget);

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(findHelloText(), findsOneWidget);
      });
    });

    testWidgets("Should show lets get started text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(findLetsGetStartedText(), findsOneWidget);

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(findLetsGetStartedText(), findsOneWidget);
      });
    });

    testWidgets("Should show fill in form text", (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.state).thenReturn(const AccountEmpty());

        await tester.pumpApp(child: SignUpScreen());

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(
          findFillInFormToContinueText(),
          findsOneWidget,
        );

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(
          findFillInFormToContinueText(),
          findsOneWidget,
        );
      });
    });
  });

  group("Account", () {
    setUp(() {
      when(signUpFormBloc.state).thenReturn(
        const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
          findAuthIconButton(),
          findsOneWidget,
        );

        expect(
          findAccountCard(),
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
          findAuthIconButton(),
          findsNothing,
        );

        expect(
          findAccountCard(),
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

        await tester.tapAt(tester.getCenter(findAuthIconButton()));
        await tester.pumpAndSettle();

        expect(findSignOutButton(), findsOneWidget);
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

        await tester.tapAt(tester.getCenter(findAccountCard()));
        await tester.pumpAndSettle();

        expect(findSignOutButton(), findsOneWidget);
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

        await tester.tapAt(tester.getCenter(findAccountCard()));
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
      await tester.tapAt(tester.getCenter(findAuthIconButton()));
      await tester.pumpAndSettle();

      await tester.tap(findSignOutButton());
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

      when(signUpFormBloc.state).thenReturn(
        const SignUpFormState(currentStep: SignUpStep.selectUserType),
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
        "Should show select user type page when [SignUpFormBloc.currentStep] is [SignUpStep.selectType]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectUserType),
        );

        await tester.pumpApp(child: SignUpScreen());

        expect(
          findSelectUserTypePage(),
          findsOneWidget,
        );

        expect(
          findSelectLanguagePage(),
          findsNothing,
        );

        expect(
          findPersonalInformationPage(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show select language page when [SignUpFormBloc.currentStep] is [SignUpStep.selectLanguage]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(currentStep: SignUpStep.selectLanguage),
        );

        await tester.pumpApp(child: SignUpScreen());

        expect(
          findSelectUserTypePage(),
          findsNothing,
        );

        expect(
          findSelectLanguagePage(),
          findsOneWidget,
        );

        expect(
          findPersonalInformationPage(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show personal information page when [SignUpFormBloc.currentStep] is [SignUpStep.inputPersonalInformation]",
        (tester) async {
      await tester.runAsync(() async {
        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(
              currentStep: SignUpStep.inputPersonalInformation),
        );

        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: SignUpScreen());

        expect(
          findSelectUserTypePage(),
          findsNothing,
        );

        expect(
          findSelectLanguagePage(),
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(findNextButton(), findsOneWidget);
        });
      });

      testWidgets(
          "Should enable next button when [SignUpFormState.type] is not null",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(type: UserType.volunteer),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton =
              findNextButton().getWidget() as ElevatedButton;

          expect(nextButton.onPressed, isNotNull);
        });
      });

      testWidgets(
          "Should disable next button when [SignUpFormState.type] is null",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(type: null),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton =
              findNextButton().getWidget() as ElevatedButton;

          expect(nextButton.onPressed, null);
        });
      });

      testWidgets(
          "Should call [SignUpFormNextStep()] when next button is pressed and enabled",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(type: UserType.volunteer),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findNextButton());
          await tester.pumpAndSettle();

          verify(signUpFormBloc.add(const SignUpFormNextStep()));
        });
      });
    });

    group("User type button", () {
      testWidgets("Should show blind user button", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findBlindUserButton(),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show volunteer user button", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findVolunteerUserButton(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call the [SignUpFormTypeChanged(UserType.blind)] when pressed blind user button",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(findBlindUserButton());
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(const SignUpFormTypeChanged(UserType.blind)),
          );
        });
      });

      testWidgets(
          "Should call the [SignUpFormTypeChanged(UserType.volunteer)] when pressed volunteer user button",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(findVolunteerUserButton());
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(const SignUpFormTypeChanged(UserType.volunteer)),
          );
        });
      });
    });

    group("Text", () {
      testWidgets("Should show title text", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(findSelectUserTypeText(), findsOneWidget);
        });
      });

      testWidgets("Should show info text", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(findSelectUserTypeDescText(), findsOneWidget);
        });
      });
    });
  });

  group("SelectLanguagePage()", () {
    group("Add Language Button", () {
      testWidgets("Should show add button when language is not reaching max",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findAddLanguageButton(),
            findsOneWidget,
          );

          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should hide add button when language is reaching max",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
                currentStep: SignUpStep.selectLanguage,
                languages: [
                  Language(),
                  Language(),
                  Language(),
                ]),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findAddLanguageButton(),
            findsNothing,
          );

          expect(
            findSelectLanguagePage(),
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

          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          await tester.tap(findAddLanguageButton());

          await tester.pumpAndSettle();

          expect(findLanguageSelectionCard(), findsOneWidget);
          expect(
            findSelectLanguagePage(),
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findBackIconButton(),
            findsOneWidget,
          );
          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpFormBackStep()] when back button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findBackIconButton());
          await tester.pumpAndSettle();

          verify(signUpFormBloc.add(const SignUpFormBackStep()));
          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });
    });

    group("Next Button", () {
      testWidgets("Should show next button", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());

          expect(
            findNextButton(),
            findsOneWidget,
          );
          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should enable next button when [SignUpFormState.type] is not null and [SignUpFormState.languages] is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton =
              findNextButton().getWidget() as ElevatedButton;

          expect(nextButton.onPressed, isNotNull);
          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should disable next button when [SignUpFormState.type] is null or [SignUpFormState.languages] is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: null,
              languages: null,
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          ElevatedButton nextButton =
              findNextButton().getWidget() as ElevatedButton;

          expect(nextButton.onPressed, null);
          expect(
            findSelectLanguagePage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpFormNextStep()] when next button is pressed and enabled",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.selectLanguage,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findNextButton());
          await tester.pumpAndSettle();

          verify(signUpFormBloc.add(const SignUpFormNextStep()));
          expect(
            findSelectLanguagePage(),
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

        when(signUpFormBloc.state).thenReturn(
          const SignUpFormState(
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
          "Should show LanguageCard based on [SignUpFormState.languages]",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          expect(findLanguageCard(), findsNWidgets(2));
          expect(find.byKey(const Key("language_card_ru")), findsOneWidget);
          expect(find.byKey(const Key("language_card_en")), findsOneWidget);
        });
      });

      testWidgets(
          "Should call the [SignUpFormLanguageAdded] when tap selection language",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          // Tap to show selection language
          await tester.tap(findAddLanguageButton());
          await tester.pumpAndSettle();

          // Tap to select the language
          await tester.tap(find.text("Indonesian"));
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(
              const SignUpFormLanguageAdded(
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
          "Should call the [SignUpFormLanguageRemoved] when tap remove button on Language Card",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(
            find.byKey(const Key("language_card_remove_button_ru")),
          );
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(
              const SignUpFormLanguageRemoved(
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(findSelectLanguageText(), findsOneWidget);
        });
      });

      testWidgets("Should show add language text", (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(currentStep: SignUpStep.selectLanguage),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(findAddLanguageDescText(), findsOneWidget);
        });
      });

      testWidgets("Should show blind info text when blind is selected",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.selectLanguage,
              type: UserType.blind,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(
            findSelectLanguageBlindDescText(),
            findsOneWidget,
          );
        });
      });

      testWidgets("Should show volunteer info text when volunteer is selected",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.selectLanguage,
              type: UserType.volunteer,
            ),
          );

          await tester.pumpApp(child: SignUpScreen());
          expect(
            findSelectLanguageVolunteerDescText(),
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
                currentStep: SignUpStep.inputPersonalInformation),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findBackIconButton(),
            findsOneWidget,
          );
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should call [SignUpFormBackStep()] when back button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: UserType.volunteer,
              languages: [Language(code: "id", name: "Indonesia")],
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findBackIconButton());
          await tester.pumpAndSettle();

          verify(signUpFormBloc.add(const SignUpFormBackStep()));
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          "Should call [SignUpFormDateOfBirthChanged()] when date of birth field is changed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
            signUpFormBloc.add(
              SignUpFormDateOfBirthChanged(
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          "Should call [SignUpFormGenderChanged()] when Gender male or female button is pressed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findGenderMaleButton());
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(const SignUpFormGenderChanged(Gender.male)),
          );

          await tester.tap(findGenderFemaleButton());
          await tester.pumpAndSettle();

          verify(
            signUpFormBloc.add(const SignUpFormGenderChanged(Gender.female)),
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          "Should call [SignUpFormNameChanged()] when name field is changed",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          verify(signUpFormBloc.add(const SignUpFormNameChanged("Mochamad")));

          await enterText("Mochamad Firgia");
          verify(signUpFormBloc
              .add(const SignUpFormNameChanged("Mochamad Firgia")));

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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          "Should show profile file image from [SignUpFormBloc.profileImage]",
          (tester) async {
        await tester.runAsync(() async {
          File file = File("assets/images/raster/avatar.png");

          when(signUpFormBloc.state).thenReturn(
            SignUpFormState(
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          expect(
            findSaveButton(),
            findsOneWidget,
          );
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should enable save button when all [SignUpFormState] fields is not empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            SignUpFormState(
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

          AsyncButton saveButton = findSaveButton().getWidget() as AsyncButton;

          expect(saveButton.onPressed, isNotNull);
          expect(
            findPersonalInformationPage(),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          "Should disable save button when some [SignUpFormState] fields is empty",
          (tester) async {
        await tester.runAsync(() async {
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              type: null,
              languages: null,
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          AsyncButton saveButton = findSaveButton().getWidget() as AsyncButton;

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
          SignUpFormState signUpFormState = SignUpFormState(
            type: UserType.volunteer,
            languages: const [Language(code: "id", name: "Indonesia")],
            currentStep: SignUpStep.inputPersonalInformation,
            name: "Firgia",
            profileImage: File("assets/images/raster/avatar.png"),
            dateOfBirth: DateTime(2000),
            gender: Gender.male,
            deviceLanguage: DeviceLanguage.indonesian,
          );

          when(signUpFormBloc.state).thenReturn(signUpFormState);

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());

          await tester.tap(findSaveButton());
          await tester.pumpAndSettle();

          verify(signUpBloc
              .add(SignUpSubmitted.fromSignUpFormState(signUpFormState)));
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
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
          when(signUpFormBloc.state).thenReturn(
            const SignUpFormState(
              currentStep: SignUpStep.inputPersonalInformation,
            ),
          );

          await tester.setScreenSize(iphone14);
          await tester.pumpApp(child: SignUpScreen());
          expect(findSelectUserTypeDescText(), findsOneWidget);
        });
      });
    });
  });
}
