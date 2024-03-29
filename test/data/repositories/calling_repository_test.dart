/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late CallingRepository callingRepository;
  late MockCallingProvider callingProvider;
  late MockAuthRepository authRepository;

  setUp(() {
    registerLocator();
    callingProvider = getMockCallingProvider();
    authRepository = getMockAuthRepository();
    callingRepository = CallingRepositoryImpl();
  });

  tearDown(() => unregisterLocator());

  group(".()", () {
    test("Should cancel all stream when sign out", () async {
      when(authRepository.onSignOut)
          .thenAnswer((_) => Stream.value(DateTime.now()));

      CallingRepositoryImpl();
      verify(authRepository.onSignOut);
      await Future.delayed(const Duration(milliseconds: 500));
      verify(callingProvider.cancelOnCallSettingUpdated());
      verify(callingProvider.cancelOnCallStateUpdated());
    });
  });

  group(".answerCall()", () {
    String callID = "123";
    String blindID = "12345";

    test("Should return the call data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(
        callingProvider.answerCall(
          callID: callID,
          blindID: blindID,
        ),
      ).thenAnswer(
        (_) => Future.value({
          "id": "123456",
          "target_volunteer_ids": [
            "ab",
            "cd",
          ],
          "rtc_channel_id": "abcd",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "456",
            "volunteer_id": "123",
          },
          "role": "caller",
          "state": "waiting",
        }),
      );

      Call? call = await callingRepository.answerCall(
        callID: callID,
        blindID: blindID,
      );

      expect(
        call,
        const Call(
          id: "123456",
          rtcChannelID: "abcd",
          settings: CallSetting(
            enableFlashlight: false,
            enableFlip: false,
          ),
          users: UserCall(
            blindID: "456",
            volunteerID: "123",
          ),
          state: CallState.waiting,
        ),
      );

      verify(authRepository.uid);
      verify(callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      ));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.answerCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.answerCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );

      expect(
          () => callingRepository.answerCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.answerCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );

      expect(
          () => callingRepository.answerCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.answerCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );

      expect(
          () => callingRepository.answerCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.answerCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(Exception());

      expect(
          () => callingRepository.answerCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.answerCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".createCall()", () {
    test("Should return the call data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.createCall()).thenAnswer(
        (_) => Future.value({
          "id": "123456",
          "target_volunteer_ids": [
            "ab",
            "cd",
          ],
          "rtc_channel_id": "abcd",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "456",
            "volunteer_id": "123",
          },
          "role": "caller",
          "state": "waiting",
        }),
      );

      Call call = await callingRepository.createCall();

      expect(
        call,
        const Call(
          id: "123456",
          rtcChannelID: "abcd",
          settings: CallSetting(
            enableFlashlight: false,
            enableFlip: false,
          ),
          users: UserCall(
            blindID: "456",
            volunteerID: "123",
          ),
          state: CallState.waiting,
        ),
      );

      verify(authRepository.uid);
      verify(callingProvider.createCall());
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.createCall(), throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.createCall();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.createCall()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(
          () => callingRepository.createCall(), throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.createCall();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.createCall()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(
          () => callingRepository.createCall(), throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.createCall();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.createCall()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );
      expect(
          () => callingRepository.createCall(), throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.createCall();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.createCall()).thenThrow(Exception());
      expect(
          () => callingRepository.createCall(), throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.createCall();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".declineCall()", () {
    String callID = "123";
    String blindID = "12345";

    test("Should return the call data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(
        callingProvider.declineCall(
          callID: callID,
          blindID: blindID,
        ),
      ).thenAnswer(
        (_) => Future.value({
          "id": "123456",
          "target_volunteer_ids": [
            "ab",
            "cd",
          ],
          "rtc_channel_id": "abcd",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "456",
            "volunteer_id": "123",
          },
          "role": "caller",
          "state": "waiting",
        }),
      );

      Call? call = await callingRepository.declineCall(
        callID: callID,
        blindID: blindID,
      );

      expect(
        call,
        const Call(
          id: "123456",
          rtcChannelID: "abcd",
          settings: CallSetting(
            enableFlashlight: false,
            enableFlip: false,
          ),
          users: UserCall(
            blindID: "456",
            volunteerID: "123",
          ),
          state: CallState.waiting,
        ),
      );

      verify(authRepository.uid);
      verify(callingProvider.getDeclinedCallID());
      verify(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      ));
      verify(callingProvider.setDeclinedCallID(jsonEncode([callID])));
    });

    test("Should return null when call ID has been declined", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.getDeclinedCallID()).thenAnswer(
        (_) => Future.value(jsonEncode([callID])),
      );

      Call? call = await callingRepository.declineCall(
        callID: callID,
        blindID: blindID,
      );

      expect(call, isNull);

      verify(authRepository.uid);
      verify(callingProvider.getDeclinedCallID());
      verifyNever(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      ));
      verifyNever(callingProvider.setDeclinedCallID(any));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.declineCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.declineCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );

      expect(
          () => callingRepository.declineCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.declineCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );

      expect(
          () => callingRepository.declineCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.declineCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );

      expect(
          () => callingRepository.declineCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.declineCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      )).thenThrow(Exception());

      expect(
          () => callingRepository.declineCall(
                callID: callID,
                blindID: blindID,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.declineCall(
          callID: callID,
          blindID: blindID,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".endCall()", () {
    String callID = "123";

    test("Should return the call data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.endCall(callID)).thenAnswer(
        (_) => Future.value({
          "id": "123456",
          "target_volunteer_ids": [
            "ab",
            "cd",
          ],
          "rtc_channel_id": "abcd",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "456",
            "volunteer_id": "123",
          },
          "role": "caller",
          "state": "waiting",
        }),
      );

      Call? call = await callingRepository.endCall(callID);

      expect(
        call,
        const Call(
          id: "123456",
          rtcChannelID: "abcd",
          settings: CallSetting(
            enableFlashlight: false,
            enableFlip: false,
          ),
          users: UserCall(
            blindID: "456",
            volunteerID: "123",
          ),
          state: CallState.waiting,
        ),
      );

      verify(authRepository.uid);
      verify(callingProvider.getEndedCallID());
      verify(callingProvider.endCall(callID));
      verify(callingProvider.setEndedCallID(jsonEncode([callID])));
    });

    test("Should return null when call ID has been ended", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.getEndedCallID()).thenAnswer(
        (_) => Future.value(jsonEncode([callID])),
      );

      Call? call = await callingRepository.endCall(callID);

      expect(call, isNull);

      verify(authRepository.uid);
      verify(callingProvider.getEndedCallID());
      verifyNever(callingProvider.endCall(callID));
      verifyNever(callingProvider.setEndedCallID(any));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => callingRepository.endCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.endCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.endCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(() => callingRepository.endCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.endCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.endCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(() => callingRepository.endCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.endCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.endCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );
      expect(() => callingRepository.endCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.endCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.endCall(callID)).thenThrow(Exception());
      expect(() => callingRepository.endCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.endCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".getCall()", () {
    String callID = "123";

    test("Should return the call data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.getCall(callID)).thenAnswer(
        (_) => Future.value({
          "id": "123456",
          "target_volunteer_ids": [
            "ab",
            "cd",
          ],
          "rtc_channel_id": "abcd",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "456",
            "volunteer_id": "123",
          },
          "role": "caller",
          "state": "waiting",
        }),
      );

      Call call = await callingRepository.getCall(callID);

      expect(
        call,
        const Call(
          id: "123456",
          rtcChannelID: "abcd",
          settings: CallSetting(
            enableFlashlight: false,
            enableFlip: false,
          ),
          users: UserCall(
            blindID: "456",
            volunteerID: "123",
          ),
          state: CallState.waiting,
        ),
      );

      verify(authRepository.uid);
      verify(callingProvider.getCall(callID));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => callingRepository.getCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(() => callingRepository.getCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(() => callingRepository.getCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCall(callID)).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );
      expect(() => callingRepository.getCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCall(callID)).thenThrow(Exception());
      expect(() => callingRepository.getCall(callID),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCall(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".getCallHistory()", () {
    test("Should return the call history data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.getCallHistory()).thenAnswer(
        (_) => Future.value([
          {
            "id": "1234",
            "created_at": "2023-02-11T14:12:06.182067",
            "ended_at": "2023-02-11T14:12:06.182067",
            "state": "waiting",
            "role": "caller",
            "remote_user": {
              "id": "123",
              "avatar": {
                "url": {
                  "small": "small.png",
                  "medium": "medium.png",
                  "large": "large.png",
                  "original": "original.png",
                }
              },
              "activity": {
                "online": true,
                "last_seen": "2023-02-11T14:12:06.182067",
              },
              "date_of_birth": "2023-02-11T14:12:06.182067",
              "gender": "male",
              "language": ["id", "en"],
              "name": "Firgia",
              "info": {
                "date_joined": "2023-02-11T14:12:06.182067",
                "list_of_call_years": ["2022", "2023"],
                "total_calls": 12,
                "total_friends": 13,
                "total_visitors": 14,
              },
              "type": "volunteer",
            },
          }
        ]),
      );

      List<CallHistory> call = await callingRepository.getCallHistory();

      expect(
        call,
        [
          CallHistory(
            id: "1234",
            createdAt: DateTime.tryParse("2023-02-11T14:12:06.182067"),
            endedAt: DateTime.tryParse("2023-02-11T14:12:06.182067"),
            state: CallState.waiting,
            role: CallRole.caller,
            remoteUser: User(
              id: "123",
              avatar: const URLImage(
                small: "small.png",
                medium: "medium.png",
                large: "large.png",
                original: "original.png",
              ),
              activity: UserActivity(
                online: true,
                lastSeen: DateTime.tryParse("2023-02-11T14:12:06.182067"),
              ),
              dateOfBirth: DateTime.tryParse("2023-02-11T14:12:06.182067"),
              gender: Gender.male,
              language: const ["id", "en"],
              name: "Firgia",
              info: UserInfo(
                dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
                listOfCallYears: const ["2022", "2023"],
                totalCalls: 12,
                totalFriends: 13,
                totalVisitors: 14,
              ),
              type: UserType.volunteer,
            ),
          )
        ],
      );

      verify(authRepository.uid);
      verify(callingProvider.getCallHistory());
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);

      expect(() => callingRepository.getCallHistory(),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallHistory();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallHistory()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );

      expect(() => callingRepository.getCallHistory(),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallHistory();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallHistory()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );

      expect(() => callingRepository.getCallHistory(),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallHistory();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallHistory()).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );

      expect(() => callingRepository.getCallHistory(),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallHistory();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallHistory()).thenThrow(Exception());

      expect(() => callingRepository.getCallHistory(),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallHistory();
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".getCallStatistic()", () {
    String year = "2003";
    String locale = "ar";

    test("Should return the call statistic data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      )).thenAnswer(
        (_) => Future.value({
          "total": 12,
          "monthly_statistics": [
            {
              "month": "april",
              "total": 12,
            },
          ],
        }),
      );

      CallStatistic call = await callingRepository.getCallStatistic(
        year: year,
        locale: locale,
      );

      expect(
        call,
        const CallStatistic(
          total: 12,
          monthlyStatistics: [
            CallDataMounthly(
              month: "april",
              total: 12,
            ),
          ],
        ),
      );

      verify(authRepository.uid);
      verify(
        callingProvider.getCallStatistic(
          year: year,
          locale: locale,
        ),
      );
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.getCallStatistic(
                year: year,
                locale: locale,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallStatistic(
          year: year,
          locale: locale,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );

      expect(
          () => callingRepository.getCallStatistic(
                year: year,
                locale: locale,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallStatistic(
          year: year,
          locale: locale,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );

      expect(
          () => callingRepository.getCallStatistic(
                year: year,
                locale: locale,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallStatistic(
          year: year,
          locale: locale,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );

      expect(
          () => callingRepository.getCallStatistic(
                year: year,
                locale: locale,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallStatistic(
          year: year,
          locale: locale,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      )).thenThrow(Exception());

      expect(
          () => callingRepository.getCallStatistic(
                year: year,
                locale: locale,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getCallStatistic(
          year: year,
          locale: locale,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".getRTCCredential()", () {
    String channelName = "sample";
    UserType userType = UserType.blind;
    RTCRole role = RTCRole.audience;

    test("Should return the RTCCredential data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      ).thenAnswer(
        (_) => Future.value({
          "token": "1234",
          "privilege_expired_time_seconds": 90,
          "channel_name": "sample-channel",
          "uid": 1,
        }),
      );

      RTCCredential call = await callingRepository.getRTCCredential(
        channelName: channelName,
        role: role,
        userType: userType,
      );

      expect(
        call,
        const RTCCredential(
          token: "1234",
          privilegeExpiredTimeSeconds: 90,
          channelName: "sample-channel",
          uid: 1,
        ),
      );

      verify(authRepository.uid);
      verify(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      );
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                userType: userType,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          userType: userType,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                userType: userType,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          userType: userType,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                userType: userType,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          userType: userType,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                userType: userType,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          userType: userType,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: anyNamed("uid"),
        ),
      ).thenThrow(Exception());
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                userType: userType,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          userType: userType,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });

  group(".onCallSettingUpdated()", () {
    String callID = "12345";

    test("Should emits call setting data", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onCallSettingUpdated(any)).thenAnswer(
        (_) => Stream.value(
          {
            "enable_flashlight": true,
            "enable_flip": false,
          },
        ),
      );

      Stream<CallSetting?> onCallSettingUpdated =
          callingRepository.onCallSettingUpdated(callID);

      expect(
        onCallSettingUpdated,
        emits(
          const CallSetting(
            enableFlashlight: true,
            enableFlip: false,
          ),
        ),
      );

      verify(callingProvider.onCallSettingUpdated(any));
    });

    test("Should emits null when data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onCallSettingUpdated(any)).thenAnswer(
        (_) => Stream.value(null),
      );

      Stream<CallSetting?> onCallSettingUpdated =
          callingRepository.onCallSettingUpdated(callID);

      expect(
        onCallSettingUpdated,
        emits(null),
      );

      verify(callingProvider.onCallSettingUpdated(any));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => callingRepository.onCallStateUpdated(callID),
          throwsA(isA<CallingFailure>()));

      try {
        callingRepository.onCallStateUpdated(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }

      verifyNever(callingProvider.onCallStateUpdated(any));
    });
  });

  group(".onCallStateUpdated()", () {
    String callID = "12345";

    test("Should emits call state data", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onCallStateUpdated(any)).thenAnswer(
        (_) => Stream.value("waiting"),
      );

      Stream<CallState?> onCallStateUpdated =
          callingRepository.onCallStateUpdated(callID);
      expect(
        onCallStateUpdated,
        emits(CallState.waiting),
      );

      verify(callingProvider.onCallStateUpdated(any));
    });

    test("Should emits null when data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onCallStateUpdated(any)).thenAnswer(
        (_) => Stream.value(null),
      );

      Stream<CallState?> onCallStateUpdated =
          callingRepository.onCallStateUpdated(callID);
      expect(
        onCallStateUpdated,
        emits(null),
      );

      verify(callingProvider.onCallStateUpdated(any));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => callingRepository.onCallStateUpdated(callID),
          throwsA(isA<CallingFailure>()));

      try {
        callingRepository.onCallStateUpdated(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }

      verifyNever(callingProvider.onCallStateUpdated(any));
    });
  });

  group(".onUserCallUpdated()", () {
    String callID = "12345";

    test("Should emits user call data", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onUserCallUpdated(any)).thenAnswer(
        (_) => Stream.value({
          "blind_id": "123",
          "volunteer_id": "456",
        }),
      );

      Stream<UserCall?> onUserCallUpdated =
          callingRepository.onUserCallUpdated(callID);

      expect(
        onUserCallUpdated,
        emits(
          const UserCall(
            blindID: "123",
            volunteerID: "456",
          ),
        ),
      );

      verify(callingProvider.onUserCallUpdated(any));
    });

    test("Should emits null when data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.onUserCallUpdated(any)).thenAnswer(
        (_) => Stream.value(null),
      );

      Stream<UserCall?> onUserCallUpdated =
          callingRepository.onUserCallUpdated(callID);

      expect(
        onUserCallUpdated,
        emits(null),
      );

      verify(callingProvider.onUserCallUpdated(any));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => callingRepository.onUserCallUpdated(callID),
          throwsA(isA<CallingFailure>()));

      try {
        callingRepository.onUserCallUpdated(callID);
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }

      verifyNever(callingProvider.onUserCallUpdated(any));
    });
  });

  group(".updateCallSettings()", () {
    String callID = "123";
    bool? enableFlashlight = false;
    bool? enableFlip = false;

    test("Should return normally", () async {
      when(authRepository.uid).thenReturn("1234");

      await callingRepository.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      );

      verify(authRepository.uid);
      verify(callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      ));
    });

    test("Should throw CallingFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(
          () => callingRepository.updateCallSettings(
                callID: callID,
                enableFlashlight: enableFlashlight,
                enableFlip: enableFlip,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unauthenticated);
      }
    });

    test(
        'Should throw CallingFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(
          () => callingRepository.updateCallSettings(
                callID: callID,
                enableFlashlight: enableFlashlight,
                enableFlip: enableFlip,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.invalidArgument);
      }
    });

    test(
        'Should throw CallingFailureCode.notFound when get not-found error '
        'from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );

      expect(
          () => callingRepository.updateCallSettings(
                callID: callID,
                enableFlashlight: enableFlashlight,
                enableFlip: enableFlip,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.notFound);
      }
    });

    test(
        'Should throw CallingFailureCode.permissionDenied when get '
        'permission-denied error from FirebaseFunctionsExceptions', () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      )).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );

      expect(
          () => callingRepository.updateCallSettings(
                callID: callID,
                enableFlashlight: enableFlashlight,
                enableFlip: enableFlip,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.permissionDenied);
      }
    });

    test("Should throw CallingFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      )).thenThrow(Exception());

      expect(
          () => callingRepository.updateCallSettings(
                callID: callID,
                enableFlashlight: enableFlashlight,
                enableFlip: enableFlip,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        );
      } on CallingFailure catch (e) {
        expect(e.code, CallingFailureCode.unknown);
      }
    });
  });
}
