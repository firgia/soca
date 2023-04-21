/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final CallingRepository _callingRepository = sl<CallingRepository>();

  VideoCallBloc()
      : super(
          const VideoCallState(
            isLocalJoined: false,
            setting: null,
            isCallEnded: false,
            isUserOffline: false,
            remoteUID: null,
          ),
        ) {
    on<VideoCallStarted>(_onStarted);
    on<VideoCallIsLocalJoinedChanged>(_onIsLocalJoinedChanged);
    on<VideoCallIsUserOfflineChanged>(_onIsUserOfflineChanged);
    on<VideoCallRemoteUIDChanged>(_onRemoteUIDChanged);
  }

  void _onStarted(
    VideoCallStarted event,
    Emitter<VideoCallState> emit,
  ) async {
    CallingSetup setup = event.callingSetup;

    await Future.wait([
      emit.forEach(
        _callingRepository.onCallStateUpdated(setup.id),
        onData: (data) {
          return state.copyWith(
              isCallEnded: data == CallState.ended ||
                  data == CallState.endedWithCanceled ||
                  data == CallState.endedWithDeclined ||
                  data == CallState.endedWithUnanswered);
        },
        onError: (error, stackTrace) => VideoCallError(
          setting: state.setting,
          isLocalJoined: state.isLocalJoined,
          isCallEnded: state.isCallEnded,
          isUserOffline: state.isUserOffline,
          remoteUID: state.remoteUID,
        ),
      ),
      emit.forEach(
        _callingRepository.onCallSettingUpdated(setup.id),
        onData: (data) {
          return state.copyWith(setting: data);
        },
        onError: (error, stackTrace) => VideoCallError(
          setting: state.setting,
          isLocalJoined: state.isLocalJoined,
          isCallEnded: state.isCallEnded,
          isUserOffline: state.isUserOffline,
          remoteUID: state.remoteUID,
        ),
      )
    ]);
  }

  void _onIsLocalJoinedChanged(
    VideoCallIsLocalJoinedChanged event,
    Emitter<VideoCallState> emit,
  ) {
    emit(state.copyWith(isLocalJoined: event.value));
  }

  void _onIsUserOfflineChanged(
    VideoCallIsUserOfflineChanged event,
    Emitter<VideoCallState> emit,
  ) {
    emit(state.copyWith(isUserOffline: event.value));
  }

  void _onRemoteUIDChanged(
    VideoCallRemoteUIDChanged event,
    Emitter<VideoCallState> emit,
  ) {
    emit(state.copyWith(remoteUID: event.value));
  }
}
