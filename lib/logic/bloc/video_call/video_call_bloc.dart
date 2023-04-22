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
import 'package:logging/logging.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final CallingRepository _callingRepository = sl<CallingRepository>();
  final Logger _logger = Logger("Video Call Bloc");

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
    on<VideoCallSettingFlashlightUpdated>(_onSettingFlashlightUpdated);
    on<VideoCallSettingFlipUpdated>(_onSettingFlipUpdated);
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
        onError: (error, stackTrace) => VideoCallError.fromState(
          state,
          error is CallingFailure ? error : null,
        ),
      ),
      emit.forEach(
        _callingRepository.onCallSettingUpdated(setup.id),
        onData: (data) {
          return state.copyWith(setting: data);
        },
        onError: (error, stackTrace) => VideoCallError.fromState(
          state,
          error is CallingFailure ? error : null,
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

  void _onSettingFlashlightUpdated(
    VideoCallSettingFlashlightUpdated event,
    Emitter<VideoCallState> emit,
  ) async {
    String callID = event.callID;

    emit(VideoCallSettingFlashlightLoading.fromState(state));
    _logger.info("Updating flashlight data...");

    try {
      await _callingRepository.updateCallSettings(
        callID: callID,
        enableFlashlight: event.value,
        enableFlip: null,
      );

      emit(
        VideoCallState(
          isCallEnded: state.isCallEnded,
          isLocalJoined: state.isLocalJoined,
          isUserOffline: state.isUserOffline,
          remoteUID: state.remoteUID,
          setting: state.setting,
        ),
      );
    } on CallingFailure catch (e) {
      _logger.shout("Error to update flashlight data");
      emit(VideoCallError.fromState(state, e));
    } catch (e) {
      _logger.shout("Error to update flashlight data");
      emit(VideoCallError.fromState(state));
    }
  }

  void _onSettingFlipUpdated(
    VideoCallSettingFlipUpdated event,
    Emitter<VideoCallState> emit,
  ) async {
    String callID = event.callID;

    emit(VideoCallSettingFlipLoading.fromState(state));
    _logger.info("Updating flip data...");

    try {
      await _callingRepository.updateCallSettings(
        callID: callID,
        enableFlashlight: null,
        enableFlip: event.value,
      );

      emit(
        VideoCallState(
          isCallEnded: state.isCallEnded,
          isLocalJoined: state.isLocalJoined,
          isUserOffline: state.isUserOffline,
          remoteUID: state.remoteUID,
          setting: state.setting,
        ),
      );
    } on CallingFailure catch (e) {
      _logger.shout("Error to update flip data");
      emit(VideoCallError.fromState(state, e));
    } catch (e) {
      _logger.shout("Error to update flip data");
      emit(VideoCallError.fromState(state));
    }
  }
}
