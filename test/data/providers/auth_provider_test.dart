/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _signInOnProcessKey => "sign_in_on_process";
String get _signInMethodKey => "sign_in_method";

void main() {
  late AuthProvider authProvider;
  late MockFlutterSecureStorage secureStorage;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    authProvider = AuthProvider();
  });

  tearDown(() => unregisterLocator());

  group("Functions", () {
    group("getSignInMethod", () {
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

    group("isSignInOnProcess", () {
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

    group("setSignInMethod", () {
      test("Should save data to storage", () async {
        await authProvider.setSignInMethod(AuthMethod.apple);
        verify(secureStorage.write(key: _signInMethodKey, value: "apple"))
            .called(1);
      });
    });

    group("setIsSignInOnProcess", () {
      test("Should save data to storage", () async {
        await authProvider.setIsSignInOnProcess(true);
        verify(secureStorage.write(key: _signInOnProcessKey, value: "true"))
            .called(1);
      });
    });
  });
}
