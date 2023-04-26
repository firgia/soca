/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("CallActionLoading", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        CallActionLoading callAction =
            const CallActionLoading(CallActionType.answered);

        expect(callAction.type, CallActionType.answered);
      });
    });
  });

  group("CallActionError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        CallActionError callAction =
            const CallActionError(CallActionType.answered, CallingFailure());

        expect(callAction.type, CallActionType.answered);
        expect(callAction.failure, const CallingFailure());
      });
    });
  });

  group("CallActionAnsweredSuccessfullyWithWaitingCaller", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        Call callData = const Call(id: "123");
        CallActionAnsweredSuccessfullyWithWaitingCaller callAction =
            CallActionAnsweredSuccessfullyWithWaitingCaller(callData);

        expect(callAction.data, callData);
      });
    });
  });

  group("CallActionAnsweredSuccessfully", () {
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

        CallActionAnsweredSuccessfully callAction =
            CallActionAnsweredSuccessfully(callingSetup);

        expect(callAction.data, callingSetup);
      });
    });
  });

  group("CallActionCreatedSuccessfullyWithWaitingAnswer", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        Call callData = const Call(id: "123");
        CallActionCreatedSuccessfullyWithWaitingAnswer callAction =
            CallActionCreatedSuccessfullyWithWaitingAnswer(callData);

        expect(callAction.data, callData);
      });
    });
  });

  group("CallActionCreatedSuccessfully", () {
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

        CallActionCreatedSuccessfully callAction =
            CallActionCreatedSuccessfully(callingSetup);

        expect(callAction.data, callingSetup);
      });
    });
  });
}
