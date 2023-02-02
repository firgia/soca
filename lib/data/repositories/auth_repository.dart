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
import '../../data/data.dart';

import '../../injection.dart';

class AuthRepository {
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
}
