/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';
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

    group("signInWithAple", () {
      const appleCredential = AuthorizationCredentialAppleID(
        authorizationCode: "1234",
        email: "test@gmail.com",
        familyName: "familyName",
        givenName: "givenName",
        identityToken: "123",
        state: "state",
        userIdentifier: "123",
      );

      test("Should return true when Successfully to sign in with Apple",
          () async {
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(false));
        when(authProvider.getAppleIDCredential())
            .thenAnswer((_) => Future.value(appleCredential));
        when(firebaseAuth.signInWithCredential(any))
            .thenAnswer((_) => Future.value(MockUserCredential()));

        final status = await authRepository.signInWithApple();
        expect(status, true);

        verifyInOrder([
          authProvider.setIsSignInOnProcess(true),
          authProvider.getAppleIDCredential(),
          firebaseAuth.signInWithCredential(any),
          authProvider.notifyIsSignInSuccessfully(
            deviceID: anyNamed("deviceID"),
            oneSignalPlayerID: anyNamed("oneSignalPlayerID"),
            voipToken: anyNamed("voipToken"),
            devicePlatform: anyNamed("devicePlatform"),
          ),
          authProvider.setIsSignInOnProcess(false),
        ]);
      });

      test("Should return false if has been signed in", () async {
        when(firebaseAuth.currentUser).thenReturn(MockUser());
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(false));

        final status = await authRepository.signInWithApple();
        expect(status, false);

        verify(authProvider.isSignInOnProcess());
        verify(firebaseAuth.currentUser);
      });

      test("Should throw SignInWithAppleFailure when a failure occurs.",
          () async {
        when(authProvider.getAppleIDCredential()).thenThrow(Exception());

        expect(() => authRepository.signInWithApple(),
            throwsA(isA<SignInWithAppleFailure>()));
      });
    });
    group("signInWithGoogle", () {
      const accessToken = 'access-token';
      const idToken = 'id-token';
      final googleSignInAuthentication = MockGoogleSignInAuthentication();
      final googleSignInAccount = MockGoogleSignInAccount();

      test("Should return true when Successfully to sign in with Google",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(false));
        when(googleSignInAuthentication.accessToken).thenReturn(accessToken);
        when(googleSignInAuthentication.idToken).thenReturn(idToken);
        when(googleSignInAccount.authentication)
            .thenAnswer((_) => Future.value(googleSignInAuthentication));
        when(googleSignIn.signIn())
            .thenAnswer((_) => Future.value(googleSignInAccount));
        when(firebaseAuth.signInWithCredential(any))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(firebaseAuth.signInWithPopup(any))
            .thenAnswer((_) => Future.value(MockUserCredential()));

        final status = await authRepository.signInWithGoogle();
        expect(status, true);

        verifyInOrder([
          googleSignIn.isSignedIn(),
          authProvider.setIsSignInOnProcess(true),
          googleSignIn.signIn(),
          authProvider.notifyIsSignInSuccessfully(
            deviceID: anyNamed("deviceID"),
            oneSignalPlayerID: anyNamed("oneSignalPlayerID"),
            voipToken: anyNamed("voipToken"),
            devicePlatform: anyNamed("devicePlatform"),
          ),
          authProvider.setIsSignInOnProcess(false),
        ]);
      });

      test("Should return false if has been signed in", () async {
        when(firebaseAuth.currentUser).thenReturn(MockUser());
        when(authProvider.isSignInOnProcess())
            .thenAnswer((_) => Future.value(false));
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));

        final status = await authRepository.signInWithGoogle();

        expect(status, false);
        verify(firebaseAuth.currentUser);
        verify(authProvider.isSignInOnProcess());
        verify(googleSignIn.isSignedIn());
      });

      test("Should return false when GoogleSignInAccount is not available",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(false));
        when(googleSignIn.signIn()).thenAnswer((_) => Future.value(null));

        final status = await authRepository.signInWithGoogle();

        expect(status, false);

        verify(googleSignIn.isSignedIn());
        verify(authProvider.setIsSignInOnProcess(true));
        verify(googleSignIn.signIn());
      });

      test("Should throw SignInWithGoogleFailure when a failure occurs.",
          () async {
        when(googleSignIn.isSignedIn()).thenThrow(Exception());

        expect(() => authRepository.signInWithGoogle(),
            throwsA(isA<SignInWithGoogleFailure>()));
      });

      test(
          "Should throw SignInWithGoogleFailure and sign out from Google when user on Firebase Auth is disabled.",
          () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(false));
        when(googleSignInAuthentication.accessToken).thenReturn(accessToken);
        when(googleSignInAuthentication.idToken).thenReturn(idToken);
        when(googleSignInAccount.authentication)
            .thenAnswer((_) => Future.value(googleSignInAuthentication));
        when(googleSignIn.signIn())
            .thenAnswer((_) => Future.value(googleSignInAccount));
        when(firebaseAuth.signInWithCredential(any))
            .thenThrow(FirebaseAuthException(code: "user-disabled"));

        expect(
          () async => authRepository.signInWithGoogle(),
          throwsA(isA<SignInWithGoogleFailure>()),
        );

        try {
          await authRepository.signInWithGoogle();
        } catch (e) {
          expect(e, isA<SignInWithGoogleFailure>());

          verifyInOrder([
            googleSignIn.isSignedIn(),
            authProvider.setIsSignInOnProcess(true),
            googleSignIn.signIn(),
            googleSignIn.disconnect(),
            googleSignIn.signOut(),
            authProvider.setIsSignInOnProcess(false),
          ]);
        }
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
