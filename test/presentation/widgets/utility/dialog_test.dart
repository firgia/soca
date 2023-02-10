/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;
  late MockSingletonFlutterWindow window;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    window = MockSingletonFlutterWindow();
  });

  tearDown(() => unregisterLocator());

  group("show", () {
    testWidgets("Should show the child", (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        return const SizedBox(
                          key: Key("test_child"),
                        );
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key("test_child")),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show the child based on brightness dark",
        (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.dark);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        if (brightness == Brightness.dark) {
                          return const SizedBox(
                            key: Key("test_child_dark"),
                          );
                        } else {
                          return const SizedBox(
                            key: Key("test_child_light"),
                          );
                        }
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();

        Dialog dialog = find.byType(Dialog).getWidget() as Dialog;

        expect(dialog.backgroundColor, AppColors.cardDark);

        expect(
          find.byKey(const Key("test_child_dark")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("test_child_light")),
          findsNothing,
        );
      });
    });

    testWidgets("Should show the child based on brightness light",
        (tester) async {
      when(window.platformBrightness).thenReturn(Brightness.light);
      when(widgetBinding.window).thenReturn(window);

      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppDialog dialog = AppDialog(context);

                    dialog.show(
                      childBuilder: (context, brightness) {
                        if (brightness == Brightness.dark) {
                          return const SizedBox(
                            key: Key("test_child_dark"),
                          );
                        } else {
                          return const SizedBox(
                            key: Key("test_child_light"),
                          );
                        }
                      },
                    );
                  },
                  child: const Text("show dialog"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show dialog"));
        await tester.pumpAndSettle();

        Dialog dialog = find.byType(Dialog).getWidget() as Dialog;

        expect(dialog.backgroundColor, AppColors.cardLight);

        expect(
          find.byKey(const Key("test_child_light")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("test_child_dark")),
          findsNothing,
        );
      });
    });
  });
}
