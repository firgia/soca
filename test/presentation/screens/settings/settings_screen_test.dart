/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockAccountCubit accountCubit;
  late MockAppNavigator appNavigator;
  late MockSettingsCubit settingsCubit;
  late MockSignOutCubit signOutCubit;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    accountCubit = getMockAccountCubit();
    appNavigator = getMockAppNavigator();
    settingsCubit = getMockSettingsCubit();
    signOutCubit = getMockSignOutCubit();
    widgetBinding = getMockWidgetsBinding();

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findAccountCard() =>
      find.byKey(const Key("settings_screen_account_card"));

  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findHaptics() => find.byKey(const Key("settings_screen_haptics"));
  Finder findHapticsSwitch() =>
      find.byKey(const Key("settings_screen_haptics_switch"));
  Finder findLanguageButton() =>
      find.byKey(const Key("settings_screen_language_button"));
  Finder findSignOutButton() =>
      find.byKey(const Key("settings_screen_sign_out_button"));
  Finder findVoiceAssistant() =>
      find.byKey(const Key("settings_screen_voice_assistant"));
  Finder findVoiceAssistantSwitch() =>
      find.byKey(const Key("settings_screen_voice_assistant_switch"));

  group("Initial", () {
    testWidgets("Should call accountCubit.getAccountData()", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SettingsScreen());

        verify(accountCubit.getAccountData());
      });
    });
  });

  group("Bloc Listener", () {
    testWidgets('Should navigate to splash page when [SignOutSuccessfully]',
        (tester) async {
      await tester.runAsync(() async {
        when(signOutCubit.stream)
            .thenAnswer((_) => Stream.value(const SignOutSuccessfully()));

        await tester.pumpApp(child: const SettingsScreen());

        verify(
          appNavigator.goToSplash(
            any,
          ),
        );
      });
    });

    testWidgets('Should navigate to splash page when [SignOutError]',
        (tester) async {
      await tester.runAsync(() async {
        when(signOutCubit.stream)
            .thenAnswer((_) => Stream.value(const SignOutError()));

        await tester.pumpApp(child: const SettingsScreen());

        verify(
          appNavigator.goToSplash(
            any,
          ),
        );
      });
    });

    testWidgets(
        'Should show [AdaptiveLoading] when to splash page when [SignOutLoading]',
        (tester) async {
      await tester.runAsync(() async {
        when(signOutCubit.stream)
            .thenAnswer((_) => Stream.value(const SignOutLoading()));

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        expect(findAdaptiveLoading(), findsOneWidget);
      });
    });
  });

  group("Account Card", () {
    testWidgets(
        "Should show account card when account type and email is available",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: "a",
              signInMethod: AuthMethod.apple,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        expect(findAccountCard(), findsOneWidget);
      });
    });

    testWidgets(
        "Should hide account card when account type or email is unavailable",
        (tester) async {
      await tester.runAsync(() async {
        when(accountCubit.stream).thenAnswer(
          (_) => Stream.value(
            const AccountData(
              email: null,
              signInMethod: null,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        expect(findAccountCard(), findsNothing);
      });
    });
  });

  group("Language Button", () {
    testWidgets("Should show language button", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SettingsScreen());

        expect(findLanguageButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should navigate to language page when language button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const SettingsScreen());

        await tester.ensureVisible(findLanguageButton());
        await tester.tap(findLanguageButton());
        await tester.pumpAndSettle();

        expect(findLanguageButton(), findsOneWidget);
        verify(appNavigator.goToLanguage(any));
      });
    });
  });

  group("Haptics", () {
    testWidgets("Should show haptics settings", (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer(
          (_) => Stream.value(
            const SettingsValue(
              isHapticsEnable: false,
              isVoiceAssistantEnable: false,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        expect(findHaptics(), findsOneWidget);
      });
    });

    testWidgets(
        "Should call settingsCubit.setEnableHaptics() when switch is tapped",
        (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer(
          (_) => Stream.value(
            const SettingsValue(
              isHapticsEnable: false,
              isVoiceAssistantEnable: false,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        await tester.ensureVisible(findHapticsSwitch());
        await tester.tap(findHapticsSwitch());
        await tester.pumpAndSettle();

        expect(findHapticsSwitch(), findsOneWidget);
        verify(settingsCubit.setEnableHaptics(true));
      });
    });

    testWidgets("Should set switch value based on [SettingsValue]",
        (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer((_) => Stream.value(
              const SettingsValue(
                isHapticsEnable: true,
                isVoiceAssistantEnable: true,
              ),
            ));

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        await tester.ensureVisible(findHapticsSwitch());
        CupertinoSwitch cupertinoSwitch =
            findHapticsSwitch().getWidget() as CupertinoSwitch;

        expect(cupertinoSwitch.value, isTrue);
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets("Should show voice assistant settings", (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer(
          (_) => Stream.value(
            const SettingsValue(
              isHapticsEnable: false,
              isVoiceAssistantEnable: false,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        expect(findVoiceAssistant(), findsOneWidget);
      });
    });

    testWidgets(
        "Should call settingsCubit.setEnableVoiceAssistant() when switch is tapped",
        (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer(
          (_) => Stream.value(
            const SettingsValue(
              isHapticsEnable: false,
              isVoiceAssistantEnable: false,
            ),
          ),
        );

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        await tester.ensureVisible(findVoiceAssistantSwitch());
        await tester.tap(findVoiceAssistantSwitch());
        await tester.pumpAndSettle();

        expect(findVoiceAssistantSwitch(), findsOneWidget);
        verify(settingsCubit.setEnableVoiceAssistant(true));
      });
    });

    testWidgets("Should set switch value based on [SettingsValue]",
        (tester) async {
      await tester.runAsync(() async {
        when(settingsCubit.stream).thenAnswer((_) => Stream.value(
              const SettingsValue(
                isHapticsEnable: true,
                isVoiceAssistantEnable: true,
              ),
            ));

        await tester.pumpApp(child: const SettingsScreen());
        await tester.pump();

        await tester.ensureVisible(findVoiceAssistantSwitch());
        CupertinoSwitch cupertinoSwitch =
            findVoiceAssistantSwitch().getWidget() as CupertinoSwitch;

        expect(cupertinoSwitch.value, isTrue);
      });
    });
  });

  group("Sign Out Button", () {
    testWidgets("Should show sign out button", (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const SettingsScreen());

        expect(findSignOutButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should call [signOutCubit.signOut()] when sign out button is tapped",
        (tester) async {
      await tester.runAsync(() async {
        await tester.setScreenSize(iphone14);
        await tester.pumpApp(child: const SettingsScreen());

        await tester.ensureVisible(findSignOutButton());
        await tester.tap(findSignOutButton());
        await tester.pump();

        verify(signOutCubit.signOut());
      });
    });
  });
}
