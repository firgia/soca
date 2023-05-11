/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Jan 30 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/enum/enum.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() async {
  late MockAppNavigator appNavigator;

  setUp(() {
    registerLocator();

    appNavigator = getMockAppNavigator();
  });

  tearDown(() => unregisterLocator());

  Finder findCustomAppBar() => find.byType(CustomAppBar);
  Finder findIgnorePointerItems() =>
      find.byKey(const Key("language_screen_ignore_pointer_items"));
  Finder findLanguageItems() =>
      find.byKey(const Key("language_screen_language_items"));
  Finder findBackButton() =>
      find.byKey(const Key("language_screen_back_button"));
  Finder findNextButton() =>
      find.byKey(const Key("language_screen_next_button"));

  group("AppBar", () {
    testWidgets("Should show the [CustomAppBar]", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: const LanguageScreen());
        expect(findCustomAppBar(), findsOneWidget);
      });
    });

    testWidgets("Should show the language title", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: const LanguageScreen());
        CustomAppBar customAppBar =
            findCustomAppBar().getWidget() as CustomAppBar;

        expect(customAppBar.title, LocaleKeys.language.tr());
      });
    });
  });

  group("IgnorePointer", () {
    testWidgets(
        "Should ignore the pointer language items when [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageLoading());

        await tester.pumpApp(child: const LanguageScreen());

        IgnorePointer ignorePointer =
            findIgnorePointerItems().getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, true);
      });
    });

    testWidgets(
        "Shouldn't ignore the pointer language items when state is not [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());

        await tester.pumpApp(child: const LanguageScreen());

        IgnorePointer ignorePointer =
            findIgnorePointerItems().getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, false);
      });
    });
  });

  group("LanguageItems", () {
    testWidgets("Should show the Language items", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: const LanguageScreen());
        expect(findLanguageItems(), findsOneWidget);
      });
    });

    testWidgets("Should show the flag button based on [DeviceLanguage]",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: const LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(findCustomAppBar(), const Offset(0, -100));
        await tester.pump();

        for (DeviceLanguage deviceLanguage in DeviceLanguage.values) {
          expect(
              find.byKey(
                  Key("language_screen_flag_button_${deviceLanguage.name}")),
              findsOneWidget);
        }
      });
    });

    testWidgets(
        "Should set the selected [FlagButton] to true when [DeviceLanguage] is selected",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        DeviceLanguage selectedLanguage = DeviceLanguage.indonesian;

        when(languageBloc.state).thenReturn(LanguageSelected(selectedLanguage));
        await tester.pumpApp(child: const LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(findCustomAppBar(), const Offset(0, -100));
        await tester.pump();

        for (DeviceLanguage deviceLanguage in DeviceLanguage.values) {
          final button = find
              .byKey(Key("language_screen_flag_button_${deviceLanguage.name}"))
              .getWidget() as FlagButton;

          if (button.language == selectedLanguage) {
            expect(button.selected, true);
          }
        }
      });
    });

    testWidgets(
        "Should set the selected [FlagButton] to false when [DeviceLanguage] is not selected",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        DeviceLanguage selectedLanguage = DeviceLanguage.indonesian;

        when(languageBloc.state).thenReturn(LanguageSelected(selectedLanguage));
        await tester.pumpApp(child: const LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(findCustomAppBar(), const Offset(0, -100));
        await tester.pump();

        for (DeviceLanguage deviceLanguage in DeviceLanguage.values) {
          final button = find
              .byKey(Key("language_screen_flag_button_${deviceLanguage.name}"))
              .getWidget() as FlagButton;

          if (button.language != selectedLanguage) {
            expect(button.selected, false);
          }
        }
      });
    });
  });

  group("BackButton", () {
    testWidgets("Should show the back button when navigation can pop",
        (tester) async {
      await tester.runAsync(() async {
        when(appNavigator.canPop(any)).thenReturn(true);
        await tester.pumpApp(child: const LanguageScreen());

        expect(findBackButton(), findsOneWidget);
        expect(findNextButton(), findsNothing);
      });
    });

    testWidgets(
        "Should set the isLoading of [AsyncButton] to true when state is [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        when(appNavigator.canPop(any)).thenReturn(true);

        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageLoading());
        await tester.pumpApp(child: const LanguageScreen());

        AsyncButton backButton = findBackButton().getWidget() as AsyncButton;
        expect(backButton.isLoading, true);
      });
    });

    testWidgets(
        "Should set the isLoading of [AsyncButton] to false when state is not [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        when(appNavigator.canPop(any)).thenReturn(true);

        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: const LanguageScreen());

        AsyncButton backButton = findBackButton().getWidget() as AsyncButton;
        expect(backButton.isLoading, false);
      });
    });
  });

  group("NextButton", () {
    testWidgets("Should show the next button when navigator doesn't pop",
        (tester) async {
      await tester.runAsync(() async {
        when(appNavigator.canPop(any)).thenReturn(false);
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: const LanguageScreen());

        expect(findBackButton(), findsNothing);
        expect(findNextButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should set the isLoading of [AsyncButton] to true when state is [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageLoading());
        await tester.pumpApp(child: const LanguageScreen());

        AsyncButton nextButton = findNextButton().getWidget() as AsyncButton;
        expect(nextButton.isLoading, true);
      });
    });

    testWidgets(
        "Should set the isLoading of [AsyncButton] to false when state is not [LanguageLoading()]",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: const LanguageScreen());

        AsyncButton nextButton = findNextButton().getWidget() as AsyncButton;
        expect(nextButton.isLoading, false);
      });
    });
  });
}
