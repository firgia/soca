/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../widgets/widgets.dart';

part 'video_call_screen.component.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({required this.setup, super.key});

  final CallingSetup setup;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late String agoraAppID;
  late AppNavigator appNavigator;
  late CallActionBloc callActionBloc;
  late CallingSetup callingSetup;
  late DeviceInfo deviceInfo;
  late agora.RtcEngineEventHandler eventHandler;
  late agora.RtcEngine rtcEngine;
  late VideoCallBloc videoCallBloc;

  final Logger _logger = Logger("Video Call Screen");
  bool hasBeenSwitchCamera = false;
  bool? lastEnableFlashlight;
  bool? lastEnableFlip;
  bool isOnProcessEndCall = false;

  @override
  void initState() {
    super.initState();

    agoraAppID = Environtment.agoraAppID;
    appNavigator = sl<AppNavigator>();
    callingSetup = widget.setup;
    callActionBloc = sl<CallActionBloc>();
    deviceInfo = sl<DeviceInfo>();
    eventHandler = createHandler();
    rtcEngine = sl<agora.RtcEngine>();
    videoCallBloc = sl<VideoCallBloc>();

    videoCallBloc.add(
      VideoCallStarted(callingSetup: callingSetup),
    );

    initializeRTCEngine(agoraAppID);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => callActionBloc),
        BlocProvider(create: (context) => videoCallBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VideoCallBloc, VideoCallState>(
            listener: (context, state) async {
              bool? enableFlashlight = state.setting?.enableFlashlight;
              bool? enableFlip = state.setting?.enableFlip;

              AppSnackbar appSnackbar = AppSnackbar(context);

              if (state.isUserOffline && !isOnProcessEndCall) {
                isOnProcessEndCall = true;
                callActionBloc.add(CallActionEnded(callingSetup.id));
              } else if (state.isCallEnded) {
                appNavigator.back(context);
              }

              // Show enable or disable flashlight message
              if (enableFlashlight != null &&
                  lastEnableFlashlight != enableFlashlight) {
                lastEnableFlashlight = enableFlashlight;

                if (callingSetup.localUser.type == UserType.blind) {
                  await rtcEngine.setCameraTorchOn(enableFlashlight);
                }

                appSnackbar.showMessage(enableFlashlight
                    ? LocaleKeys.turn_on_flashlight.tr()
                    : LocaleKeys.turn_off_flashlight.tr());
              }
              // Show enable or disable flip mode message
              if (enableFlip != null && lastEnableFlip != enableFlip) {
                lastEnableFlip = enableFlip;
                appSnackbar.showMessage(enableFlip
                    ? LocaleKeys.turn_on_reverse_screen.tr()
                    : LocaleKeys.turn_off_reverse_screen.tr());
              }
            },
          ),
          BlocListener<CallActionBloc, CallActionState>(
            listener: (context, state) {
              if ((state is CallActionEndedSuccessfully) ||
                  (state is CallActionError &&
                      state.type == CallActionType.ended)) {
                isOnProcessEndCall = false;
                appNavigator.back(context);
              }
            },
          ),
        ],
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: callingSetup.localUser.type == UserType.blind
                      ? _VideoViewBlindUser(
                          rtcEngine: rtcEngine,
                          key: const Key(
                              "video_call_screen_video_view_blind_user"),
                        )
                      : _VideoViewVolunteerUser(
                          rtcEngine: rtcEngine,
                          callingSetup: callingSetup,
                          key: const Key(
                              "video_call_screen_video_view_volunteer_user"),
                        ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: _ShadowGradient(reverse: false),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: _ShadowGradient(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _ActionButton(
                    callingSetup: callingSetup,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _ProfileUser(
                    callingSetup: callingSetup,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initializeRTCEngine(String agoraAppID) async {
    if (agoraAppID.trim().isEmpty) {
      _logger.shout("Agora App ID is required");
      return;
    }

    _logger.info("Request microphone & camera permission...");

    await deviceInfo.requestPermissions([
      Permission.microphone,
      Permission.camera,
    ]);

    _logger.info("Initialize RTC Engine...");
    await rtcEngine.initialize(
      agora.RtcEngineContext(
        appId: agoraAppID,
        channelProfile: agora.ChannelProfileType.channelProfileLiveBroadcasting,
        audioScenario: agora.AudioScenarioType.audioScenarioMeeting,
      ),
    );

    _logger.info("Set event handler...");
    rtcEngine.registerEventHandler(eventHandler);

    _logger.info("Set client role...");
    await rtcEngine.setClientRole(
        role: agora.ClientRoleType.clientRoleBroadcaster);

    _logger.info("Enable video...");
    await rtcEngine.enableVideo();

    _logger.info("Enable audio...");
    await rtcEngine.enableAudio();

    _logger.info("Enable local audio...");
    await rtcEngine.enableLocalAudio(true);

    _logger.info("Set video encoder with 720p resolution...");
    await rtcEngine.setVideoEncoderConfiguration(
      const agora.VideoEncoderConfiguration(
        dimensions: agora.VideoDimensions(width: 720, height: 1280),
      ),
    );

    if (callingSetup.localUser.type == UserType.volunteer) {
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
      token: callingSetup.rtc.token,
      channelId: callingSetup.rtc.channelName,
      uid: callingSetup.rtc.uid,
      options: const agora.ChannelMediaOptions(),
    );

    _logger.fine("All configuration RTC Engine has been done.");
  }

  agora.RtcEngineEventHandler createHandler() {
    return agora.RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        _logger.info("local user ${connection.localUid} joined");

        if (callingSetup.localUser.type == UserType.blind &&
            !hasBeenSwitchCamera) {
          rtcEngine.switchCamera();
          hasBeenSwitchCamera = true;
        }

        videoCallBloc.add(const VideoCallIsLocalJoinedChanged(true));
      },
      onRejoinChannelSuccess: (connection, elapsed) {
        _logger.info("local user ${connection.localUid} rejoined");

        if (callingSetup.localUser.type == UserType.blind &&
            !hasBeenSwitchCamera) {
          rtcEngine.switchCamera();
          hasBeenSwitchCamera = true;
        }

        videoCallBloc.add(const VideoCallIsLocalJoinedChanged(true));
      },
      onUserJoined: (connection, uid, elapsed) {
        _logger.info("remote user $uid joined");

        videoCallBloc.add(VideoCallRemoteUIDChanged(uid));
      },
      onUserOffline: (connection, remoteUid, reason) {
        _logger.info("remote user $remoteUid left channel");

        videoCallBloc.add(const VideoCallIsUserOfflineChanged(true));
        videoCallBloc.add(const VideoCallRemoteUIDChanged(null));
      },
      onTokenPrivilegeWillExpire: (connection, token) {
        _logger.info(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    rtcEngine
        .leaveChannel(
          options: const agora.LeaveChannelOptions(
            stopAllEffect: true,
            stopAudioMixing: true,
            stopMicrophoneRecording: true,
          ),
        )
        .then((_) => rtcEngine.unregisterEventHandler(eventHandler));
  }
}
