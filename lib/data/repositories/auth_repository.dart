/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:soca/core/core.dart';
import '../../data/data.dart';

import '../../injection.dart';

class AuthRepository {
  final AuthProvider _authProvider = sl<AuthProvider>();
  final DeviceProvider _deviceProvider = sl<DeviceProvider>();
  final FirebaseAuth _firebaseAuth = sl<FirebaseAuth>();
  final GoogleSignIn _googleSignIn = sl<GoogleSignIn>();
  final AuthProvider _signInProvider = sl<AuthProvider>();
  final Logger _logger = Logger("Auth Repository");

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

  /// Sign in with Google Account
  ///
  /// `Exception`
  ///
  /// A [SignInWithGoogleFailure] maybe thrown when a failure occurs.
  ///
  ///
  /// Return `true` if sign in is successfully
  Future<bool?> signInWithGoogle() async {
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

        _logger.info(
            "Sign with credential is finished, sending sign in status to Realtime Database...");
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

  Future<void> _notifyIsSignInSuccessfully() async {
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
