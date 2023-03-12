/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';

import '../../core/core.dart';
import '../../injection.dart';
import '../data.dart';

class UserRepository {
  UserRepository();
  final AuthRepository _authRepository = sl<AuthRepository>();
  final UserProvider _userProvider = sl<UserProvider>();
  final DeviceProvider _deviceProvider = sl<DeviceProvider>();
  final Logger _logger = Logger("User Repository");

  /// {@macro get_profile_user}
  ///
  /// `Exception`
  ///
  /// A [UserFailure] maybe thrown when a failure occurs.
  Future<User> getProfile({String? uid}) async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get profile, please sign in to continue");

      throw const UserFailure(
        code: UserFailureCode.unauthenticated,
        message:
            "The request does not have valid authentication credentials for the operation.",
      );
    }

    try {
      _logger.info("Getting user data...");

      Map<String, dynamic> userMap = await _userProvider.getProfile(uid: uid);
      User user = User.fromMap(userMap);
      _logger.fine("Successfully to get user data");

      return user;
    } on UserFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw UserFailure.fromException(e);
    } catch (e) {
      throw const UserFailure();
    }
  }

  /// Get user device data from Realtime Database
  ///
  /// `Exception`
  ///
  /// A [UserFailure] maybe thrown when a failure occurs.
  Future<UserDevice> getUserDevice() async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get user device, please sign in to continue");

      throw const UserFailure(
        code: UserFailureCode.unauthenticated,
        message:
            "The request does not have valid authentication credentials for the operation.",
      );
    }

    try {
      _logger.info("Getting device data from Realtime Database...");
      dynamic response = await _userProvider.getUserDevice(uid: authUID);

      if (response != null) {
        _logger
            .fine("Successfully to Getting device data from Realtime Database");
        return UserDevice.fromMap(response);
      } else {
        throw const UserFailure(
          code: UserFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on UserFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw UserFailure.fromException(e);
    } catch (e) {
      throw const UserFailure();
    }
  }

  /// Check user use different device
  ///
  /// `Exception`
  ///
  /// A [UserFailure] maybe thrown when a failure occurs.
  Future<bool> useDifferentDevice() async {
    _logger.info("Check user use different device...");

    try {
      UserDevice userDevice = await getUserDevice();
      String deviceID = await _deviceProvider.getDeviceID();

      bool isDifferent = deviceID != userDevice.id;

      _logger.fine(
          "Successfully to check different device with status $isDifferent");
      return isDifferent;
    } on UserFailure catch (e) {
      if (e.code == UserFailureCode.notFound) {
        _logger
            .fine("Successfully to check different device with status false");
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
