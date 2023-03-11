/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _signInOnProcessKey => "sign_in_on_process";
String get _signInMethodKey => "sign_in_method";
String get _onSignIn => "onSignIn";

void main() {
  late AuthProvider authProvider;
  late MockFlutterSecureStorage secureStorage;
  late MockFunctionsProvider functionsProvider;
  late MockDeviceInfo deviceInfo;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    functionsProvider = getMockFunctionsProvider();
    deviceInfo = getMockDeviceInfo();
    authProvider = AuthProvider();
  });

  tearDown(() => unregisterLocator());

  group(".getAppleIDCredential()", () {
    test("Should return Apple ID Credential", () async {
      const credential = AuthorizationCredentialAppleID(
        authorizationCode: "1234",
        email: "test@gmail.com",
        familyName: "familyName",
        givenName: "givenName",
        identityToken: "123",
        state: "state",
        userIdentifier: "123",
      );

      when(deviceInfo.getAppleIDCredential(scopes: anyNamed("scopes")))
          .thenAnswer(
        (_) => Future.value(credential),
      );

      final result = await authProvider.getAppleIDCredential();

      expect(result, credential);
      verify(deviceInfo.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]));
    });

    test("Should throw exception if failure occurs", () async {
      const exception = SignInWithAppleNotSupportedException(message: "test");
      when(deviceInfo.getAppleIDCredential(scopes: anyNamed("scopes")))
          .thenThrow(exception);

      expect(
        () => authProvider.getAppleIDCredential(),
        throwsA(isA<SignInWithAppleNotSupportedException>()),
      );
    });
  });

  group(".getSignInMethod()", () {
    test("Should return sign in method based on storage data", () async {
      when(secureStorage.read(key: _signInMethodKey))
          .thenAnswer((_) => Future.value("google"));
      final result = await authProvider.getSignInMethod();
      expect(result, AuthMethod.google);
      verify(secureStorage.read(key: _signInMethodKey)).called(1);
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _signInMethodKey))
          .thenAnswer((_) => Future.value(null));
      final result = await authProvider.getSignInMethod();
      expect(result, null);
      verify(secureStorage.read(key: _signInMethodKey)).called(1);
    });
  });

  group(".isSignInOnProcess()", () {
    test("Should return isSignInOnProcess based on storage data", () async {
      when(secureStorage.read(key: _signInOnProcessKey))
          .thenAnswer((_) => Future.value("true"));
      final result = await authProvider.isSignInOnProcess();
      expect(result, true);
      verify(secureStorage.read(key: _signInOnProcessKey)).called(1);
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _signInOnProcessKey))
          .thenAnswer((_) => Future.value(null));
      final result = await authProvider.isSignInOnProcess();
      expect(result, null);
      verify(secureStorage.read(key: _signInOnProcessKey)).called(1);
    });
  });

  group(".setSignInMethod()", () {
    test("Should save data to storage", () async {
      await authProvider.setSignInMethod(AuthMethod.apple);
      verify(secureStorage.write(key: _signInMethodKey, value: "apple"))
          .called(1);
    });
  });

  group(".setIsSignInOnProcess()", () {
    test("Should save data to storage", () async {
      await authProvider.setIsSignInOnProcess(true);
      verify(secureStorage.write(key: _signInOnProcessKey, value: "true"))
          .called(1);
    });
  });

  group(".notifyIsSignInSuccessfully()", () {
    test("Should send the argument based on parameter ", () async {
      when(
        functionsProvider.call(
          functionsName: _onSignIn,
          parameters: anyNamed("parameters"),
        ),
      ).thenAnswer((_) => Future.value({}));

      await authProvider.notifyIsSignInSuccessfully(
        deviceID: "123",
        devicePlatform: DevicePlatform.ios,
        oneSignalPlayerID: "123456",
        voipToken: "abcdef",
      );

      verify(functionsProvider.call(functionsName: _onSignIn, parameters: {
        "device_id": "123",
        "player_id": "123456",
        "voip_token": "abcdef",
        "platform": "ios",
      }));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = FirebaseFunctionsException(
        message: "unknown",
        code: "unknown",
      );

      when(
        functionsProvider.call(
          functionsName: _onSignIn,
          parameters: anyNamed("parameters"),
        ),
      ).thenThrow(exception);

      expect(
        () => authProvider.notifyIsSignInSuccessfully(
          deviceID: "123",
          devicePlatform: DevicePlatform.ios,
          oneSignalPlayerID: "123456",
          voipToken: "abcdef",
        ),
        throwsA(exception),
      );
    });
  });
}
