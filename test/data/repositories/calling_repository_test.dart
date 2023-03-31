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

  group(".getRTCCredential()", () {
    String channelName = "sample";
    int uid = 2;
    RTCRole role = RTCRole.audience;

    test("Should return the RTCCredential data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(
        callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
        uid: uid,
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
          uid: uid,
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
                uid: uid,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
          uid: uid,
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                uid: uid,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
          uid: uid,
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                uid: uid,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
          uid: uid,
        ),
      ).thenThrow(
        FirebaseFunctionsException(message: "error", code: "permission-denied"),
      );
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                uid: uid,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
          uid: uid,
        ),
      ).thenThrow(Exception());
      expect(
          () => callingRepository.getRTCCredential(
                channelName: channelName,
                role: role,
                uid: uid,
              ),
          throwsA(isA<CallingFailure>()));

      try {
        await callingRepository.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
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
