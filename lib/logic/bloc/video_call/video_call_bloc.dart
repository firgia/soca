/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/config.dart';
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
    on<_VideoCallForceUpdated>(_onForceUpdated);
  }

  RtcEngineEventHandler? handler;
  bool hasBeenSwitchCamera = false;

  void _onStarted(
    VideoCallStarted event,
    Emitter<VideoCallState> emit,
  ) async {
    String agoraAppID = Environtment.agoraAppID;

    if (agoraAppID.isEmpty) {
      _logger.shout("Agora app id is required");
      emit(
        VideoCallError(
          isLocalJoined: state.isLocalJoined,
          setting: state.setting,
          isCallEnded: state.isCallEnded,
          isUserOffline: state.isUserOffline,
          remoteUID: state.remoteUID,
        ),
      );

      return;
    }

    RtcEngine rtcEngine = event.rtcEngine;
    CallingSetup setup = event.callingSetup;

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
    );

    _logger.info("Request microphone & camera permission...");
    await [Permission.microphone, Permission.camera].request();

    _logger.info("Initialize RTC Engine...");
    await rtcEngine.initialize(
      RtcEngineContext(
        appId: agoraAppID,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        audioScenario: AudioScenarioType.audioScenarioMeeting,
      ),
    );

    rtcEngine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        _logger.info("local user ${connection.localUid} joined");

        if (setup.localUser.type == UserType.blind && !hasBeenSwitchCamera) {
          rtcEngine.switchCamera();
          hasBeenSwitchCamera = true;
        }

        add(
          _VideoCallForceUpdated(
            state.copyWith(isLocalJoined: true),
          ),
        );
      },
      onRejoinChannelSuccess: (connection, elapsed) {
        _logger.info("local user ${connection.localUid} rejoined");

        if (setup.localUser.type == UserType.blind && !hasBeenSwitchCamera) {
          rtcEngine.switchCamera();
          hasBeenSwitchCamera = true;
        }

        add(
          _VideoCallForceUpdated(
            state.copyWith(isLocalJoined: true),
          ),
        );
      },
      onUserJoined: (connection, uid, elapsed) {
        _logger.info("remote user $uid joined");

        add(
          _VideoCallForceUpdated(
            state.copyWith(remoteUID: uid),
          ),
        );
      },
      onUserOffline: (connection, remoteUid, reason) {
        _logger.info("remote user $remoteUid left channel");

        add(
          _VideoCallForceUpdated(
            VideoCallState(
              setting: state.setting,
              isLocalJoined: state.isLocalJoined,
              isCallEnded: state.isCallEnded,
              isUserOffline: true,
              remoteUID: null,
            ),
          ),
        );
      },
      onTokenPrivilegeWillExpire: (connection, token) {
        _logger.info(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      },
    ));

    _logger.info("Set client role...");
    await rtcEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    _logger.info("Enable video...");
    await rtcEngine.enableVideo();

    _logger.info("Enable audio...");
    await rtcEngine.enableAudio();

    _logger.info("Enable local audio...");
    await rtcEngine.enableLocalAudio(true);

    _logger.info("Set video encoder with 720p resolution...");
    await rtcEngine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 720, height: 1280),
      ),
    );

    if (setup.localUser.type == UserType.volunteer) {
      _logger.info("Enable local video...");
      await rtcEngine.enableLocalVideo(false);

      _logger.info("Mute local video stream...");
      await rtcEngine.muteLocalVideoStream(true);
    }

    _logger.info("Start preview...");
    await rtcEngine.startPreview();

    _logger.info("Set camera torch to off...");
    await rtcEngine.setCameraTorchOn(false);

    _logger.info("Start to join channel...");
    await rtcEngine.joinChannel(
      token: setup.rtc.token,
      channelId: setup.rtc.channelName,
      uid: setup.rtc.uid,
      options: const ChannelMediaOptions(),
    );

    _logger.fine("All configuration RTC Engine has been done.");
  }

  void _onForceUpdated(
    _VideoCallForceUpdated event,
    Emitter<VideoCallState> emit,
  ) {
    emit(event.state);
  }
}
