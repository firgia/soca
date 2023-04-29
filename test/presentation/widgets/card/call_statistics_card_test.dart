/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/widgets/widgets.dart';

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
  Finder findAdaptiveLoading() => find.byType(AdaptiveLoading);
  Finder findCallStisticsChart() => find.byType(CallStatisticChart);
  Finder findLottieBuilder() => find.byType(LottieBuilder);
  Finder findJoinedDaysText() =>
      find.byKey(const Key("call_statistics_joined_days_text"));

  Finder findNoCallDataYetBlindText() =>
      find.text(LocaleKeys.no_call_data_yet_blind_desc.tr());
  Finder findNoCallDataYetVolunteerText() =>
      find.text(LocaleKeys.no_call_data_yet_volunteer_desc.tr());

  group("CallStatisticsCard", () {
    testWidgets("Should show [CallStatisticChart]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard(
            dataSource: [
              CallDataMounthly(
                total: 99,
                month: "Jan",
              ),
            ],
            joinedDay: 368,
          ),
        );

        expect(
          findCallStisticsChart(),
          findsOneWidget,
        );
      });
    });

    testWidgets(
        "Should show joined day text when [joinedDay] is not null and more than 0",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard(
            dataSource: [
              CallDataMounthly(
                total: 99,
                month: "Jan",
              ),
            ],
            joinedDay: 368,
          ),
        );

        expect(
          findJoinedDaysText(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should hide joined day text when [joinedDay] null or 0",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard(
            dataSource: [
              CallDataMounthly(
                total: 99,
                month: "Jan",
              ),
            ],
            joinedDay: null,
          ),
        );

        expect(
          findJoinedDaysText(),
          findsNothing,
        );
      });
    });

    testWidgets("Should show header widget when [header] not null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard(
            dataSource: [
              CallDataMounthly(
                total: 99,
                month: "Jan",
              ),
            ],
            joinedDay: null,
            header: SizedBox(
              key: Key("this_is_header_widget"),
            ),
          ),
        );

        expect(
          find.byKey(const Key("this_is_header_widget")),
          findsOneWidget,
        );
      });
    });
  });

  group("CallStatisticsCard.adaptiveLoading()", () {
    testWidgets("Should show [AdaptiveLoading]", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.adaptiveLoading(),
        );

        expect(
          findAdaptiveLoading(),
          findsOneWidget,
        );

        expect(
          findLottieBuilder(),
          findsNothing,
        );
      });
    });
  });

  group("CallStatisticsCard.loading()", () {
    testWidgets("Should show [LottieBuilder] animation", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.loading(),
        );

        expect(
          findAdaptiveLoading(),
          findsNothing,
        );

        expect(
          findLottieBuilder(),
          findsOneWidget,
        );
      });
    });
  });

  group("CallStatisticsCard.empty()", () {
    testWidgets("Should show [LottieBuilder] animation", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: null,
          ),
        );

        expect(
          findLottieBuilder(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show no call data title", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: null,
          ),
        );

        expect(
          find.text(LocaleKeys.no_call_data_yet.tr()),
          findsOneWidget,
        );
      });
    });

    testWidgets(
        "Should hide no call data for specific user when [userType] is null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: null,
          ),
        );

        expect(
          findNoCallDataYetBlindText(),
          findsNothing,
        );

        expect(
          findNoCallDataYetVolunteerText(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show no call data for blind user when [userType] is blind",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: UserType.blind,
          ),
        );

        expect(
          findNoCallDataYetBlindText(),
          findsOneWidget,
        );

        expect(
          findNoCallDataYetVolunteerText(),
          findsNothing,
        );
      });
    });

    testWidgets(
        "Should show no call data for volunteer user when [userType] is volunteer",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: UserType.volunteer,
          ),
        );

        expect(
          findNoCallDataYetBlindText(),
          findsNothing,
        );

        expect(
          findNoCallDataYetVolunteerText(),
          findsOneWidget,
        );
      });
    });

    testWidgets("Should show header widget when [header] not null",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const CallStatisticsCard.empty(
            userType: null,
            header: SizedBox(
              key: Key("this_is_header_widget"),
            ),
          ),
        );

        expect(
          find.byKey(const Key("this_is_header_widget")),
          findsOneWidget,
        );
      });
    });
  });
}
