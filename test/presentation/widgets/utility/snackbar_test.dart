/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockDeviceFeedback deviceFeedback;
  late MockWidgetsBinding widgetBinding;
  late MockSingletonFlutterWindow window;

  setUp(() {
    registerLocator();
    deviceFeedback = getMockDeviceFeedback();
    widgetBinding = getMockWidgetsBinding();
    window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  group(".showMessage()", () {
    testWidgets("Should show the message text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppSnackbar snackbar = AppSnackbar(context);

                    snackbar.showMessage("snackbar message");
                  },
                  child: const Text("show snackbar"),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text("show snackbar"));
        await tester.pumpAndSettle();

        expect(find.text("snackbar message"), findsOneWidget);
        verify(deviceFeedback.vibrate());
        verify(deviceFeedback.playVoiceAssistant("snackbar message"));
      });
    });
  });
}
