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
import '../../../data/data.dart';
import '../../../injection.dart';

part 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(const RouteInitial());

  final AuthRepository authRepository = sl<AuthRepository>();

  final Logger _logger = Logger("Route Cubit");

  void getTargetRoute() async {
    String targetName = "/";
    emit(const RouteLoading());
    _logger.info("Checking user signed in...");

    bool isSignedIn = await authRepository.isSignedIn();

    // TODO: Must add more validation
    // Check different device
    // Check is first time use app
    if (isSignedIn) {
      targetName = AppPages.home;
    } else {
      targetName = AppPages.signIn;
    }

    emit(RouteTarget(targetName));
    _logger.fine("The target route is $targetName");
  }
}
