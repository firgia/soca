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
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockAuthProvider authProvider;
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late AuthRepository authRepository;

  setUp(() {
    registerLocator();
    authProvider = getMockAuthProvider();
    firebaseAuth = getMockFirebaseAuth();
    googleSignIn = getMockGoogleSignIn();
    authRepository = AuthRepository();
  });

  tearDown(() => unregisterLocator());

  group("Functions", () {
    group("isSignedIn", () {
      test(
          "Should return true when a user has signed in and signed in the process has completed",
          () async {
        when(firebaseAuth.currentUser).thenReturn(MockUser());
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(false));

        final isSignedIn = await authRepository.isSignedIn();

        expect(isSignedIn, true);
        verify(firebaseAuth.currentUser);
        verify(authProvider.isSignInOnProcess());
      });

      test(
          "Should return false and try to sign out automatically when a user has signed in, but the signed-in process doesn't complete",
          () async {
        when(firebaseAuth.currentUser).thenReturn(MockUser());
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(true));

        final isSignedIn = await authRepository.isSignedIn();

        expect(isSignedIn, false);
        verify(firebaseAuth.currentUser);
        verify(authProvider.isSignInOnProcess());
        verify(firebaseAuth.signOut());
      });

      test("Should return false when a user not signed in", () async {
        when(firebaseAuth.currentUser).thenReturn(null);
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(false));

        final isSignedIn = await authRepository.isSignedIn();

        expect(isSignedIn, false);
        verify(firebaseAuth.currentUser);
        verify(authProvider.isSignInOnProcess());
      });
    });

    group("signOut", () {
      test(
          "Should call Google signOut() and disconnect() when sign in with Google",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));
        await authRepository.signOut();

        verify(googleSignIn.isSignedIn());
        verify(googleSignIn.disconnect());
        verify(googleSignIn.signOut());
      });

      test(
          "Should not call Google signOut() and disconnect() when not sign in with Google",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(false));
        await authRepository.signOut();

        verify(googleSignIn.isSignedIn());
        verifyNever(googleSignIn.disconnect());
        verifyNever(googleSignIn.signOut());
      });

      test("Should call Firebase signOut() when the current user is available",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(firebaseAuth.currentUser).thenReturn(MockUser());
        await authRepository.signOut();

        verify(firebaseAuth.signOut());
      });

      test(
          "Should not call Firebase signOut() when the current user is unavailable",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(firebaseAuth.currentUser).thenReturn(null);
        await authRepository.signOut();

        verifyNever(firebaseAuth.signOut());
      });

      test("Should remove signInMethod and set isSignInOnProcess to false",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(firebaseAuth.currentUser).thenReturn(null);
        await authRepository.signOut();

        verify(authProvider.setSignInMethod(null));
        verify(authProvider.setIsSignInOnProcess(false));
      });
    });
  });
}
