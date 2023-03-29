/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';

import '../../core/core.dart';
import '../../injection.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'auth_repository.dart';

class CallingRepository {
  final AuthRepository _authRepository = sl<AuthRepository>();
  final CallingProvider _callingProvider = sl<CallingProvider>();
  final Logger _logger = Logger("Calling Repository");

  /// {@macro create_call}
  ///
  /// `Exception`
  ///
  /// A [CallingFailure] maybe thrown when a failure occurs.
  Future<Call> createCall() async {
    String? authUID = _authRepository.uid;

    if (authUID == null) {
      _logger.severe("Failed to get user device, please sign in to continue");

      throw const CallingFailure(
        code: CallingFailureCode.unauthenticated,
        message:
            'The request does not have valid authentication credentials for '
            'the operation.',
      );
    }

    try {
      _logger.info("Creating call...");
      dynamic response = await _callingProvider.createCall();

      if (response != null) {
        _logger.fine("Successfully to create a call");
        return Call.fromMap(response);
      } else {
        throw const CallingFailure(
          code: CallingFailureCode.notFound,
          message: "Some requested document was not found.",
        );
      }
    } on CallingFailure catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw CallingFailure.fromException(e);
    } catch (e) {
      throw const CallingFailure();
    }
  }
}
