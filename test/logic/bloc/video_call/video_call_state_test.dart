/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("VideoCallState", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const VideoCallState state = VideoCallState(
          setting: CallSetting(enableFlip: false, enableFlashlight: true),
          isLocalJoined: true,
          isCallEnded: false,
          isUserOffline: false,
          remoteUID: 1,
        );

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: true));
        expect(state.isLocalJoined, true);
        expect(state.isCallEnded, false);
        expect(state.isUserOffline, false);
        expect(state.remoteUID, 1);
      });
    });

    group(".copyWith()", () {
      late VideoCallState defaultState;

      setUp(() {
        defaultState = const VideoCallState(
          setting: CallSetting(enableFlip: false, enableFlashlight: true),
          isLocalJoined: true,
          isCallEnded: false,
          isUserOffline: false,
          remoteUID: 1,
        );
      });

      test("Should copy the setting", () {
        VideoCallState state = defaultState.copyWith(
          setting:
              const CallSetting(enableFlashlight: false, enableFlip: false),
        );

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: false));

        expect(state.isLocalJoined, true);
        expect(state.isCallEnded, false);
        expect(state.isUserOffline, false);
        expect(state.remoteUID, 1);
      });

      test("Should copy the isLocalJoined", () {
        VideoCallState state = defaultState.copyWith(isLocalJoined: false);

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: true));
        expect(state.isLocalJoined, false);
        expect(state.isCallEnded, false);
        expect(state.isUserOffline, false);
        expect(state.remoteUID, 1);
      });

      test("Should copy the isCallEnded", () {
        VideoCallState state = defaultState.copyWith(isCallEnded: true);

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: true));
        expect(state.isLocalJoined, true);
        expect(state.isCallEnded, true);
        expect(state.isUserOffline, false);
        expect(state.remoteUID, 1);
      });

      test("Should copy the isUserOffline", () {
        VideoCallState state = defaultState.copyWith(isUserOffline: true);

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: true));
        expect(state.isLocalJoined, true);
        expect(state.isCallEnded, false);
        expect(state.isUserOffline, true);
        expect(state.remoteUID, 1);
      });

      test("Should copy the remoteUID", () {
        VideoCallState state = defaultState.copyWith(remoteUID: 2);

        expect(state.setting,
            const CallSetting(enableFlip: false, enableFlashlight: true));
        expect(state.isLocalJoined, true);
        expect(state.isCallEnded, false);
        expect(state.isUserOffline, false);
        expect(state.remoteUID, 2);
      });
    });
  });
}
