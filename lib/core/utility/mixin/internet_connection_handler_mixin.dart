/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Feb 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../injection.dart';

mixin InternetConnectionHandlerMixin {
  StreamSubscription<InternetConnectionStatus>? _listener;

  void listenInternetConnection() {
    _listener = sl<InternetConnectionChecker>().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          onInternetConnected();
          break;
        case InternetConnectionStatus.disconnected:
          onInternetDisconnected();
          break;
      }
    });
  }

  void onInternetConnected() {}

  void onInternetDisconnected() {}

  void cancelInternetConnectionListener() async {
    await _listener?.cancel();
  }
}
