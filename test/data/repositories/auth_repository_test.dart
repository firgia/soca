/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
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
  late MockUserProvider userProvider;
  late AuthRepository authRepository;

  setUp(() {
    registerLocator();
    authProvider = getMockAuthProvider();
    firebaseAuth = getMockFirebaseAuth();
    googleSignIn = getMockGoogleSignIn();
    userProvider = getMockUserProvider();
    authRepository = AuthRepository();
  });

  tearDown(() => unregisterLocator());

  group(".email", () {
    test("Should return email from FirebaseAuth.currentUser", () {
      MockUser user = MockUser();
      when(user.email).thenReturn("contact@firgia.com");
      when(firebaseAuth.currentUser).thenReturn(user);

      expect(authRepository.email, "contact@firgia.com");
      verify(user.email);
      verify(firebaseAuth.currentUser);
    });
  });

  group(".uid", () {
    test("Should return uid from FirebaseAuth.currentUser", () {
      MockUser user = MockUser();
      when(user.uid).thenReturn("1234");
      when(firebaseAuth.currentUser).thenReturn(user);

      expect(authRepository.uid, "1234");
      verify(user.uid);
      verify(firebaseAuth.currentUser);
    });
  });

  group(".getSignInMethod()", () {
    test("Should return data from AuthProvider.getSignInMethod()", () async {
      when(authProvider.getSignInMethod()).thenAnswer(
        (_) => Future.value(AuthMethod.apple),
      );

      AuthMethod? authMethod = await authRepository.getSignInMethod();

      expect(authMethod, AuthMethod.apple);
      verify(authProvider.getSignInMethod());
    });
  });

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

    group("signUp", () {
      late File file;

      setUp(() {
        file = File("assets/images/raster/avatar.png");
      });

      Future<void> runSignUp() async {
        await authRepository.signUp(
          type: UserType.volunteer,
          name: "Firgia",
          profileImage: file,
          dateOfBirth: DateTime(2000, 4, 24),
          gender: Gender.male,
          deviceLanguage: DeviceLanguage.indonesian,
          languages: [
            const Language(code: "id"),
            const Language(code: "en"),
          ],
        );
      }

      test("Should not throw any exception when sign up successfully",
          () async {
        MockUser user = MockUser();
        when(user.uid).thenReturn("123");
        when(firebaseAuth.currentUser).thenReturn(user);

        await runSignUp();

        verify(
          userProvider.createUser(
            type: UserType.volunteer,
            name: "Firgia",
            dateOfBirth: DateTime(2000, 4, 24),
            gender: Gender.male,
            deviceLanguage: DeviceLanguage.indonesian,
            languages: [
              const Language(code: "id"),
              const Language(code: "en"),
            ],
            deviceID: anyNamed("deviceID"),
            oneSignalPlayerID: anyNamed("oneSignalPlayerID"),
            voipToken: anyNamed("voipToken"),
            devicePlatform: anyNamed("devicePlatform"),
          ),
        );

        verify(userProvider.uploadAvatar(file: file, uid: "123"));
      });

      test("Should throw SignUpFailureCode.unauthenticated when not signed in",
          () async {
        when(firebaseAuth.currentUser).thenReturn(null);
        expect(() => runSignUp(), throwsA(isA<SignUpFailure>()));

        try {
          await runSignUp();
        } on SignUpFailure catch (e) {
          expect(e.code, SignUpFailureCode.unauthenticated);
        }
      });

      test(
          "Should throw SignUpFailureCode.invalidArgument when get invalid-argument error from FirebaseFunctionsExceptions",
          () async {
        MockUser user = MockUser();
        when(user.uid).thenReturn("123");
        when(firebaseAuth.currentUser).thenReturn(user);
        when(
          userProvider.createUser(
            type: anyNamed("type"),
            name: anyNamed("name"),
            dateOfBirth: anyNamed("dateOfBirth"),
            gender: anyNamed("gender"),
            deviceLanguage: anyNamed("deviceLanguage"),
            languages: anyNamed("language"),
            deviceID: anyNamed("deviceID"),
            oneSignalPlayerID: anyNamed("oneSignalPlayerID"),
            voipToken: anyNamed("voipToken"),
            devicePlatform: anyNamed("devicePlatform"),
          ),
        ).thenThrow(FirebaseFunctionsException(
            message: "error", code: "invalid-argument"));

        expect(() => runSignUp(), throwsA(isA<SignUpFailure>()));

        try {
          await runSignUp();
        } on SignUpFailure catch (e) {
          expect(e.code, SignUpFailureCode.invalidArgument);
        }
      });

      test("Should throw SignUpFailureCode.unknown when unknown exception",
          () async {
        MockUser user = MockUser();
        when(user.uid).thenReturn("123");
        when(firebaseAuth.currentUser).thenReturn(user);
        when(
          userProvider.createUser(
            type: anyNamed("type"),
            name: anyNamed("name"),
            dateOfBirth: anyNamed("dateOfBirth"),
            gender: anyNamed("gender"),
            deviceLanguage: anyNamed("deviceLanguage"),
            languages: anyNamed("language"),
            deviceID: anyNamed("deviceID"),
            oneSignalPlayerID: anyNamed("oneSignalPlayerID"),
            voipToken: anyNamed("voipToken"),
            devicePlatform: anyNamed("devicePlatform"),
          ),
        ).thenThrow(Exception());

        expect(() => runSignUp(), throwsA(isA<SignUpFailure>()));

        try {
          await runSignUp();
        } on SignUpFailure catch (e) {
          expect(e.code, SignUpFailureCode.unknown);
        }
      });
    });
  });
}
