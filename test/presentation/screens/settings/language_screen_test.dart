/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Jan 30 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/enum/enum.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper.dart';
import '../../../mock/mock.mocks.dart';

void main() async {
  late MockLanguageBloc languageBloc;

  setUp(() {
    languageBloc = MockLanguageBloc();
  });

  group("AppBar", () {
    testWidgets("Should show the CustomAppBar", (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(
          const LanguageSelected(DeviceLanguage.indonesian),
        );

        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));
        expect(find.byType(CustomAppBar), findsOneWidget);
      });
    });
  });

  group("IgnorePointer", () {
    testWidgets("Should ignore the pointer language items when LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageLoading());

        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));

        final ignorePointer = find
            .byKey(const Key("ignore_pointer_items"))
            .getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, true);
      });
    });

    testWidgets(
        "Shouldn't ignore the pointer language items when state is not LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageUnselected());

        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));

        final ignorePointer = find
            .byKey(const Key("ignore_pointer_items"))
            .getWidget() as IgnorePointer;

        expect(ignorePointer.ignoring, false);
      });
    });
  });

  group("LanguageItems", () {
    testWidgets("Should show the Language items", (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));
        expect(find.byKey(const Key("language_items")), findsOneWidget);
      });
    });

    // TODO: Implement this test
    // testWidgets("Should show the flag button based on DeviceLanguage",
    //     (tester) async {});

    // testWidgets(
    //     "Should set the selected FlagButton to true when DeviceLanguage is selected",
    //     (tester) async {});

    // testWidgets(
    //     "Should set the selected FlagButton to false when DeviceLanguage is not selected",
    //     (tester) async {});
  });

  group("NextButton", () {
    testWidgets("Should show the next button", (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));
        expect(find.byKey(const Key("next_button")), findsOneWidget);
      });
    });

    testWidgets(
        "Should set the isLoading of AsyncButton to true when state is LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageLoading());
        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));

        final nextButton =
            find.byKey(const Key("next_button")).getWidget() as AsyncButton;

        expect(nextButton.isLoading, true);
      });
    });

    testWidgets(
        "Should set the isLoading of AsyncButton to false when state is not LanguageLoading",
        (tester) async {
      await tester.runAsync(() async {
        when(languageBloc.state).thenReturn(const LanguageUnselected());
        await tester.pumpApp(child: LanguageScreen(languageBloc: languageBloc));

        final nextButton =
            find.byKey(const Key("next_button")).getWidget() as AsyncButton;

        expect(nextButton.isLoading, false);
      });
    });
  });
}
