/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late CallHistoryBloc callHistoryBloc;
  late MockDeviceInfo deviceInfo;
  late MockDeviceFeedback deviceFeedback;
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();

    callHistoryBloc = getMockCallHistoryBloc();
    deviceInfo = getMockDeviceInfo();
    deviceFeedback = getMockDeviceFeedback();
    widgetBinding = getMockWidgetsBinding();

    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.dark);
    when(widgetBinding.window).thenReturn(window);
    when(deviceInfo.isAndroid()).thenReturn(false);
    when(deviceInfo.isIOS()).thenReturn(true);
  });

  tearDown(() => unregisterLocator());

  Finder findCallHistoryCard() => find.byKey(const Key("call_history_card"));
  Finder findCallHistoryCardLoading() =>
      find.byKey(const Key("call_history_card_loading"));

  Finder findErrorMessageSomethingError() =>
      find.byKey(const Key("error_message_something_error"));
  group("Initial", () {
    testWidgets("Should call callHistoryBloc.add(CallHistoryFetched)",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const CallHistoryScreen());

        verify(callHistoryBloc.add(const CallHistoryFetched()));
      });
    });
  });

  group("Bloc Listener", () {
    testWidgets("Should show something error when [CallHistoryError]",
        (tester) async {
      await tester.runAsync(() async {
        when(callHistoryBloc.stream).thenAnswer(
          (_) => Stream.value(const CallHistoryError()),
        );

        await tester.pumpApp(child: const CallHistoryScreen());
        await tester.pump();

        expect(findErrorMessageSomethingError(), findsOneWidget);
      });
    });
  });

  group("Call History Card", () {
    testWidgets("Should show [CallHistoryCard] when CallHistoryLoaded",
        (tester) async {
      await tester.runAsync(() async {
        when(callHistoryBloc.stream).thenAnswer(
          (_) => Stream.value(
            const CallHistoryLoaded(
              [
                [CallHistory()],
                [CallHistory()]
              ],
            ),
          ),
        );

        await tester.pumpApp(child: const CallHistoryScreen());
        await tester.pump();
        expect(findCallHistoryCard(), findsNWidgets(2));
      });
    });

    testWidgets("Should show empty [CallHistoryCard] when CallHistoryError",
        (tester) async {
      await tester.runAsync(() async {
        when(callHistoryBloc.stream).thenAnswer(
          (_) => Stream.value(
            const CallHistoryError(
              CallingFailure(code: CallingFailureCode.notFound),
            ),
          ),
        );

        await tester.pumpApp(child: const CallHistoryScreen());
        await tester.pump();
        expect(findCallHistoryCard(), findsNothing);
        expect(findCallHistoryCardLoading(), findsNothing);
      });
    });

    testWidgets("Should show [CallHistoryCard.loading] when CallHistoryLoading",
        (tester) async {
      await tester.runAsync(() async {
        when(callHistoryBloc.stream)
            .thenAnswer((_) => Stream.value(const CallHistoryLoading()));

        await tester.pumpApp(child: const CallHistoryScreen());
        await tester.pump();
        expect(findCallHistoryCardLoading(), findsWidgets);
      });
    });
  });

  group("Refresh", () {
    testWidgets("Should fetched call history data when refresh",
        (tester) async {
      await tester.runAsync(() async {
        when(callHistoryBloc.state).thenReturn(const CallHistoryLoading());

        MockCompleter completer = getMockCompleter();
        await tester.pumpApp(child: const CallHistoryScreen());
        await tester.setScreenSize(iphone14);

        verify(callHistoryBloc.add(const CallHistoryFetched()));
        await tester.drag(find.byType(SwipeRefresh), const Offset(0, 400));
        await tester.pump();
        verify(callHistoryBloc.add(CallHistoryFetched(completer: completer)));
      });
    });
  });

  group("Voice Assistant", () {
    testWidgets('Should play call history info', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(child: const CallHistoryScreen());

        verify(
          deviceFeedback.playVoiceAssistant(
            [
              LocaleKeys.va_call_history_page.tr(),
            ],
            any,
            immediately: true,
          ),
        );
      });
    });
  });
}
