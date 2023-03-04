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
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  group("AppBar", () {
    testWidgets("Should show the CustomAppBar", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: LanguageScreen());
        expect(find.byType(CustomAppBar), findsOneWidget);
      });
    });

    testWidgets("Should show the language title", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: LanguageScreen());
        final customAppBar =
            find.byType(CustomAppBar).getWidget() as CustomAppBar;

        expect(customAppBar.title, LocaleKeys.language.tr());
      });
    });
  });

  group("IgnorePointer", () {
    testWidgets("Should ignore the pointer language items when LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageLoading());

        await tester.pumpApp(child: LanguageScreen());

        final ignorePointer = find
            .byKey(const Key("language_screen_ignore_pointer_items"))
            .getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, true);
      });
    });

    testWidgets(
        "Shouldn't ignore the pointer language items when state is not LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());

        await tester.pumpApp(child: LanguageScreen());

        final ignorePointer = find
            .byKey(const Key("language_screen_ignore_pointer_items"))
            .getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, false);
      });
    });
  });

  group("LanguageItems", () {
    testWidgets("Should show the Language items", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen());
        expect(find.byKey(const Key("language_screen_language_items")),
            findsOneWidget);
      });
    });

    testWidgets("Should show the flag button based on DeviceLanguage",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(find.byType(CustomAppBar), const Offset(0, -100));
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
        "Should set the selected FlagButton to true when DeviceLanguage is selected",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        DeviceLanguage selectedLanguage = DeviceLanguage.indonesian;

        when(languageBloc.state).thenReturn(LanguageSelected(selectedLanguage));
        await tester.pumpApp(child: LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(find.byType(CustomAppBar), const Offset(0, -100));
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
        "Should set the selected FlagButton to false when DeviceLanguage is not selected",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        DeviceLanguage selectedLanguage = DeviceLanguage.indonesian;

        when(languageBloc.state).thenReturn(LanguageSelected(selectedLanguage));
        await tester.pumpApp(child: LanguageScreen());

        // We need to drag to make sure all button is shown
        await tester.drag(find.byType(CustomAppBar), const Offset(0, -100));
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

  group("NextButton", () {
    testWidgets("Should show the next button", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen());
        expect(find.byKey(const Key("language_screen_next_button")),
            findsOneWidget);
      });
    });

    testWidgets(
        "Should set the isLoading of AsyncButton to true when state is LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageLoading());
        await tester.pumpApp(child: LanguageScreen());

        final nextButton = find
            .byKey(const Key("language_screen_next_button"))
            .getWidget() as AsyncButton;

        expect(nextButton.isLoading, true);
      });
    });

    testWidgets(
        "Should set the isLoading of AsyncButton to false when state is not LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen());

        final nextButton = find
            .byKey(const Key("language_screen_next_button"))
            .getWidget() as AsyncButton;

        expect(nextButton.isLoading, false);
      });
    });

    testWidgets("Should show the next text", (tester) async {
      await tester.runAsync(() async {
        MockLanguageBloc languageBloc = getMockLanguageBloc();
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: LanguageScreen());

        expect(find.text(LocaleKeys.next.tr()), findsOneWidget);
      });
    });
  });
}
