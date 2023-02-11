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
import 'package:soca/data/repositories/user_repository.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late UserRepository userRepository;
  late MockUserProvider userProvider;
  late MockAuthRepository authRepository;

  setUp(() {
    registerLocator();
    userProvider = getMockUserProvider();
    authRepository = getMockAuthRepository();
    userRepository = UserRepository();
  });

  tearDown(() => unregisterLocator());

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

    test(
        "Should throw UserFailureCode.unknown when get not-found error from FirebaseFunctionsExceptions",
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
}
