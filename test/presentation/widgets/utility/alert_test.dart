/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

  testWidgets("Should show authentication error message", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Alert(context).showAuthenticationErrorMessage();
                },
                child: const Text("show alert"),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text("show alert"));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key("error_message_authentication_error")),
        findsOneWidget,
      );

      expect(find.byType(ErrorMessage), findsOneWidget);
    });
  });

  testWidgets("Should show internet error message", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Alert(context).showInternetErrorMessage();
                },
                child: const Text("show alert"),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text("show alert"));
      await tester.pump();

      expect(
        find.byKey(const Key("error_message_internet_error")),
        findsOneWidget,
      );

      expect(find.byType(ErrorMessage), findsOneWidget);
    });
  });

  testWidgets("Should show something error message", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Alert(context).showSomethingErrorMessage();
                },
                child: const Text("show alert"),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text("show alert"));
      await tester.pump();

      expect(
        find.byKey(const Key("error_message_something_error")),
        findsOneWidget,
      );

      expect(find.byType(ErrorMessage), findsOneWidget);
    });
  });
}
