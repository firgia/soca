/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(const RouteInitial());

  final AuthRepository authRepository = sl<AuthRepository>();
  final UserRepository userRepository = sl<UserRepository>();

  final Logger _logger = Logger("Route Cubit");

  void getTargetRoute({
    bool checkDifferentDevice = true,
    UserDevice? userDevice,
  }) async {
    String targetName = "/";
    emit(const RouteLoading());
    _logger.info("Checking user signed in...");

    bool isSignedIn = await authRepository.isSignedIn();

    // TODO: Must add more validation
    // Check is first time use app
    if (isSignedIn) {
      RouteError? error;

      try {
        bool useDifferentDevice = false;

        if (checkDifferentDevice) {
          if (userDevice != null) {
            useDifferentDevice =
                await userRepository.isDifferentDeviceID(userDevice);
          } else {
            useDifferentDevice = await userRepository.useDifferentDevice();
          }
        }

        if (useDifferentDevice) {
          targetName = AppPages.unknownDevice;
          await authRepository.signOut();
        } else {
          await userRepository.getProfile();
          targetName = AppPages.home;
        }
      } on UserFailure catch (e) {
        if (e.code == UserFailureCode.notFound) {
          targetName = AppPages.signUp;
        } else {
          error = RouteError(e);
        }
      } on Exception catch (e) {
        error = RouteError(e);
      } catch (e) {
        error = const RouteError();
      }

      if (error != null) {
        _logger.fine("Error to define target route");
        emit(error);
        return;
      }
    } else {
      targetName = AppPages.signIn;
    }

    emit(RouteTarget(targetName));
    _logger.fine("The target route is $targetName");
  }
}
