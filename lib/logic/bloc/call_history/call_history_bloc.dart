/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'call_history_event.dart';
part 'call_history_state.dart';

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  final CallingRepository _callingRepository = sl<CallingRepository>();
  final Logger _logger = Logger("Call History Bloc");

  CallHistoryBloc() : super(CallHistoryInitial()) {
    on<CallHistoryFetched>(_onFetched);
  }

  void _onFetched(
    CallHistoryFetched event,
    Emitter<CallHistoryState> emit,
  ) async {
    emit(const CallHistoryLoading());
    _logger.info("Getting call history data ...");

    try {
      final data = await _callingRepository.getCallHistory();

      // Grouping same data for same date
      data.sort((a, b) {
        final aDate = a.localCreatedAt?.toLocal();
        final bDate = b.localCreatedAt?.toLocal();

        if (aDate == null || bDate == null) {
          return 0;
        }

        return bDate.compareTo(aDate);
      });

      List<List<CallHistory>> groupingData = [];

      String? prevDate;

      for (var call in data) {
        final localCreatedAt = call.localCreatedAt;
        if (localCreatedAt != null) {
          String currendDate = DateFormat.yMEd().format(localCreatedAt);

          if (currendDate != prevDate) {
            groupingData.add([call]);
          } else {
            groupingData.last.add(call);
          }

          prevDate = currendDate;
        } else {
          prevDate = null;
        }
      }

      _logger.fine("Getting call history data successfully");
      emit(CallHistoryLoaded(groupingData));
    } on CallingFailure catch (e) {
      _logger.shout("Error to get call history data");
      emit(CallHistoryError(e));
    } catch (e) {
      _logger.shout("Error to get call history data");
      emit(const CallHistoryError());
    }

    event.completer?.complete();
  }
}
