/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockCallingRepository callingRepository;

  setUp(() {
    registerLocator();
    callingRepository = getMockCallingRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    group("CallHistoryFetched()", () {
      MockCompleter completer = MockCompleter();

      blocTest<CallHistoryBloc, CallHistoryState>(
        'Should emits [CallHistoryLoading, UserLoaded] when Successfully to get '
        'call history data and grouping the call history data for same date '
        'with Desc sort',
        build: () => CallHistoryBloc(),
        setUp: () {
          when(callingRepository.getCallHistory()).thenAnswer(
            (_) => Future.value([
              CallHistory(
                id: "1",
                createdAt: DateTime(2020, 1, 2, 2),
                role: CallRole.answerer,
              ),
              CallHistory(
                id: "2",
                createdAt: DateTime(2020, 1, 1),
                role: CallRole.caller,
              ),
              CallHistory(
                id: "3",
                createdAt: DateTime(2020, 1, 2, 1),
                role: CallRole.caller,
              ),
            ]),
          );
        },
        act: (bloc) => bloc.add(const CallHistoryFetched()),
        expect: () => <CallHistoryState>[
          const CallHistoryLoading(),
          CallHistoryLoaded([
            [
              CallHistory(
                id: "1",
                createdAt: DateTime(2020, 1, 2, 2),
                role: CallRole.answerer,
              ),
              CallHistory(
                id: "3",
                createdAt: DateTime(2020, 1, 2, 1),
                role: CallRole.caller,
              ),
            ],
            [
              CallHistory(
                id: "2",
                createdAt: DateTime(2020, 1, 1),
                role: CallRole.caller,
              ),
            ],
          ]),
        ],
      );

      blocTest<CallHistoryBloc, CallHistoryState>(
        'Should emits [CallHistoryLoading, CallHistoryError] when Error to get '
        'call history data',
        build: () => CallHistoryBloc(),
        setUp: () {
          when(callingRepository.getCallHistory())
              .thenThrow(const CallingFailure());
        },
        act: (bloc) => bloc.add(const CallHistoryFetched()),
        expect: () => const <CallHistoryState>[
          CallHistoryLoading(),
          CallHistoryError(CallingFailure()),
        ],
      );

      blocTest<CallHistoryBloc, CallHistoryState>(
        'Should call complete the completer when available',
        build: () => CallHistoryBloc(),
        setUp: () {
          completer = MockCompleter();
          when(callingRepository.getCallHistory())
              .thenThrow(const CallingFailure());
        },
        act: (bloc) => bloc.add(CallHistoryFetched(completer: completer)),
        verify: (bloc) {
          verify(completer.complete(any));
        },
      );
    });
  });
}
