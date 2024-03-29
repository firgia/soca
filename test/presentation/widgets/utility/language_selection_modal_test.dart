/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 18 2023
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

    MockPlatformDispatcher platformDispatcher = MockPlatformDispatcher();
    when(platformDispatcher.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.platformDispatcher).thenReturn(platformDispatcher);
  });

  tearDown(() => unregisterLocator());

  Finder findBottomSheetTitleText() => find.byType(BottomSheetTitleText);
  Finder findDialogTitleText() => find.byType(DialogTitleText);
  Finder findLanguageSelectionCard() => find.byType(LanguageSelectionCard);

  group("Language Selection Content", () {
    testWidgets("Should show [LanguageSelectionCard]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    LanguageSelectionModal modal =
                        LanguageSelectionModal(context);

                    modal.showSelectionLanguageUI(
                      selected: [],
                      selection: [
                        const Language(
                          code: "id",
                          name: "Indonesian",
                          nativeName: "Bahasa Indonesia",
                        )
                      ],
                      onSelected: (selected) {},
                    );
                  },
                  child: const Text("show selection language"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show selection language"));
        await tester.pumpAndSettle();

        expect(
          findLanguageSelectionCard(),
          findsOneWidget,
        );

        expect(find.text("Indonesian"), findsOneWidget);
        expect(find.text("Bahasa Indonesia"), findsOneWidget);
      });
    });
  });

  group("Text", () {
    Widget buildScafoldLanguageSelection = Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              LanguageSelectionModal modal = LanguageSelectionModal(context);

              modal.showSelectionLanguageUI(
                selected: [],
                selection: [],
                onSelected: (selected) {},
              );
            },
            child: const Text("show selection language"),
          );
        },
      ),
    );

    testWidgets("Should show [DialogTitleText] when device is tablet ",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: buildScafoldLanguageSelection);

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        await tester.tap(find.text("show selection language"));
        await tester.pumpAndSettle();

        expect(
          findDialogTitleText(),
          findsOneWidget,
        );

        expect(
          findBottomSheetTitleText(),
          findsNothing,
        );
      });
    });

    testWidgets("Should show [BottomSheetTitleText] when device is mobile",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: buildScafoldLanguageSelection);

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        await tester.tap(find.text("show selection language"));
        await tester.pumpAndSettle();

        expect(
          findBottomSheetTitleText(),
          findsOneWidget,
        );

        expect(
          findDialogTitleText(),
          findsNothing,
        );
      });
    });
  });
}
