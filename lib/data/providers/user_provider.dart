/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../../injection.dart';
import '../../core/core.dart';
import '../models/models.dart';
import 'database_provider.dart';
import 'functions_provider.dart';

abstract class UserProvider {
  /// Cancel subscribtion to user device data
  void cancelOnUserDeviceUpdated();

  /// Create new User data
  ///
  /// {@macro firebase_functions_exception}
  Future<void> createUser({
    required UserType type,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required DeviceLanguage deviceLanguage,
    required List<Language> languages,
    required String deviceID,
    required String oneSignalPlayerID,
    required String? voipToken,
    required DevicePlatform devicePlatform,
  });

  /// {@template get_profile_user}
  /// Get profile user
  ///
  /// If uid is null, the profile will return based on signed-in user
  /// {@endtemplate}
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> getProfile({String? uid});

  /// Get user device data based on [uid]
  Future<dynamic> getUserDevice({required String uid});

  /// Fires when the [uid] device data is updated.
  Stream<dynamic> onUserDeviceUpdated({required String uid});

  /// Uploading new avatar image
  Future<TaskSnapshot> uploadAvatar({
    required File file,
    required String uid,
  });
}

class UserProviderImpl implements UserProvider {
  final FirebaseStorage _firebaseStorage = sl<FirebaseStorage>();
  final DatabaseProvider _databaseProvider = sl<DatabaseProvider>();
  final FunctionsProvider _functionsProvider = sl<FunctionsProvider>();
  final Logger _logger = Logger("User Provider");

  StreamDatabase? _streamUserDevice;

  @override
  void cancelOnUserDeviceUpdated() {
    _streamUserDevice?.dispose();
  }

  @override
  Future<void> createUser({
    required UserType type,
    required String name,
    required DateTime dateOfBirth,
    required Gender gender,
    required DeviceLanguage deviceLanguage,
    required List<Language> languages,
    required String deviceID,
    required String oneSignalPlayerID,
    required String? voipToken,
    required DevicePlatform devicePlatform,
  }) async {
    _logger.info("Creating user data...");

    List<String> languageCodes = [];
    for (Language lang in languages) {
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

    _logger.fine("Successfully to create new user");
  }

  @override
  Future<dynamic> getProfile({String? uid}) async {
    return _functionsProvider.call(
      functionsName: FunctionName.getProfileUser,
      parameters: {if (uid != null) "uid": uid},
    );
  }

  @override
  Future<dynamic> getUserDevice({required String uid}) async {
    return await _databaseProvider.get("users/$uid/device");
  }

  @override
  Stream<dynamic> onUserDeviceUpdated({required String uid}) {
    StreamDatabase streamDatabase =
        _databaseProvider.onValue("users/$uid/device");

    _streamUserDevice = streamDatabase;
    return streamDatabase.streamController.stream;
  }

  @override
  Future<TaskSnapshot> uploadAvatar({
    required File file,
    required String uid,
  }) async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = path.basename(file.path);
    String extension = fileName.split(".").last;

    _logger.info("Uploading avatar image to Firebase Storage...");
    Reference firebaseStorageRef =
        _firebaseStorage.ref().child("users/$uid/avatar/$timeStamp.$extension");
    UploadTask task = firebaseStorageRef.putFile(file);

    return await task;
  }
}
