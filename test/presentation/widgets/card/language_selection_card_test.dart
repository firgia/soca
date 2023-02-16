/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 16 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  group("LanguageSelectionCard.builder()", () {
    const List<Language> languages = [
      Language(
        code: "id",
        name: "Indonesian",
        nativeName: "Bahasa Indonesia",
      ),
      Language(
        code: "ru",
        name: "Russian",
        nativeName: "русский язык",
      ),
    ];

    group("Action", () {
      testWidgets(
          "Should call [onSelected] when tap the unselected language card",
          (tester) async {
        await tester.runAsync(() async {
          Language? selectedLanguage;

          await tester.pumpApp(
            child: Scaffold(
              body: LanguageSelectionCard.builder(
                selection: languages,
                selected: const [],
                onSelected: (selected) {
                  selectedLanguage = selected;
                },
              ),
            ),
          );

          Finder indonesianLanguageButton = find.text("Bahasa Indonesia");

          await tester.tap(indonesianLanguageButton);
          await tester.pumpAndSettle();

          expect(
            selectedLanguage,
            const Language(
              code: "id",
              name: "Indonesian",
              nativeName: "Bahasa Indonesia",
            ),
          );
        });
      });

      testWidgets(
          "Should not call [onSelected] when tap the selected language card",
          (tester) async {
        await tester.runAsync(() async {
          Language? selectedLanguage;

          await tester.pumpApp(
            child: Scaffold(
              body: LanguageSelectionCard.builder(
                selection: languages,
                selected: const [
                  Language(
                    code: "id",
                    name: "Indonesian",
                    nativeName: "Bahasa Indonesia",
                  )
                ],
                onSelected: (selected) {
                  selectedLanguage = selected;
                },
              ),
            ),
          );

          Finder indonesianLanguageButton = find.text("Bahasa Indonesia");

          await tester.tap(indonesianLanguageButton);
          await tester.pumpAndSettle();

          expect(selectedLanguage, null);
        });
      });
    });

    group("Icon", () {
      testWidgets("Should show check icon on selected language",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: Scaffold(
              body: LanguageSelectionCard.builder(
                selection: languages,
                selected: const [
                  Language(
                    code: "id",
                    name: "Indonesian",
                    nativeName: "Bahasa Indonesia",
                  )
                ],
                onSelected: (selected) {},
              ),
            ),
          );

          expect(
            find.byKey(const Key("language_selection_card_item_check_icon_id")),
            findsOneWidget,
          );

          expect(
            find.byKey(const Key("language_selection_card_item_check_icon_ru")),
            findsNothing,
          );
        });
      });

      testWidgets(
          "Should not call [onSelected] when tap the selected language card",
          (tester) async {
        await tester.runAsync(() async {
          Language? selectedLanguage;

          await tester.pumpApp(
            child: Scaffold(
              body: LanguageSelectionCard.builder(
                selection: languages,
                selected: const [
                  Language(
                    code: "id",
                    name: "Indonesian",
                    nativeName: "Bahasa Indonesia",
                  )
                ],
                onSelected: (selected) {
                  selectedLanguage = selected;
                },
              ),
            ),
          );

          Finder indonesianLanguageButton = find.text("Bahasa Indonesia");

          await tester.tap(indonesianLanguageButton);
          await tester.pumpAndSettle();

          expect(selectedLanguage, null);
        });
      });
    });

    group("Search Field", () {
      Widget buildLanguageSelectionCard = Scaffold(
        body: LanguageSelectionCard.builder(
          selection: languages,
          selected: const [],
          onSelected: (selected) {},
        ),
      );

      testWidgets("Should show search field", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: buildLanguageSelectionCard,
          );

          Finder searchField =
              find.byKey(const Key("language_selection_card_search_field"));
          expect(searchField, findsOneWidget);
          expect(searchField.getWidget(), isA<TextField>());
        });
      });

      testWidgets("Should filter showing card based on search field",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: buildLanguageSelectionCard,
          );

          Finder searchField =
              find.byKey(const Key("language_selection_card_search_field"));

          expect(find.text("Bahasa Indonesia"), findsOneWidget);
          expect(find.text("русский язык"), findsOneWidget);

          await tester.enterText(searchField, "Russian");
          await tester.pumpAndSettle();

          /// Wait for debounching
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          expect(find.text("Bahasa Indonesia"), findsNothing);
          expect(find.text("русский язык"), findsOneWidget);

          // Second Test
          await tester.enterText(searchField, "Hello world");
          await tester.pumpAndSettle();

          /// Wait for debounching
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();

          expect(find.text("Bahasa Indonesia"), findsNothing);
          expect(find.text("русский язык"), findsNothing);
        });
      });
    });

    group("Text", () {
      Widget buildLanguageSelectionCard = Scaffold(
        body: LanguageSelectionCard.builder(
          selection: languages,
          selected: const [],
          onSelected: (selected) {},
        ),
      );

      testWidgets("Should show [name] languages text", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: buildLanguageSelectionCard,
          );

          expect(find.text("Indonesian"), findsOneWidget);
          expect(find.text("Russian"), findsOneWidget);
        });
      });

      testWidgets("Should show [nativeName] languages text", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(
            child: buildLanguageSelectionCard,
          );

          expect(find.text("Bahasa Indonesia"), findsOneWidget);
          expect(find.text("русский язык"), findsOneWidget);
        });
      });
    });
  });
}
