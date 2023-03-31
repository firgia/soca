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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockAuthProvider authProvider;
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockOneSignal oneSignal;
  late MockOneSignalProvider oneSignalProvider;
  late MockUserProvider userProvider;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    registerLocator();
    authProvider = getMockAuthProvider();
    firebaseAuth = getMockFirebaseAuth();
    googleSignIn = getMockGoogleSignIn();
    oneSignal = getMockOneSignal();
    oneSignalProvider = getMockOneSignalProvider();
    userProvider = getMockUserProvider();
    authRepository = AuthRepositoryImpl();
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

  group(".onSignOut", () {
    test(
      "Should emits onSignOut when signOut is called",
      () async {
        when(googleSignIn.isSignedIn()).thenAnswer((_) => Future.value(true));

        expectLater(authRepository.onSignOut, emits(isA<DateTime>()));
        await authRepository.signOut();
      },
    );
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

  group(".isSignedIn()", () {
    test(
        'Should return true when a user has signed in and signed in the process '
        'has completed', () async {
      when(firebaseAuth.currentUser).thenReturn(MockUser());
      when(authProvider.isSignInOnProcess())
          .thenAnswer((_) => Future.value(false));

      final isSignedIn = await authRepository.isSignedIn();

      expect(isSignedIn, true);
      verify(firebaseAuth.currentUser);
      verify(authProvider.isSignInOnProcess());
    });

    test(
        'Should return false and try to sign out automatically when a user has '
        'signed in, but the signed-in process doesnt complete', () async {
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

  group(".signInWithAple()", () {
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

  group(".signInWithGoogle()", () {
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
        'Should throw SignInWithGoogleFailure and sign out from Google when '
        'user on Firebase Auth is disabled.', () async {
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

  group(".signOut()", () {
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
        'Should not call Google signOut() and disconnect() when not sign in '
        'with Google', () async {
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

  group(".signUp()", () {
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

    test("Should not throw any exception when sign up successfully", () async {
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
        'Should throw SignUpFailureCode.invalidArgument when get '
        'invalid-argument error from FirebaseFunctionsExceptions', () async {
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
          languages: anyNamed("languages"),
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
          languages: anyNamed("languages"),
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

  group(".syncOneSignalTags()", () {
    test(
        'Should set the is_signed_in OneSignal tags to true when user signed in'
        ' and temp UID is null', () async {
      String playerID = "12345";
      String uid = "121212";

      when(oneSignalProvider.getLastUpdateUID())
          .thenAnswer((_) => Future.value(null));

      MockUser user = MockUser();
      when(user.uid).thenReturn(uid);
      when(firebaseAuth.currentUser).thenReturn(user);
      when(oneSignalProvider.getLastUpdateUID()).thenAnswer(
        (_) => Future.value(null),
      );

      when(oneSignal.getDeviceState()).thenAnswer(
        (_) => Future.value(
          OSDeviceState(
            {
              "hasNotificationPermission": true,
              "pushDisabled": true,
              "subscribed": true,
              "emailSubscribed": true,
              "smsSubscribed": true,
              "userId": playerID,
            },
          ),
        ),
      );

      await authRepository.syncOneSignalTags();

      Map<String, dynamic> tagPayload = {
        "uid": uid,
        "is_signed_in": "true",
        "player_id": playerID,
      };

      verify(oneSignalProvider.getLastUpdateUID());
      verify(oneSignal.getDeviceState());
      verify(oneSignal.sendTags(tagPayload));
      verify(oneSignalProvider.setLastUpdateUID(uid));
      verify(oneSignalProvider.setLastUpdateTag(tagPayload));
    });

    test(
        'Should not set the OneSignal tags when user signed in and temp UID is '
        'not null', () async {
      String uid = "121212";

      when(oneSignalProvider.getLastUpdateUID())
          .thenAnswer((_) => Future.value("1"));

      MockUser user = MockUser();
      when(user.uid).thenReturn(uid);
      when(firebaseAuth.currentUser).thenReturn(user);

      await authRepository.syncOneSignalTags();

      verify(oneSignalProvider.getLastUpdateUID());
      verifyNever(oneSignal.getDeviceState());
      verifyNever(oneSignal.sendTags(any));
      verifyNever(oneSignalProvider.setLastUpdateUID(uid));
      verifyNever(oneSignalProvider.setLastUpdateTag(any));
    });

    test(
        'Should set the is_signed_in OneSignal tag to false and delete UID when '
        'user not signed in and temp UID not null', () async {
      String playerID = "12345";
      String uid = "121212";
      Map<String, dynamic> tagPayload = {
        "uid": uid,
        "is_signed_in": "true",
        "player_id": playerID,
      };

      when(oneSignalProvider.getLastUpdateUID()).thenAnswer(
        (_) => Future.value(uid),
      );

      when(oneSignalProvider.getLastUpdateTag())
          .thenAnswer((_) => Future.value(tagPayload));

      await authRepository.syncOneSignalTags();

      verify(oneSignalProvider.getLastUpdateTag());
      verify(oneSignalProvider.getLastUpdateUID());

      verify(oneSignalProvider.setLastUpdateTag({"is_signed_in": false}));
      verify(oneSignal.sendTags({"is_signed_in": "false"}));
      verify(oneSignalProvider.deleteLastUpdateUID());
    });

    test(
        'Should not set the OneSignal tags when user not signed in and '
        'temp UID null', () async {
      when(oneSignalProvider.getLastUpdateUID()).thenAnswer(
        (_) => Future.value(null),
      );

      await authRepository.syncOneSignalTags();

      verify(oneSignalProvider.getLastUpdateUID());
      verifyNever(oneSignalProvider.getLastUpdateTag());
      verifyNever(oneSignalProvider.setLastUpdateTag({"is_signed_in": false}));
      verifyNever(oneSignal.sendTags({"is_signed_in": "false"}));
      verifyNever(oneSignalProvider.deleteLastUpdateUID());
    });

    test(
      'Should try to recall when internet connection connected and failed to '
      'send tags',
      () async {
        String playerID = "12345";
        String uid = "121212";

        when(oneSignalProvider.getLastUpdateUID())
            .thenAnswer((_) => Future.value(null));

        MockUser user = MockUser();
        when(user.uid).thenReturn(uid);
        when(firebaseAuth.currentUser).thenReturn(user);
        when(oneSignal.getDeviceState()).thenAnswer(
          (_) => Future.value(
            OSDeviceState(
              {
                "hasNotificationPermission": true,
                "pushDisabled": true,
                "subscribed": true,
                "emailSubscribed": true,
                "smsSubscribed": true,
                "userId": playerID,
              },
            ),
          ),
        );

        when(oneSignal.sendTags(any)).thenThrow(Exception());

        await authRepository.syncOneSignalTags();

        verify(oneSignalProvider.getLastUpdateUID());

        authRepository.onInternetConnected();

        await Future.delayed(const Duration(seconds: 1));
        verify(oneSignalProvider.getLastUpdateUID());
      },
    );

    test(
      'Should not to recall when internet connection connected and send tags '
      'has been successfully',
      () async {
        String playerID = "12345";
        String uid = "121212";

        when(oneSignalProvider.getLastUpdateUID())
            .thenAnswer((_) => Future.value(null));

        MockUser user = MockUser();
        when(user.uid).thenReturn(uid);
        when(firebaseAuth.currentUser).thenReturn(user);
        when(oneSignal.getDeviceState()).thenAnswer(
          (_) => Future.value(
            OSDeviceState(
              {
                "hasNotificationPermission": true,
                "pushDisabled": true,
                "subscribed": true,
                "emailSubscribed": true,
                "smsSubscribed": true,
                "userId": playerID,
              },
            ),
          ),
        );

        await authRepository.syncOneSignalTags();
        verify(oneSignalProvider.getLastUpdateUID());

        authRepository.onInternetConnected();
        await Future.delayed(const Duration(seconds: 1));
        verifyNever(oneSignalProvider.getLastUpdateUID());
      },
    );
  });
}
