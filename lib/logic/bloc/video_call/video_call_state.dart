/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'video_call_bloc.dart';

class VideoCallState extends Equatable {
  final CallSetting? setting;
  final bool isLocalJoined;
  final bool isCallEnded;
  final bool isUserOffline;
  final int? remoteUID;

  const VideoCallState({
    required this.setting,
    required this.isLocalJoined,
    required this.isCallEnded,
    required this.isUserOffline,
    required this.remoteUID,
  });

  VideoCallState copyWith({
    CallSetting? setting,
    bool? isLocalJoined,
    bool? isCallEnded,
    bool? isUserOffline,
    int? remoteUID,
  }) {
    return VideoCallState(
      setting: setting ?? this.setting,
      isLocalJoined: isLocalJoined ?? this.isLocalJoined,
      isCallEnded: isCallEnded ?? this.isCallEnded,
      isUserOffline: isUserOffline ?? this.isUserOffline,
      remoteUID: remoteUID ?? this.remoteUID,
    );
  }

  @override
  List<Object?> get props => [
        setting,
        isLocalJoined,
        isCallEnded,
        isUserOffline,
        remoteUID,
      ];
}

class VideoCallSettingFlipLoading extends VideoCallState {
  const VideoCallSettingFlipLoading({
    required super.setting,
    required super.isLocalJoined,
    required super.isCallEnded,
    required super.isUserOffline,
    required super.remoteUID,
  });

  factory VideoCallSettingFlipLoading.fromState(VideoCallState state) =>
      VideoCallSettingFlipLoading(
        isCallEnded: state.isCallEnded,
        isLocalJoined: state.isLocalJoined,
        isUserOffline: state.isUserOffline,
        remoteUID: state.remoteUID,
        setting: state.setting,
      );
}

class VideoCallSettingFlashlightLoading extends VideoCallState {
  const VideoCallSettingFlashlightLoading({
    required super.setting,
    required super.isLocalJoined,
    required super.isCallEnded,
    required super.isUserOffline,
    required super.remoteUID,
  });

  factory VideoCallSettingFlashlightLoading.fromState(VideoCallState state) =>
      VideoCallSettingFlashlightLoading(
        isCallEnded: state.isCallEnded,
        isLocalJoined: state.isLocalJoined,
        isUserOffline: state.isUserOffline,
        remoteUID: state.remoteUID,
        setting: state.setting,
      );
}

class VideoCallError extends VideoCallState {
  final CallingFailure? failure;

  const VideoCallError({
    required super.setting,
    required super.isLocalJoined,
    required super.isCallEnded,
    required super.isUserOffline,
    required super.remoteUID,
    this.failure,
  });

  factory VideoCallError.fromState(VideoCallState state,
          [CallingFailure? failure]) =>
      VideoCallError(
        isCallEnded: state.isCallEnded,
        isLocalJoined: state.isLocalJoined,
        isUserOffline: state.isUserOffline,
        remoteUID: state.remoteUID,
        setting: state.setting,
        failure: failure,
      );

  @override
  List<Object?> get props => super.props + [failure];
}
