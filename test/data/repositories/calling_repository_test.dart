/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

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
    callingRepository = CallingRepository();
  });

  tearDown(() => unregisterLocator());

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
}
