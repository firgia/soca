/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:soca/injection.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';

part 'call_statistic_event.dart';
part 'call_statistic_state.dart';

class CallStatisticBloc extends Bloc<CallStatisticEvent, CallStatisticState> {
  final CallingRepository _callingRepository = sl<CallingRepository>();
  final UserRepository _userRepository = sl<UserRepository>();

  final Logger _logger = Logger("Call Statistic Bloc");

  CallStatisticBloc()
      : super(
          const CallStatisticState(
            calls: [],
            listOfYear: [],
            selectedYear: null,
            totalCall: null,
            totalDayJoined: null,
            userType: null,
          ),
        ) {
    on<CallStatisticYearChanged>(_onYearChanged);
    on<CallStatisticFetched>(_onStatisticFetched);
  }

  void _onYearChanged(
    CallStatisticYearChanged event,
    Emitter<CallStatisticState> emit,
  ) async {
    emit(CallStatisticLoading.fromState(state));

    try {
      List<CallDataMounthly> calls = [];
      int? totalCall;

      final result = await _callingRepository.getCallStatistic(
        year: event.year,
        locale: event.locale,
      );

      List<CallDataMounthly>? monthlyStatistics = result.monthlyStatistics;
      totalCall = result.total;

      if (monthlyStatistics != null) {
        calls = monthlyStatistics;
      }

      emit(
        CallStatisticState(
          selectedYear: event.year,
          userType: state.userType,
          listOfYear: state.listOfYear,
          calls: calls,
          totalCall: totalCall,
          totalDayJoined: state.totalDayJoined,
        ),
      );
    } on CallingFailure catch (e) {
      _logger.shout("Error to load statistic call");
      emit(
        CallStatisticError.fromState(state, callingFailure: e).copyWith(
          selectedYear: event.year,
        ),
      );
    } catch (e) {
      _logger.shout("Error to load statistic call");
      emit(CallStatisticError.fromState(state));
    }
  }

  void _onStatisticFetched(
    CallStatisticFetched event,
    Emitter<CallStatisticState> emit,
  ) async {
    emit(CallStatisticLoading.fromState(state));

    List<String>? listOfCallYears;
    UserType? userType;
    int? totalDayJoined;
    String? selectedYear;

    try {
      User user = await _userRepository.getProfile();

      listOfCallYears = user.info?.listOfCallYears;
      userType = user.type;

      DateTime? dateJoined = user.info?.localDateJoined;
      List<CallDataMounthly> calls = [];
      int? totalCall;

      if (dateJoined != null) {
        final currentDate = DateTime.now();
        final day = currentDate.difference(dateJoined).inDays;

        totalDayJoined = day;
      }

      if (listOfCallYears != null && listOfCallYears.isNotEmpty) {
        selectedYear = listOfCallYears.last;

        final result = await _callingRepository.getCallStatistic(
          year: selectedYear,
          locale: event.locale,
        );

        List<CallDataMounthly>? monthlyStatistics = result.monthlyStatistics;
        totalCall = result.total;

        if (monthlyStatistics != null) {
          calls = monthlyStatistics;
        }
      }

      emit(
        CallStatisticState(
          selectedYear: selectedYear,
          userType: userType,
          listOfYear: listOfCallYears ?? [],
          calls: calls,
          totalCall: totalCall,
          totalDayJoined: totalDayJoined,
        ),
      );
    } on UserFailure catch (e) {
      _logger.shout("Error to load statistic call");
      emit(CallStatisticError.fromState(state, userFailure: e));
    } on CallingFailure catch (e) {
      _logger.shout("Error to load statistic call");
      emit(
        CallStatisticError.fromState(state, callingFailure: e).copyWith(
          userType: userType,
          totalDayJoined: totalDayJoined,
          listOfYear: listOfCallYears,
          selectedYear: selectedYear,
        ),
      );
    } catch (e) {
      _logger.shout("Error to load statistic call");
      emit(CallStatisticError.fromState(state));
    }

    event.completer?.complete();
  }
}
