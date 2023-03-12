/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _createUser => "createUser";
String get _getProfile => "getProfileUser";

void main() {
  late UserProvider userProvider;
  late MockDatabaseProvider databaseProvider;
  late MockFunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();
    databaseProvider = getMockDatabaseProvider();
    functionsProvider = getMockFunctionsProvider();
    userProvider = UserProvider();
  });

  tearDown(() => unregisterLocator());

  group(".createUser()", () {
    Future<void> runCreateUser() {
      return userProvider.createUser(
        type: UserType.volunteer,
        name: "Firgia",
        dateOfBirth: DateTime(2000, 4, 24),
        gender: Gender.male,
        deviceLanguage: DeviceLanguage.indonesian,
        languages: [
          const Language(code: "id"),
          const Language(code: "en"),
        ],
        deviceID: "12345-12345",
        oneSignalPlayerID: "123-123-123",
        voipToken: "12-12-12",
        devicePlatform: DevicePlatform.ios,
      );
    }

    test("Should send the argument based on parameter", () async {
      when(
        functionsProvider.call(
          functionsName: _createUser,
          parameters: anyNamed("parameters"),
        ),
      ).thenAnswer((_) => Future.value({}));

      await runCreateUser();

      verify(functionsProvider.call(
        functionsName: _createUser,
        parameters: {
          "name": "Firgia",
          "type": "volunteer",
          "date_of_birth": DateTime(2000, 4, 24).toIso8601String(),
          "gender": "male",
          "device": {
            "id": "12345-12345",
            "player_id": "123-123-123",
            "language": "id",
            "voip_token": "12-12-12",
            "platform": "ios",
          },
          "language": ["id", "en"],
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = FirebaseFunctionsException(
        message: "unknown",
        code: "unknown",
      );

      when(
        functionsProvider.call(
          functionsName: _createUser,
          parameters: anyNamed("parameters"),
        ),
      ).thenThrow(exception);

      expect(
        () => runCreateUser(),
        throwsA(exception),
      );
    });
  });

  group(".getProfile()", () {
    test("Should send the argument based on parameter", () async {
      when(
        functionsProvider.call(
          functionsName: _getProfile,
          parameters: anyNamed("parameters"),
        ),
      ).thenAnswer((_) => Future.value({}));

      await userProvider.getProfile(uid: "1234");

      verify(functionsProvider.call(
        functionsName: _getProfile,
        parameters: {"uid": "1234"},
      ));
    });

    test("Should not send the argument when empty parameter", () async {
      when(
        functionsProvider.call(
          functionsName: _getProfile,
          parameters: anyNamed("parameters"),
        ),
      ).thenAnswer((_) => Future.value({}));

      await userProvider.getProfile();

      verify(functionsProvider.call(
        functionsName: _getProfile,
        parameters: {},
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = FirebaseFunctionsException(
        message: "unknown",
        code: "unknown",
      );

      when(
        functionsProvider.call(
          functionsName: _getProfile,
          parameters: anyNamed("parameters"),
        ),
      ).thenThrow(exception);

      expect(
        () => userProvider.getProfile(),
        throwsA(exception),
      );
    });
  });

  group(".getUserDevice()", () {
    test("Should call databaseProvider.get()", () async {
      when(
        databaseProvider.get("users/1234/device"),
      ).thenAnswer((_) => Future.value({}));

      await userProvider.getUserDevice("1234");
      verify(databaseProvider.get("users/1234/device"));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        databaseProvider.get("users/1234/device"),
      ).thenThrow(exception);

      expect(
        () => userProvider.getUserDevice("1234"),
        throwsA(exception),
      );
    });
  });

  group(".uploadAvatar()", () {
    test("Should send the correct path", () async {
      File file = File("assets/images/raster/avatar.png");
      final task = await userProvider.uploadAvatar(file: file, uid: "1234");

      String name = task.ref.name;
      String extension = name.split(".").last;
      String path = task.ref.fullPath
          .replaceAll("gs://some-bucket/", "")
          .replaceAll(name, "");

      expect(path, "users/1234/avatar/");
      expect(extension, "png");
    });
  });
}
