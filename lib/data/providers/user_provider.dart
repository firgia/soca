/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../../injection.dart';
import '../../core/core.dart';
import '../models/models.dart';
import 'functions_provider.dart';

class UserProvider {
  final FirebaseStorage _firebaseStorage = sl<FirebaseStorage>();
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final Logger _logger = Logger("User Provider");

  /// Create new User data
  ///
  /// {@macro firebase_functions_exception}
  Future<void> createUser({
    required String uid,
    required UserType type,
    required String name,
    required File profileImage,
    required DateTime dateOfBirth,
    required Gender gender,
    required DeviceLanguage deviceLanguage,
    required List<Language> language,
    required String deviceID,
    required String oneSignalPlayerID,
    required String? voipToken,
    required DevicePlatform devicePlatform,
  }) async {
    await _functionsProvider.call(
      functionsName: FunctionName.onSignIn,
      parameters: {
        "device_id": deviceID,
        "player_id": oneSignalPlayerID,
        "voip_token": voipToken,
        "platform": devicePlatform.name,
      },
    );

    _logger.info("Creating user data...");

    List<String> languageCodes = [];
    for (Language lang in language) {
      final code = lang.code;
      if (code != null) {
        languageCodes.add(code);
      }
    }

    if (languageCodes.isEmpty) {
      languageCodes.add(deviceLanguage.getLanguageCode());
    }

    await _functionsProvider
        .call(functionsName: FunctionName.createUser, parameters: {
      "name": name,
      "type": type.name,
      "date_of_birth": dateOfBirth.toIso8601String(),
      "gender": gender.name,
      "device": {
        "id": deviceID,
        "player_id": oneSignalPlayerID,
        "language": deviceLanguage.getLanguageCode(),
        "voip_token": voipToken,
        "platform": devicePlatform.name,
      },
      "language": languageCodes,
    });

    _logger.info("Creating user data is finished");

    // Uploading new profile image
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = path.basename(profileImage.path);
    String extension = fileName.split(".").last;

    _logger.info("Uploading avatar image to Firebase Storage");
    Reference firebaseStorageRef = _firebaseStorage
        .ref()
        .child("users")
        .child(uid)
        .child("avatar")
        .child('$timeStamp.$extension');
    await firebaseStorageRef.putFile(profileImage);
    _logger.fine("Successfully to create new user");
  }
}
