/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

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

  Finder findCallItem() => find.byType(CallItem);

  group("CallHistoryCard", () {
    testWidgets("Should show list of [CallItem]", (tester) async {
      await tester.runAsync(() async {
        const CallHistory callHistory1 = CallHistory(id: "123");
        const CallHistory callHistory2 = CallHistory(id: "456");

        await tester.pumpApp(
          child: const Scaffold(
            body: CallHistoryCard(
              data: [
                callHistory1,
                callHistory2,
              ],
            ),
          ),
        );

        CallItem callItem = findCallItem().getFirstWidget() as CallItem;
        expect(findCallItem(), findsNWidgets(2));
        expect(callItem.data, callHistory1);
      });
    });

    testWidgets(
        "Should show date & total call text when total call more than 1",
        (tester) async {
      await tester.runAsync(() async {
        CallHistory callHistory = CallHistory(
          id: "123",
          createdAt: DateTime.now(),
        );

        await tester.pumpApp(
          child: Scaffold(
            body: CallHistoryCard(
              data: [
                callHistory,
                callHistory,
              ],
            ),
          ),
        );

        expect(
            find.text(
              "${DateFormat.yMMMd().format(callHistory.localCreatedAt!)} (2)",
            ),
            findsOneWidget);
      });
    });
  });

  group("CallHistoryCard.loading", () {
    testWidgets("Should show [CustomShimmer]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: CallHistoryCard.loading(),
          ),
        );

        expect(find.byType(CustomShimmer), findsWidgets);
      });
    });
  });
}
