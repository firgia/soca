/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../injection.dart';

class AuthRepository {
  final AuthProvider _authProvider = sl<AuthProvider>();
  final DeviceProvider _deviceProvider = sl<DeviceProvider>();
  final FirebaseAuth _firebaseAuth = sl<FirebaseAuth>();
  final GoogleSignIn _googleSignIn = sl<GoogleSignIn>();
  final AuthProvider _signInProvider = sl<AuthProvider>();
  final UserProvider _userProvider = sl<UserProvider>();
  final Logger _logger = Logger("Auth Repository");

  String? get uid => _firebaseAuth.currentUser?.uid;

  /// Check current user is signed in
  ///
  /// Return `true` if user is signed in
  Future<bool> isSignedIn() async {
    _logger.info("Checking is signed in...");
    final signInOnProcess = await _signInProvider.isSignInOnProcess();

    if (signInOnProcess == true && _firebaseAuth.currentUser != null) {
      _logger.warning(
          "Signed in with unsuccessfully authentication process, trying to sign out automatically.");
      await signOut();
      return false;
    } else {
      final signedIn = _firebaseAuth.currentUser != null;

      if (signedIn) {
        _logger.fine("User is Signed in");
      } else {
        _logger.fine("User is not Signed in");
      }
      return signedIn;
    }
  }

  /// Sign in with Apple Account
  ///
  /// `Exception`
  ///
  /// A [SignInWithAppleFailure] maybe thrown when a failure occurs.
  ///
  ///
  /// Return `true` if sign in is successfully
  Future<bool> signInWithApple() async {
    try {
      if (await isSignedIn()) {
        _logger.info(
            "Sign-in with Apple is ignored because user already signed in.");
        return false;
      }

      await _authProvider.setIsSignInOnProcess(true);
      final appleIdCredential = await _authProvider.getAppleIDCredential();

      _logger.info(
          "Apple account has been selected, request sign in with Apple credential...");

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      await _firebaseAuth
          .signInWithCredential(credential)
          .timeout(const Duration(seconds: 60));

      _logger.info("Sign with credential is finished");
      await _authProvider.setSignInMethod(AuthMethod.apple);
      await _notifyIsSignInSuccessfully();
      await _authProvider.setIsSignInOnProcess(false);

      _logger.finest("Successfully to sign in with Apple Account");
      return true;
    } on Exception catch (e) {
      await _authProvider.setIsSignInOnProcess(false);
      throw SignInWithAppleFailure.fromException(e);
    } catch (e) {
      await _authProvider.setIsSignInOnProcess(false);
      throw const SignInWithAppleFailure();
    }
  }

  /// Sign in with Google Account
  ///
  /// `Exception`
  ///
  /// A [SignInWithGoogleFailure] maybe thrown when a failure occurs.
  ///
  ///
  /// Return `true` if sign in is successfully
  Future<bool> signInWithGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn() && await isSignedIn()) {
        _logger.info(
            "Sign-in with Google is ignored because user already signed in.");
        return false;
      }

      await _signInProvider.setIsSignInOnProcess(true);
      var user = _googleSignIn.currentUser;
      user ??= await _googleSignIn.signIn();

      if (user != null) {
        _logger.info(
            "Google account has been selected, Request sign in with Google credential...");

        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _firebaseAuth
            .signInWithCredential(credential)
            .timeout(const Duration(seconds: 60));
        await _signInProvider.setSignInMethod(AuthMethod.google);

        _logger.info("Sign with credential is finished");
        await _notifyIsSignInSuccessfully();
        await _signInProvider.setIsSignInOnProcess(false);

        _logger.finest("Successfully to sign in with Google Account");
        return true;
      } else {
        await _signInProvider.setIsSignInOnProcess(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-disabled") {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }

      await _signInProvider.setIsSignInOnProcess(false);
      throw SignInWithGoogleFailure.fromException(e);
    } on Exception catch (e) {
      await _signInProvider.setIsSignInOnProcess(false);
      throw SignInWithGoogleFailure.fromException(e);
    } catch (e) {
      await _signInProvider.setIsSignInOnProcess(false);
      throw const SignInWithGoogleFailure();
    }
  }

  /// Sign out from current account
  Future<void> signOut() async {
    final bool isGoogleSignIn = await _googleSignIn.isSignedIn();

    if (isGoogleSignIn) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      _logger.fine("Successfully to sign out from Google account");
    }

    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
      _logger.fine("Successfully to Sign out from Firebase Authentication");
    }

    await _signInProvider.setSignInMethod(null);
    await _signInProvider.setIsSignInOnProcess(false);
    _logger.fine("All sign out process 100% successfully");
  }

  /// Sign up
  ///
  /// `Exception`
  ///
  /// A [SignUpFailure] maybe thrown when a failure occurs.
  Future<void> signUp({
    required UserType type,
    required String name,
    required File profileImage,
    required DateTime dateOfBirth,
    required Gender gender,
    required DeviceLanguage? deviceLanguage,
    required List<Language> language,
  }) async {
    try {
      final uid = this.uid;
      final currentDeviceLanguage = deviceLanguage ?? DeviceLanguage.english;

      if (uid == null) {
        _logger.severe("Failed to create user, please sign in to continue");

        throw const SignUpFailure(
          code: SignUpFailureCode.unauthenticated,
          message:
              "The request does not have valid authentication credentials for the operation.",
        );
      }

      String deviceID = await _deviceProvider.getDeviceID();
      DevicePlatform devicePlatform =
          _deviceProvider.getPlatform() ?? DevicePlatform.android;
      String? voipToken = await _deviceProvider.getVoIP();
      String oneSignalPlayerID =
          await _deviceProvider.getOnesignalPlayerID() ?? "";

      await _userProvider.createUser(
        type: type,
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
        deviceLanguage: currentDeviceLanguage,
        language: language,
        deviceID: deviceID,
        oneSignalPlayerID: oneSignalPlayerID,
        voipToken: voipToken,
        devicePlatform: devicePlatform,
      );

      await _userProvider.uploadAvatar(
        file: profileImage,
        uid: uid,
      );

      _logger.finest("Successfully to sign up");
    } on SignUpFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw SignUpFailure.fromException(e);
    } catch (e) {
      throw const SignUpFailure();
    }
  }

  Future<void> _notifyIsSignInSuccessfully() async {
    _logger.info("Notify sign in successfully to server...");

    String deviceID = await _deviceProvider.getDeviceID();
    DevicePlatform devicePlatform =
        _deviceProvider.getPlatform() ?? DevicePlatform.android;
    String? voipToken = await _deviceProvider.getVoIP();
    String oneSignalPlayerID =
        await _deviceProvider.getOnesignalPlayerID() ?? "";

    await _authProvider.notifyIsSignInSuccessfully(
      deviceID: deviceID,
      oneSignalPlayerID: oneSignalPlayerID,
      voipToken: voipToken,
      devicePlatform: devicePlatform,
    );
  }
}
