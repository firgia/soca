/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockCallingRepository callingRepository;

  setUp(() {
    registerLocator();
    callingRepository = getMockCallingRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    group("VideoCallStarted()", () {
      CallingSetup callingSetup = const CallingSetup(
        id: "1",
        rtc: RTCIdentity(token: "abc", channelName: "a", uid: 1),
        localUser: UserCallIdentity(
          name: "name",
          uid: "uid",
          avatar: "avatar",
          type: UserType.blind,
        ),
        remoteUser: UserCallIdentity(
          name: "name",
          uid: "uid",
          avatar: "avatar",
          type: UserType.volunteer,
        ),
      );

      blocTest<VideoCallBloc, VideoCallState>(
        'Should emits [VideoCallState] and change the [setting] value',
        build: () => VideoCallBloc(),
        setUp: () {
          when(callingRepository.onCallSettingUpdated(any)).thenAnswer(
            (_) => Stream.fromIterable(
              const [
                CallSetting(enableFlashlight: false, enableFlip: false),
                CallSetting(enableFlashlight: false, enableFlip: true),
                CallSetting(enableFlashlight: true, enableFlip: true),
              ],
            ),
          );
        },
        act: (videoCall) {
          videoCall.add(VideoCallStarted(callingSetup: callingSetup));
        },
        expect: () => <VideoCallState>[
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: CallSetting(enableFlashlight: false, enableFlip: false),
          ),
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: CallSetting(enableFlashlight: false, enableFlip: true),
          ),
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: CallSetting(enableFlashlight: true, enableFlip: true),
          ),
        ],
        verify: (bloc) {
          verify(callingRepository.onCallSettingUpdated(any));
        },
      );

      blocTest<VideoCallBloc, VideoCallState>(
        'Should emits [VideoCallState] and change the [isCallEnded] value to '
        'true if  CallState is any ended type',
        build: () => VideoCallBloc(),
        setUp: () {
          when(callingRepository.onCallStateUpdated(any)).thenAnswer(
            (realInvocation) => Stream.fromIterable(
              [
                CallState.ended,
                CallState.ongoing,
                CallState.endedWithCanceled,
                CallState.ongoing,
                CallState.endedWithDeclined,
                CallState.ongoing,
                CallState.endedWithUnanswered,
              ],
            ),
          );
        },
        act: (videoCall) {
          videoCall.add(VideoCallStarted(callingSetup: callingSetup));
        },
        expect: () => <VideoCallState>[
          const VideoCallState(
            isCallEnded: true,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: true,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: true,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: false,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isCallEnded: true,
            isLocalJoined: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
        ],
        verify: (bloc) {
          verify(callingRepository.onCallStateUpdated(any));
        },
      );
    });

    group("VideoCallIsLocalJoinedChanged()", () {
      blocTest<VideoCallBloc, VideoCallState>(
        'Should emits [VideoCallState] and change the [isLocalJoined] value.',
        build: () => VideoCallBloc(),
        act: (videoCall) {
          videoCall.add(const VideoCallIsLocalJoinedChanged(true));
          videoCall.add(const VideoCallIsLocalJoinedChanged(false));
        },
        expect: () => <VideoCallState>[
          const VideoCallState(
            isLocalJoined: true,
            isCallEnded: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isLocalJoined: false,
            isCallEnded: false,
            isUserOffline: false,
            remoteUID: null,
            setting: null,
          ),
        ],
      );
    });

    group("VideoCallIsUserOfflineChanged()", () {
      blocTest<VideoCallBloc, VideoCallState>(
        'Should emits [VideoCallState] and change the [isUserOffline] value.',
        build: () => VideoCallBloc(),
        act: (videoCall) {
          videoCall.add(const VideoCallIsUserOfflineChanged(true));
          videoCall.add(const VideoCallIsUserOfflineChanged(false));
        },
        expect: () => <VideoCallState>[
          const VideoCallState(
            isUserOffline: true,
            isCallEnded: false,
            isLocalJoined: false,
            remoteUID: null,
            setting: null,
          ),
          const VideoCallState(
            isUserOffline: false,
            isCallEnded: false,
            isLocalJoined: false,
            remoteUID: null,
            setting: null,
          ),
        ],
      );
    });

    group("VideoCallRemoteUIDChanged()", () {
      blocTest<VideoCallBloc, VideoCallState>(
        'Should emits [VideoCallState] and change the [remoteUID] value.',
        build: () => VideoCallBloc(),
        act: (videoCall) {
          videoCall.add(const VideoCallRemoteUIDChanged(1));
          videoCall.add(const VideoCallRemoteUIDChanged(2));
        },
        expect: () => <VideoCallState>[
          const VideoCallState(
            isUserOffline: false,
            isCallEnded: false,
            isLocalJoined: false,
            remoteUID: 1,
            setting: null,
          ),
          const VideoCallState(
            isUserOffline: false,
            isCallEnded: false,
            isLocalJoined: false,
            remoteUID: 2,
            setting: null,
          ),
        ],
      );
    });
  });
}
