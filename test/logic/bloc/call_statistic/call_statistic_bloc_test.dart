/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
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
  late MockUserRepository userRepository;

  setUp(() {
    registerLocator();
    callingRepository = getMockCallingRepository();
    userRepository = getMockUserRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    group("CallStatisticFetched()", () {
      MockCompleter completer = MockCompleter();

      blocTest<CallStatisticBloc, CallStatisticState>(
        'Should emits [CallStatisticLoading, CallStatisticState] when '
        'Successfully to get call statistic data',
        build: () => CallStatisticBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              User(
                type: UserType.blind,
                info: UserInfo(
                  listOfCallYears: const ["2020", "2021"],
                  totalCalls: 10,
                  dateJoined: DateTime.now().add(const Duration(days: -3)),
                ),
              ),
            ),
          );

          when(callingRepository.getCallStatistic(
            year: "2021",
            locale: "en",
          )).thenAnswer(
            (_) => Future.value(const CallStatistic(
              total: 20,
              monthlyStatistics: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                )
              ],
            )),
          );
        },
        act: (bloc) => bloc.add(const CallStatisticFetched("en")),
        expect: () => const <CallStatisticState>[
          CallStatisticLoading(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
          CallStatisticState(
            calls: [
              CallDataMounthly(
                total: 20,
                month: "Apr",
              )
            ],
            listOfYear: ["2020", "2021"],
            selectedYear: "2021",
            totalCall: 20,
            totalDayJoined: 3,
            userType: UserType.blind,
          ),
        ],
      );

      blocTest<CallStatisticBloc, CallStatisticState>(
        'Should call complete the completer when available',
        build: () => CallStatisticBloc(),
        setUp: () {
          completer = MockCompleter();

          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              User(
                type: UserType.blind,
                info: UserInfo(
                  listOfCallYears: const ["2020", "2021"],
                  totalCalls: 10,
                  dateJoined: DateTime.now().add(const Duration(days: -3)),
                ),
              ),
            ),
          );

          when(callingRepository.getCallStatistic(
            year: "2021",
            locale: "en",
          )).thenAnswer(
            (_) => Future.value(const CallStatistic(
              total: 20,
              monthlyStatistics: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                )
              ],
            )),
          );
        },
        act: (bloc) => bloc.add(CallStatisticFetched(
          "en",
          completer: completer,
        )),
        expect: () => const <CallStatisticState>[
          CallStatisticLoading(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
          CallStatisticState(
            calls: [
              CallDataMounthly(
                total: 20,
                month: "Apr",
              )
            ],
            listOfYear: ["2020", "2021"],
            selectedYear: "2021",
            totalCall: 20,
            totalDayJoined: 3,
            userType: UserType.blind,
          ),
        ],
        verify: (bloc) {
          verify(completer.complete(any));
        },
      );

      blocTest<CallStatisticBloc, CallStatisticState>(
        'Should emits [CallStatisticLoading, CallStatisticError] when '
        'Successfully to get call statistic data',
        build: () => CallStatisticBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              User(
                type: UserType.blind,
                info: UserInfo(
                  listOfCallYears: const ["2020", "2021"],
                  totalCalls: 10,
                  dateJoined: DateTime.now().add(const Duration(days: -3)),
                ),
              ),
            ),
          );

          when(callingRepository.getCallStatistic(
            year: "2021",
            locale: "en",
          )).thenThrow(const CallingFailure());
        },
        act: (bloc) => bloc.add(const CallStatisticFetched("en")),
        expect: () => const <CallStatisticState>[
          CallStatisticLoading(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
          CallStatisticError(
            calls: [],
            listOfYear: ["2020", "2021"],
            selectedYear: "2021",
            totalCall: null,
            totalDayJoined: 3,
            userType: UserType.blind,
            callingFailure: CallingFailure(),
          ),
        ],
      );
    });

    group("CallStatisticYearChanged()", () {
      blocTest<CallStatisticBloc, CallStatisticState>(
        'Should emits [CallStatisticLoading, CallStatisticState] when '
        'Successfully to get call statistic data',
        build: () => CallStatisticBloc(),
        setUp: () {
          when(callingRepository.getCallStatistic(
            year: "2020",
            locale: "en",
          )).thenAnswer(
            (_) => Future.value(const CallStatistic(
              total: 20,
              monthlyStatistics: [
                CallDataMounthly(
                  total: 20,
                  month: "Apr",
                )
              ],
            )),
          );
        },
        act: (bloc) => bloc.add(const CallStatisticYearChanged(
          year: "2020",
          locale: "en",
        )),
        expect: () => const <CallStatisticState>[
          CallStatisticLoading(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
          CallStatisticState(
            calls: [
              CallDataMounthly(
                total: 20,
                month: "Apr",
              )
            ],
            listOfYear: [],
            selectedYear: "2020",
            totalCall: 20,
            totalDayJoined: null,
            userType: null,
          ),
        ],
      );

      blocTest<CallStatisticBloc, CallStatisticState>(
        'Should emits [CallStatisticLoading, CallStatisticError] when '
        'Successfully to get call statistic data',
        build: () => CallStatisticBloc(),
        setUp: () {
          when(callingRepository.getCallStatistic(
            year: "2020",
            locale: "en",
          )).thenThrow(const CallingFailure());
        },
        act: (bloc) => bloc.add(const CallStatisticYearChanged(
          year: "2020",
          locale: "en",
        )),
        expect: () => const <CallStatisticState>[
          CallStatisticLoading(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
          CallStatisticError(
            calls: [],
            listOfYear: [],
            selectedYear: "2020",
            totalCall: null,
            totalDayJoined: null,
            userType: null,
            callingFailure: CallingFailure(),
          ),
        ],
      );
    });
  });
}
