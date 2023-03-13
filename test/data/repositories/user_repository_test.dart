/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
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
  late UserRepository userRepository;
  late MockDeviceProvider deviceProvider;
  late MockUserProvider userProvider;
  late MockAuthRepository authRepository;

  setUp(() {
    registerLocator();
    deviceProvider = getMockDeviceProvider();
    userProvider = getMockUserProvider();
    authRepository = getMockAuthRepository();
    userRepository = UserRepository();
  });

  tearDown(() => unregisterLocator());

  group("()", () {
    test("Should call userProvider.cancelOnUserDeviceUpdated() when sign out",
        () async {
      when(authRepository.onSignOut)
          .thenAnswer((_) => Stream.value(DateTime.now()));

      UserRepository();
      verify(authRepository.onSignOut);
      await Future.delayed(const Duration(milliseconds: 500));
      verify(userProvider.cancelOnUserDeviceUpdated());
    });
  });

  group(".onUserDeviceUpdated", () {
    test("Should emits user device data", () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.onUserDeviceUpdated(uid: anyNamed("uid"))).thenAnswer(
        (_) => Stream.value({
          "id": "54321",
          "player_id": "12345",
          "language": "id",
        }),
      );

      Stream<UserDevice?> onUserDeviceUpdated =
          userRepository.onUserDeviceUpdated;
      expect(
        onUserDeviceUpdated,
        emits(
          const UserDevice(
            id: "54321",
            playerID: "12345",
            language: "id",
          ),
        ),
      );

      verify(userProvider.onUserDeviceUpdated(uid: anyNamed("uid")));
    });

    test("Should emits null when data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.onUserDeviceUpdated(uid: anyNamed("uid"))).thenAnswer(
        (_) => Stream.value(null),
      );

      Stream<UserDevice?> onUserDeviceUpdated =
          userRepository.onUserDeviceUpdated;
      expect(
        onUserDeviceUpdated,
        emits(null),
      );

      verify(userProvider.onUserDeviceUpdated(uid: anyNamed("uid")));
    });

    test("Should throw UserFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => userRepository.onUserDeviceUpdated,
          throwsA(isA<UserFailure>()));

      try {
        userRepository.onUserDeviceUpdated;
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unauthenticated);
      }

      verifyNever(userProvider.onUserDeviceUpdated(uid: anyNamed("uid")));
    });
  });

  group(".getProfile()", () {
    test("Should return the user data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(userProvider.getProfile(uid: anyNamed("uid"))).thenAnswer(
        (_) => Future.value(
          {
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
        ),
      );

      User user = await userRepository.getProfile();

      expect(
        user,
        User(
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
      );

      verify(authRepository.uid);
      verify(userProvider.getProfile(uid: anyNamed("uid")));
    });

    test("Should throw UserFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => userRepository.getProfile(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getProfile();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unauthenticated);
      }
    });

    test(
        "Should throw UserFailureCode.invalidArgument when get invalid-argument error from FirebaseFunctionsExceptions",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getProfile(uid: anyNamed("uid"))).thenThrow(
        FirebaseFunctionsException(message: "error", code: "invalid-argument"),
      );
      expect(() => userRepository.getProfile(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getProfile();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.invalidArgument);
      }
    });

    test(
        "Should throw UserFailureCode.notFound when get not-found error from FirebaseFunctionsExceptions",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getProfile(uid: anyNamed("uid"))).thenThrow(
        FirebaseFunctionsException(message: "error", code: "not-found"),
      );
      expect(() => userRepository.getProfile(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getProfile();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.notFound);
      }
    });

    test("Should throw UserFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getProfile(uid: anyNamed("uid")))
          .thenThrow(Exception());
      expect(() => userRepository.getProfile(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getProfile();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unknown);
      }
    });
  });

  group(".getUserDevice()", () {
    test("Should return the user device data", () async {
      when(authRepository.uid).thenReturn("1234");

      when(userProvider.getUserDevice(uid: anyNamed("uid"))).thenAnswer(
        (_) => Future.value(
          {
            "id": "54321",
            "player_id": "12345",
            "language": "id",
          },
        ),
      );

      UserDevice device = await userRepository.getUserDevice();

      expect(
        device,
        const UserDevice(
          id: "54321",
          playerID: "12345",
          language: "id",
        ),
      );

      verify(authRepository.uid);
      verify(userProvider.getUserDevice(uid: anyNamed("uid")));
    });

    test("Should throw UserFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => userRepository.getUserDevice(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getUserDevice();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unauthenticated);
      }
    });

    test("Should throw UserFailureCode.notFound when data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getUserDevice(uid: anyNamed("uid")))
          .thenAnswer((_) => Future.value(null));

      expect(() => userRepository.getUserDevice(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getUserDevice();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.notFound);
      }
    });

    test("Should throw UserFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getUserDevice(uid: anyNamed("uid")))
          .thenThrow(Exception());
      expect(() => userRepository.getUserDevice(), throwsA(isA<UserFailure>()));

      try {
        await userRepository.getUserDevice();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unknown);
      }
    });
  });

  group(".isDifferentDeviceID()", () {
    test("Should return true when device ID is different", () async {
      UserDevice userDevice = const UserDevice(id: "124");
      when(deviceProvider.getDeviceID()).thenAnswer(
        (_) => Future.value("1234"),
      );

      bool isDifferent = await userRepository.isDifferentDeviceID(userDevice);
      expect(isDifferent, true);
    });

    test("Should return false when device ID is same", () async {
      UserDevice userDevice = const UserDevice(id: "1234");
      when(deviceProvider.getDeviceID()).thenAnswer(
        (_) => Future.value("1234"),
      );

      bool isDifferent = await userRepository.isDifferentDeviceID(userDevice);
      expect(isDifferent, false);
    });
  });

  group(".useDifferentDevice()", () {
    test(
        "Should return true when deviceID on server is not same with deviceID on user device",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(deviceProvider.getDeviceID()).thenAnswer((_) => Future.value("1"));

      when(userProvider.getUserDevice(uid: anyNamed("uid"))).thenAnswer(
        (_) => Future.value(
          {
            "id": "54321",
            "player_id": "12345",
            "language": "id",
          },
        ),
      );

      bool useDifferentDevice = await userRepository.useDifferentDevice();
      expect(useDifferentDevice, true);

      verify(authRepository.uid);
      verify(userProvider.getUserDevice(uid: anyNamed("uid")));
    });

    test(
        "Should return false when deviceID on server are same with deviceID on user device",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(deviceProvider.getDeviceID())
          .thenAnswer((_) => Future.value("1111"));

      when(userProvider.getUserDevice(uid: anyNamed("uid"))).thenAnswer(
        (_) => Future.value(
          {
            "id": "1111",
            "player_id": "12345",
            "language": "id",
          },
        ),
      );

      bool useDifferentDevice = await userRepository.useDifferentDevice();
      expect(useDifferentDevice, false);

      verify(authRepository.uid);
      verify(userProvider.getUserDevice(uid: anyNamed("uid")));
    });

    test("Should return false when user device data is null", () async {
      when(authRepository.uid).thenReturn("1234");
      when(deviceProvider.getDeviceID())
          .thenAnswer((_) => Future.value("1111"));

      when(userProvider.getUserDevice(uid: anyNamed("uid"))).thenAnswer(
        (_) => Future.value(null),
      );

      bool useDifferentDevice = await userRepository.useDifferentDevice();
      expect(useDifferentDevice, false);

      verify(authRepository.uid);
      verify(userProvider.getUserDevice(uid: anyNamed("uid")));
    });

    test("Should throw UserFailureCode.unauthenticated when not signed in",
        () async {
      when(authRepository.uid).thenReturn(null);
      expect(() => userRepository.useDifferentDevice(),
          throwsA(isA<UserFailure>()));

      try {
        await userRepository.useDifferentDevice();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unauthenticated);
      }
    });

    test("Should throw UserFailureCode.unknown when get unknown exception",
        () async {
      when(authRepository.uid).thenReturn("1234");
      when(userProvider.getUserDevice(uid: anyNamed("uid")))
          .thenThrow(Exception());
      expect(() => userRepository.useDifferentDevice(),
          throwsA(isA<UserFailure>()));

      try {
        await userRepository.useDifferentDevice();
      } on UserFailure catch (e) {
        expect(e.code, UserFailureCode.unknown);
      }
    });
  });
}
