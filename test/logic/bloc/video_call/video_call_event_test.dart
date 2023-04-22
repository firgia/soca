/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("VideoCallStarted", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
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

        final event = VideoCallStarted(callingSetup: callingSetup);

        expect(event.callingSetup, callingSetup);
      });
    });
  });

  group("VideoCallSettingFlipUpdated", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event = VideoCallSettingFlipUpdated(callID: "123", value: false);
        const event2 = VideoCallSettingFlipUpdated(callID: "456", value: true);

        expect(event.callID, "123");
        expect(event.value, false);

        expect(event2.callID, "456");
        expect(event2.value, true);
      });
    });
  });

  group("VideoCallSettingFlashlightUpdated", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event =
            VideoCallSettingFlashlightUpdated(callID: "123", value: false);
        const event2 =
            VideoCallSettingFlashlightUpdated(callID: "456", value: true);

        expect(event.callID, "123");
        expect(event.value, false);

        expect(event2.callID, "456");
        expect(event2.value, true);
      });
    });
  });

  group("VideoCallIsLocalJoinedChanged", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event = VideoCallIsLocalJoinedChanged(false);
        const event2 = VideoCallIsLocalJoinedChanged(true);

        expect(event.value, false);
        expect(event2.value, true);
      });
    });
  });

  group("VideoCallIsUserOfflineChanged", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event = VideoCallIsUserOfflineChanged(false);
        const event2 = VideoCallIsUserOfflineChanged(true);

        expect(event.value, false);
        expect(event2.value, true);
      });
    });
  });

  group("VideoCallRemoteUIDChanged", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event = VideoCallRemoteUIDChanged(1);
        const event2 = VideoCallRemoteUIDChanged(2);

        expect(event.value, 1);
        expect(event2.value, 2);
      });
    });
  });
}
