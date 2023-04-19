/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'video_call_bloc.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

class VideoCallStarted extends VideoCallEvent {
  final CallingSetup callingSetup;
  final RtcEngine rtcEngine;

  const VideoCallStarted({
    required this.callingSetup,
    required this.rtcEngine,
  });

  @override
  List<Object?> get props => [
        callingSetup,
        rtcEngine,
      ];
}

class VideoCallSettingFlipUpdated extends VideoCallEvent {
  final bool value;

  const VideoCallSettingFlipUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class VideoCallSettingFlashlightUpdated extends VideoCallEvent {
  final bool value;

  const VideoCallSettingFlashlightUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

/// This event is only called on the VideoCallStarted process
class _VideoCallForceUpdated extends VideoCallEvent {
  final VideoCallState state;
  const _VideoCallForceUpdated(this.state);

  @override
  List<Object?> get props => [state];
}
