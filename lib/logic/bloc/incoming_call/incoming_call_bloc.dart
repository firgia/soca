/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';

part 'incoming_call_event.dart';
part 'incoming_call_state.dart';

class IncomingCallBloc extends Bloc<IncomingCallEvent, IncomingCallState> {
  CallEvent? tempCallEvent;

  IncomingCallBloc() : super(const IncomingCallInitial()) {
    on<IncomingCallEventAdded>(_onEventAdded);
    on<IncomingCallEventRemoved>(_onEventRemoved);
    on<IncomingCallFetched>(_onFetched);
  }

  void _onEventAdded(
    IncomingCallEventAdded event,
    Emitter<IncomingCallState> emit,
  ) {
    tempCallEvent = event.data;
    _fetch(emit);
  }

  void _onFetched(
    IncomingCallFetched event,
    Emitter<IncomingCallState> emit,
  ) {
    _fetch(emit);
  }

  void _onEventRemoved(
    IncomingCallEventRemoved event,
    Emitter<IncomingCallState> emit,
  ) {
    tempCallEvent = null;
    emit(const IncomingCallEmpty());
  }

  void _fetch(Emitter<IncomingCallState> emit) {
    final callEvent = tempCallEvent;
    if (callEvent == null) return;

    final event = callEvent.event;
    final data = CallKitData.getDataFromEvent(callEvent);

    if (event == Event.ACTION_CALL_ACCEPT && data != null) {
      final type = data.type;
      final callID = data.uuid;
      final blindID = data.userCaller?.uid;
      final blindName = data.userCaller?.name;
      final blindAvatar = data.userCaller?.avatar;

      if (type == "incoming_video_call" && callID != null && blindID != null) {
        emit(
          IncomingCallLoaded(
            id: callID,
            blindID: blindID,
            name: blindName,
            urlImage: blindAvatar,
          ),
        );
      } else {
        tempCallEvent = null;
        emit(const IncomingCallEmpty());
      }
    }
  }
}
