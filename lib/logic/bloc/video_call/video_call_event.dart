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

  const VideoCallStarted({
    required this.callingSetup,
  });

  @override
  List<Object?> get props => [
        callingSetup,
      ];
}

class VideoCallSettingFlipUpdated extends VideoCallEvent {
  final String callID;
  final bool value;

  const VideoCallSettingFlipUpdated({
    required this.callID,
    required this.value,
  });

  @override
  List<Object?> get props => [value];
}

class VideoCallSettingFlashlightUpdated extends VideoCallEvent {
  final String callID;
  final bool value;

  const VideoCallSettingFlashlightUpdated({
    required this.callID,
    required this.value,
  });

  @override
  List<Object?> get props => [value];
}

class VideoCallIsLocalJoinedChanged extends VideoCallEvent {
  final bool value;

  const VideoCallIsLocalJoinedChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class VideoCallIsUserOfflineChanged extends VideoCallEvent {
  final bool value;

  const VideoCallIsUserOfflineChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class VideoCallRemoteUIDChanged extends VideoCallEvent {
  final int? value;

  const VideoCallRemoteUIDChanged(this.value);

  @override
  List<Object?> get props => [value];
}
