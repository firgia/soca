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
  final Logger _logger = Logger("User Repository");

  /// {@macro get_profile_user}
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
}
